// Dart
import 'dart:convert';

// Packages
import 'package:isar/isar.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:path_provider/path_provider.dart';

// Local
import 'globals.dart';
import '../../enums/rankings_categories.dart';
import '../../tools/pair.dart';
import '../../pogo_objects/pokemon_base.dart';
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/pokemon_typing.dart';
import '../../pogo_objects/move.dart';
import '../../pogo_objects/ratings.dart';
import '../../pogo_objects/cup.dart';
import '../../pogo_objects/tag.dart';
import '../../pogo_objects/pokemon_team.dart';
import '../data/cups.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All Isar database interaction is managed by this module.
-------------------------------------------------------------------------------
*/

class PogoRepository {
  static late final Isar pogoIsar;

  static Map<String, dynamic>? _rankingsJsonLookup;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    pogoIsar = await Isar.open([
      FastMoveSchema,
      ChargeMoveSchema,
      CupSchema,
      CupFilterSchema,
      PokemonBaseSchema,
      EvolutionSchema,
      TempEvolutionSchema,
      CupPokemonSchema,
      UserPokemonSchema,
      UserPokemonTeamSchema,
      OpponentPokemonTeamSchema,
      TagSchema,
    ], directory: dir.path);
  }

  static Future<void> clear() async {
    await pogoIsar.writeTxn(() async => await pogoIsar.clear());
  }

  // --------------------------------------------------------------------------
  // Pogo Data Source Synchronization
  // --------------------------------------------------------------------------

  static Stream<Pair<String, double>> loadPogoData(
      {bool forceUpdate = false}) async* {
    String loadMessagePrefix = ''; // For indicating testing

    String pathPrefix = '/';

    // TRUE FOR TESTING ONLY
    if (Globals.testing) {
      pathPrefix += 'test/';
      loadMessagePrefix = '[ TEST ]  ';
    }

    Box localSettings = await Hive.openBox('pogoSettings');

    // Implicitly invoke an app update via HTTPS
    if (forceUpdate) {
      await localSettings.put('timestamp', Globals.earliestTimestamp);
    }

    String message = loadMessagePrefix; // Message above progress bar

    final client = RetryClient(Client());

    try {
      // If an update is available
      // make an http request for the new data
      if (await _updateAvailable(localSettings, client, pathPrefix)) {
        message = '${loadMessagePrefix}Syncing Pogo Data...';

        Stopwatch stopwatch = Stopwatch();
        stopwatch.start();

        // Retrieve gamemaster
        String response = await client.read(Uri.https(Globals.pogoBucketDomain,
            '${Globals.pogoDataSourcePath}${pathPrefix}pogo_data_source.json'));

        yield Pair(a: message, b: .5);
        // If request was successful, load in the new gamemaster,
        final Map<String, dynamic> pogoDataSourceJson =
            Map<String, dynamic>.from(jsonDecode(response));

        stopwatch.stop();
        if (stopwatch.elapsed.inSeconds < 1) {
          await Future.delayed(
              Duration(seconds: 1 - stopwatch.elapsed.inSeconds));
        }

        yield Pair(a: message, b: .6);
        message = '${loadMessagePrefix}Syncing Rankings...';

        stopwatch.reset();
        stopwatch.start();

        await downloadRankings(
          client,
          pathPrefix,
          List<Map<String, dynamic>>.from(pogoDataSourceJson['cups']),
        );

        stopwatch.stop();
        if (stopwatch.elapsed.inSeconds < Globals.minLoadDisplaySeconds) {
          await Future.delayed(Duration(
              seconds:
                  Globals.minLoadDisplaySeconds - stopwatch.elapsed.inSeconds));
        }

        stopwatch.reset();
        stopwatch.start();

        yield Pair(a: message, b: .7);

        message = '${loadMessagePrefix}Syncing Local Data...';
        await rebuildFromJson(pogoDataSourceJson);

        if (stopwatch.elapsed.inSeconds < Globals.minLoadDisplaySeconds) {
          await Future.delayed(Duration(
              seconds:
                  Globals.minLoadDisplaySeconds - stopwatch.elapsed.inSeconds));
        }

        yield Pair(a: message, b: .9);
      }
    }

    // If HTTP request or json decoding fails
    catch (error) {
      message = '${loadMessagePrefix}Update Failed...';
      await Future.delayed(
          const Duration(seconds: Globals.minLoadDisplaySeconds));
      yield Pair(a: message, b: .9);
    } finally {
      client.close();
      localSettings.close();
    }

    yield Pair(a: message, b: 1.0);
    await Future.delayed(
        const Duration(seconds: Globals.minLoadDisplaySeconds));
  }

  static Future<bool> _updateAvailable(
      Box localSettings, Client client, String pathPrefix) async {
    bool updateAvailable = false;

    // Retrieve local timestamp
    final String timestampString =
        localSettings.get('timestamp') ?? Globals.earliestTimestamp;
    DateTime localTimeStamp = DateTime.parse(timestampString);

    // Retrieve server timestamp
    String response = await client.read(Uri.https(Globals.pogoBucketDomain,
        '${Globals.pogoDataSourcePath}${pathPrefix}timestamp.txt'));

    // If request is successful, compare timestamps to determine update
    final latestTimestamp = DateTime.tryParse(response);

    if (latestTimestamp != null &&
        !localTimeStamp.isAtSameMomentAs(latestTimestamp)) {
      updateAvailable = true;
      localTimeStamp = latestTimestamp;
    }

    // Store the timestamp in the local db
    await localSettings.put('timestamp', localTimeStamp.toString());

    return updateAvailable;
  }

  static Future<void> downloadRankings(
    Client client,
    String pathPrefix,
    List<Map<String, dynamic>> cupsJsonList,
  ) async {
    _rankingsJsonLookup ??= {};
    for (Map<String, dynamic> cupEntry in cupsJsonList) {
      if (cupEntry.containsKey('cupId')) {
        String cupId = cupEntry['cupId'];
        try {
          String response = await client.read(Uri.https(
              Globals.pogoBucketDomain,
              '${Globals.pogoDataSourcePath}${pathPrefix}rankings/$cupId.json'));
          _rankingsJsonLookup![cupId] = jsonDecode(response);
        } catch (_) {}
      }
    }
  }

  // --------------------------------------------------------------------------
  // JSON Initialization
  // --------------------------------------------------------------------------

  static Future<void> rebuildFromJson(Map<String, dynamic> json) async {
    await pogoIsar.writeTxn(() async {
      // Clear linked relationships
      await pogoIsar.evolutions.clear();
      await pogoIsar.tempEvolutions.clear();
      await pogoIsar.cupFilters.clear();

      // Load Pogo data collections
      await loadFastMoves(json['fastMoves']);
      await loadChargeMoves(json['chargeMoves']);
      await loadPokemon(json['pokemon']);
      await pogoIsar.cupPokemon.clear();
      await loadCups(json['cups']);
    });
  }

  static Future<void> loadFastMoves(List<dynamic> fastMovesJson) async {
    for (var moveJson in List<Map<String, dynamic>>.from(fastMovesJson)) {
      await pogoIsar.fastMoves.putByMoveId(FastMove.fromJson(moveJson));
    }
  }

  static Future<void> loadChargeMoves(List<dynamic> chargeMovesJson) async {
    for (var moveJson in List<Map<String, dynamic>>.from(chargeMovesJson)) {
      await pogoIsar.chargeMoves.putByMoveId(ChargeMove.fromJson(moveJson));
    }
  }

  static Future<void> loadPokemon(List<dynamic> pokemonJson) async {
    for (var pokemonEntry in List<Map<String, dynamic>>.from(pokemonJson)) {
      await _processPokemonEntry(pokemonEntry);
    }
  }

  static Future<void> _processPokemonEntry(
      Map<String, dynamic> pokemonEntry) async {
    // Standard Pokemon entries
    PokemonBase pokemon = PokemonBase.fromJson(pokemonEntry);
    List<FastMove> fastMoves = [];
    List<ChargeMove> chargeMoves = [];
    List<Evolution>? evolutions;

    if (pokemonEntry.containsKey('fastMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['fastMoves'])) {
        FastMove? move = await pogoIsar.fastMoves
            .where()
            .filter()
            .moveIdEqualTo(moveId)
            .findFirst();

        if (move != null) fastMoves.add(move);
      }
    }

    if (pokemonEntry.containsKey('chargeMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['chargeMoves'])) {
        ChargeMove? move = await pogoIsar.chargeMoves
            .filter()
            .moveIdEqualTo(moveId)
            .findFirst();

        if (move != null) chargeMoves.add(move);
      }
    }

    if (pokemonEntry.containsKey('eliteFastMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['eliteFastMoves'])) {
        FastMove? move =
            await pogoIsar.fastMoves.filter().moveIdEqualTo(moveId).findFirst();

        if (move != null) fastMoves.add(move);
      }
    }

    if (pokemonEntry.containsKey('eliteChargeMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['eliteChargeMoves'])) {
        ChargeMove? move = await pogoIsar.chargeMoves
            .filter()
            .moveIdEqualTo(moveId)
            .findFirst();

        if (move != null) chargeMoves.add(move);
      }
    }

    if (pokemonEntry.containsKey('shadow') &&
        pokemonEntry['shadow']['released']) {
      ChargeMove? move = await pogoIsar.chargeMoves
          .filter()
          .moveIdEqualTo(pokemonEntry['shadow']['purifiedChargeMove'])
          .findFirst();

      if (move != null) chargeMoves.add(move);
    }

    pokemon.fastMoves.addAll(fastMoves);
    pokemon.chargeMoves.addAll(chargeMoves);

    if (pokemonEntry.containsKey('evolutions')) {
      evolutions = List<Map<String, dynamic>>.from(pokemonEntry['evolutions'])
          .map<Evolution>((evolutionJson) => Evolution.fromJson(evolutionJson))
          .toList();

      await pogoIsar.evolutions.putAll(evolutions);
      pokemon.evolutions.addAll(evolutions);
    }

    if (pokemonEntry.containsKey('tempEvolutions')) {
      final evolutions =
          List<Map<String, dynamic>>.from(pokemonEntry['tempEvolutions'])
              .map<TempEvolution>(
                  (evolutionJson) => TempEvolution.fromJson(evolutionJson))
              .toList();

      await pogoIsar.tempEvolutions.putAll(evolutions);
      pokemon.tempEvolutions.addAll(evolutions);
    }

    await pogoIsar.basePokemon.putByPokemonId(pokemon);
    await pokemon.evolutions.save();
    await pokemon.tempEvolutions.save();
    await pokemon.fastMoves.save();
    await pokemon.chargeMoves.save();

    // Shadow entries
    if (pokemonEntry.containsKey('shadow')) {
      PokemonBase shadowPokemon =
          PokemonBase.fromJson(pokemonEntry, shadowForm: true);

      shadowPokemon.fastMoves.addAll(fastMoves);
      shadowPokemon.chargeMoves.addAll(chargeMoves);
      if (evolutions != null) {
        shadowPokemon.evolutions.addAll(evolutions);
      }
      ChargeMove? shadowMove = await pogoIsar.chargeMoves
          .filter()
          .moveIdEqualTo(pokemonEntry['shadow']['shadowChargeMove'])
          .findFirst();
      if (shadowMove != null) shadowPokemon.chargeMoves.add(shadowMove);

      await pogoIsar.basePokemon.putByPokemonId(shadowPokemon);
      await shadowPokemon.fastMoves.save();
      await shadowPokemon.chargeMoves.save();
      await shadowPokemon.evolutions.save();
    }

    // Temporary evolution entries
    if (pokemonEntry.containsKey('tempEvolutions')) {
      for (var overrideJson
          in List<Map<String, dynamic>>.from(pokemonEntry['tempEvolutions'])) {
        PokemonBase tempEvoPokemon = PokemonBase.tempEvolutionFromJson(
          pokemonEntry,
          overrideJson,
        );

        tempEvoPokemon.fastMoves.addAll(fastMoves);
        tempEvoPokemon.chargeMoves.addAll(chargeMoves);

        await pogoIsar.basePokemon.putByPokemonId(tempEvoPokemon);
        await tempEvoPokemon.fastMoves.save();
        await tempEvoPokemon.chargeMoves.save();
      }
    }
  }

  static Future<void> loadCups(List<dynamic> cupsJson) async {
    for (var cupEntry in List<Map<String, dynamic>>.from(cupsJson)) {
      final Cup cup = Cup.fromJson(cupEntry);

      if (cupEntry.containsKey('include')) {
        final List<CupFilter> includeFilters =
            List<Map<String, dynamic>>.from(cupEntry['include'])
                .map<CupFilter>((filter) => CupFilter.fromJson(filter))
                .toList();
        await pogoIsar.cupFilters.putAll(includeFilters);
        cup.includeFilters.addAll(includeFilters);
      }

      if (cupEntry.containsKey('exclude')) {
        final List<CupFilter> excludeFilters =
            List<Map<String, dynamic>>.from(cupEntry['exclude'])
                .map<CupFilter>((filter) => CupFilter.fromJson(filter))
                .toList();
        await pogoIsar.cupFilters.putAll(excludeFilters);
        cup.excludeFilters.addAll(excludeFilters);
      }

      if (_rankingsJsonLookup != null &&
          _rankingsJsonLookup!.containsKey(cup.cupId)) {
        final List<Id> rankingsIds = await _loadRankings(
          _rankingsJsonLookup![cup.cupId],
          cup.cp,
        );

        cup.rankings.addAll(
          (await pogoIsar.cupPokemon.getAll(rankingsIds))
              .whereType<CupPokemon>(),
        );
      }

      await pogoIsar.cups.putByCupId(cup);
      await cup.includeFilters.save();
      await cup.excludeFilters.save();
      if (_rankingsJsonLookup != null) {
        await cup.rankings.save();
      }
    }
  }

  static Future<List<Id>> _loadRankings(
    List<dynamic> rankingsJson,
    int cp,
  ) async {
    List<Id> rankingsIds = [];

    for (var rankingsEntry in List<Map<String, dynamic>>.from(rankingsJson)) {
      final List<String> selectedChargeMoveIds =
          List<String>.from(rankingsEntry['idealMoveset']['chargeMoves']);

      final PokemonBase? pokemon = await pogoIsar.basePokemon
          .filter()
          .pokemonIdEqualTo(rankingsEntry['pokemonId'])
          .findFirst();

      if (pokemon == null) continue;

      final rankedPokemon = CupPokemon(
        ratings: Ratings.fromJson(rankingsEntry['ratings']),
        ivs: pokemon.getIvs(cp),
        selectedFastMoveId: rankingsEntry['idealMoveset']['fastMove'],
        selectedChargeMoveIds: selectedChargeMoveIds,
        base: pokemon,
      );

      rankingsIds.add(await pogoIsar.cupPokemon.put(rankedPokemon));
      await rankedPokemon.base.save();
    }

    return rankingsIds;
  }

  // --------------------------------------------------------------------------
  // Import / Export
  // --------------------------------------------------------------------------

  static Future<Map<String, dynamic>> exportUserDataToJson() async {
    final Map<String, dynamic> userDataJson = {};
    final List<Map<String, dynamic>> teamsJson = [];
    final List<Map<String, dynamic>> tagsJson = [];

    for (var team in await pogoIsar.userPokemonTeams.where().findAll()) {
      teamsJson.add(team.toExportJson());
    }

    for (var tag in await pogoIsar.tags.where().findAll()) {
      tagsJson.add(tag.toExportJson());
    }

    userDataJson['teams'] = teamsJson;
    userDataJson['tags'] = tagsJson;
    return userDataJson;
  }

  static Future<void> importUserDataFromJson(Map<String, dynamic> json) async {
    for (var tagEntry in List<Map<String, dynamic>>.from(json['tags'])) {
      updateTagSync(Tag.fromJson(tagEntry));
    }

    for (var teamEntry in List<Map<String, dynamic>>.from(json['teams'])) {
      final team = UserPokemonTeam.fromJson(teamEntry);
      final List<UserPokemon> pokemonTeam = await _processUserPokemonTeam(
          List<Map<String, dynamic>>.from(teamEntry['pokemonTeam']));

      for (var opponentEntry
          in List<Map<String, dynamic>>.from(teamEntry['opponents'])) {
        final opponent = OpponentPokemonTeam.fromJson(opponentEntry);
        final List<UserPokemon> opponentPokemonTeam =
            await _processUserPokemonTeam(
                List<Map<String, dynamic>>.from(opponentEntry['pokemonTeam']));

        if (opponentEntry.containsKey('tag')) {
          opponent.tag.value = pogoIsar.tags.getByNameSync(teamEntry['tag']);
        }

        createPokemonTeamSync(opponent);
        updatePokemonTeamSync(opponent, newPokemonTeam: opponentPokemonTeam);
        team.opponents.add(opponent);
      }

      if (teamEntry.containsKey('tag')) {
        team.tag.value = pogoIsar.tags.getByNameSync(teamEntry['tag']);
      }
      createPokemonTeamSync(team);
      updatePokemonTeamSync(team, newPokemonTeam: pokemonTeam);
    }
  }

  static Future<List<UserPokemon>> _processUserPokemonTeam(
      List<Map<String, dynamic>> pokemonTeamJson) async {
    List<UserPokemon> pokemonTeam = [];

    for (var pokemonEntry in pokemonTeamJson) {
      final UserPokemon pokemon = UserPokemon.fromJson(pokemonEntry);
      pokemon.base.value = await pogoIsar.basePokemon
          .getByPokemonId(pokemonEntry['pokemonId'] as String);
      pokemonTeam.add(pokemon);
    }

    return pokemonTeam;
  }

  // --------------------------------------------------------------------------
  // Data Access
  // --------------------------------------------------------------------------

  static List<PokemonBase> getPokemonSync() {
    return pogoIsar.basePokemon.where().findAllSync();
  }

  static PokemonBase getPokemonById(String pokemonId) {
    return pogoIsar.basePokemon
            .filter()
            .pokemonIdEqualTo(pokemonId)
            .findFirstSync() ??
        PokemonBase.missingNo();
  }

  static List<Cup> getCupsSync() {
    return pogoIsar.cups.where().findAllSync();
  }

  static Cup getCupById(String cupId) {
    return pogoIsar.cups.filter().cupIdEqualTo(cupId).findFirstSync() ??
        getCupsSync().first;
  }

  static List<Tag> getTagsSync() {
    return pogoIsar.tags.where().sortByDateCreated().findAllSync();
  }

  static bool tagNameExists(String tagName) {
    return pogoIsar.tags.where().nameEqualTo(tagName).findFirstSync() != null;
  }

  static Id updateTagSync(Tag tag) {
    Id id = -1;
    pogoIsar.writeTxnSync(() {
      id = pogoIsar.tags.putSync(tag);
    });

    return id;
  }

  static void deleteTagSync(Id id) {
    pogoIsar.writeTxnSync(() => pogoIsar.tags.deleteSync(id));
  }

  static List<PokemonBase> getCupFilteredPokemonList(Cup cup) {
    final filteredPokemonList = pogoIsar.basePokemon
        .filter()
        .releasedEqualTo(true)
        .and()
        .fastMovesIsNotEmpty()
        .and()
        .chargeMovesIsNotEmpty()
        .findAllSync()
        .where((PokemonBase pokemon) =>
            cup.pokemonIsAllowed(pokemon) && !Cups.isBanned(pokemon, cup.cp))
        .toList();

    return filteredPokemonList;
  }

  // Get a list of Pokemon that contain one of the specified types
  // The rankings category
  // The list length will be up to the limit
  static Future<List<CupPokemon>> getCupPokemon(
    Cup cup,
    List<PokemonType> types,
    RankingsCategories rankingsCategory, {
    int limit = 20,
  }) async {
    List<CupPokemon> rankedList =
        await cup.getCupPokemonListAsync(rankingsCategory);

    // Filter the list to Pokemon that have one of the types in their typing
    // or their selected moveset
    rankedList = rankedList
        .where((pokemon) =>
            pokemon.getBase().hasType(types) ||
            pokemon.hasSelectedMovesetType(types))
        .toList();

    // There weren't enough Pokemon in this cup to satisfy the filtered limit
    if (rankedList.length < limit) {
      return rankedList;
    }

    return rankedList.getRange(0, limit).toList();
  }

  static Id updateUserPokemonSync(UserPokemon pokemon) {
    Id id = -1;
    pogoIsar.writeTxnSync(() => id = pogoIsar.userPokemon.putSync(pokemon));

    return id;
  }

  static UserPokemonTeam getUserTeamSync(Id id) {
    return pogoIsar.userPokemonTeams.getSync(id) ?? UserPokemonTeam();
  }

  static List<UserPokemonTeam> getUserTeamsSync({Tag? tag}) {
    if (tag == null) {
      return pogoIsar.userPokemonTeams
          .where()
          .sortByDateCreatedDesc()
          .findAllSync();
    }

    return pogoIsar.userPokemonTeams
        .filter()
        .tag((q) => q.nameEqualTo(tag.name))
        .sortByDateCreatedDesc()
        .findAllSync();
  }

  static List<OpponentPokemonTeam> getOpponentTeamsSync({Tag? tag}) {
    if (tag == null) {
      return pogoIsar.opponentPokemonTeams
          .where()
          .sortByDateCreatedDesc()
          .findAllSync();
    }

    return pogoIsar.opponentPokemonTeams
        .filter()
        .tag((q) => q.nameEqualTo(tag.name))
        .sortByDateCreatedDesc()
        .findAllSync();
  }

  static void createPokemonTeamSync(PokemonTeam team) {
    pogoIsar.writeTxnSync(() {
      if (team.runtimeType == UserPokemonTeam) {
        pogoIsar.userPokemonTeams.putSync(team as UserPokemonTeam);
      } else if (team.runtimeType == OpponentPokemonTeam) {
        pogoIsar.opponentPokemonTeams.putSync(team as OpponentPokemonTeam);
      }
    });
  }

  static Id updatePokemonTeamSync(
    PokemonTeam team, {
    bool updatePokemon = true,
    List<UserPokemon?>? newPokemonTeam,
  }) {
    Id id = -1;
    pogoIsar.writeTxnSync(() {
      if (team.runtimeType == UserPokemonTeam) {
        id = pogoIsar.userPokemonTeams.putSync(team as UserPokemonTeam);
      } else if (team.runtimeType == OpponentPokemonTeam) {
        id = pogoIsar.opponentPokemonTeams.putSync(team as OpponentPokemonTeam);
      }

      if (updatePokemon) {
        // Existing Pokemon Team
        if (newPokemonTeam == null) {
          for (var pokemon in team.getPokemonTeam()) {
            pogoIsar.userPokemon.putSync(pokemon);
          }
        }

        // New Pokemon Team
        else {
          int i = 0;
          List<UserPokemon> links = [];
          for (var pokemon in newPokemonTeam) {
            if (pokemon != null) {
              pokemon.teamIndex = i;
              pogoIsar.userPokemon.putSync(pokemon);
              links.add(pokemon);
            }
            ++i;
          }
          team.getPokemonTeam().updateSync(
                link: links,
                reset: true,
              );
        }
      }
    });

    return id;
  }

  static void deleteUserPokemonTeamSync(UserPokemonTeam userTeam) {
    for (OpponentPokemonTeam opponentTeam in userTeam.opponents) {
      deleteOpponentPokemonTeamSync(opponentTeam.id);
    }

    pogoIsar
        .writeTxnSync(() => pogoIsar.userPokemonTeams.deleteSync(userTeam.id));
  }

  static void deleteOpponentPokemonTeamSync(Id id) {
    pogoIsar.writeTxnSync(() => pogoIsar.opponentPokemonTeams.deleteSync(id));
  }

  static Future<void> clearUserData() async {
    await pogoIsar.writeTxn(() async {
      await pogoIsar.tags.clear();
      await pogoIsar.userPokemonTeams.clear();
      await pogoIsar.userPokemon.clear();
      await pogoIsar.opponentPokemonTeams.clear();
    });
  }
}
