// Dart
import 'dart:convert';

// Packages
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';

// Local
import 'globals.dart';
import '../enums/rankings_categories.dart';
import '../utils/pair.dart';
import '../model/pokemon_base.dart';
import '../model/pokemon.dart';
import '../model/pokemon_typing.dart';
import '../model/move.dart';
import '../model/ratings.dart';
import '../model/cup.dart';
import '../model/tag.dart';
import '../model/pokemon_team.dart';
import 'cups.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All Isar database interaction is managed by this module.
-------------------------------------------------------------------------------
*/

class PogoRepository {
  static late final Box fastMovesBox;
  static late final Box chargeMovesBox;
  static late final Box cupsBox;
  static late final Box basePokemonBox;
  static late final Box userPokemonTeamsBox;
  static late final Box opponentPokemonTeamsBox;
  static late final Box tagsBox;

  static Map<String, dynamic>? _rankingsJsonLookup;

  static Future<void> init() async {
    fastMovesBox = await Hive.openBox('fastMoves');
    chargeMovesBox = await Hive.openBox('chargeMoves');
    cupsBox = await Hive.openBox('cups');
    basePokemonBox = await Hive.openBox('basePokemon');
    userPokemonTeamsBox = await Hive.openBox('userPokemonTeams');
    opponentPokemonTeamsBox = await Hive.openBox('opponentPokemonTeams');
    tagsBox = await Hive.openBox('tags');
  }

  static Future<void> clear() async {
    Future.wait([
      fastMovesBox.clear(),
      chargeMovesBox.clear(),
      cupsBox.clear(),
      basePokemonBox.clear(),
      userPokemonTeamsBox.clear(),
      opponentPokemonTeamsBox.clear(),
      tagsBox.clear(),
    ]);
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
    // Load Pogo data collections
    await loadFastMoves(json['fastMoves']);
    await loadChargeMoves(json['chargeMoves']);
    await loadPokemon(json['pokemon']);
    await loadCups(json['cups']);
  }

  static Future<void> loadFastMoves(List<dynamic> fastMovesJson) async {
    for (var json in List<Map<String, dynamic>>.from(fastMovesJson)) {
      await fastMovesBox.put(json['moveId'], json);
    }
  }

  static Future<void> loadChargeMoves(List<dynamic> chargeMovesJson) async {
    for (var json in List<Map<String, dynamic>>.from(chargeMovesJson)) {
      await chargeMovesBox.put(json['moveId'], json);
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
    List<Evolution>? evolutions;

    if (pokemonEntry.containsKey('evolutions')) {
      evolutions = List<Map<String, dynamic>>.from(pokemonEntry['evolutions'])
          .map<Evolution>((evolutionJson) => Evolution.fromJson(evolutionJson))
          .toList();

      pokemon.evolutions.addAll(evolutions);
    }

    if (pokemonEntry.containsKey('tempEvolutions')) {
      final evolutions =
          List<Map<String, dynamic>>.from(pokemonEntry['tempEvolutions'])
              .map<TempEvolution>(
                  (evolutionJson) => TempEvolution.fromJson(evolutionJson))
              .toList();

      pokemon.tempEvolutions.addAll(evolutions);
    }

    await basePokemonBox.put(pokemon.pokemonId, pokemon.toJson());

    // Shadow entries
    if (pokemonEntry.containsKey('shadow')) {
      PokemonBase shadowPokemon =
          PokemonBase.fromJson(pokemonEntry, shadowForm: true);

      shadowPokemon.fastMoves.addAll(pokemon.fastMoves);
      shadowPokemon.chargeMoves.addAll(pokemon.chargeMoves);
      if (evolutions != null) {
        shadowPokemon.evolutions.addAll(evolutions);
      }

      final json =
          chargeMovesBox.get(pokemonEntry['shadow']['shadowChargeMove']);
      if (json != null) {
        shadowPokemon.chargeMoves
            .add(ChargeMove.fromJson(Map<String, dynamic>.from(json)));
      }

      await basePokemonBox.put(shadowPokemon.pokemonId, shadowPokemon.toJson());
    }

    // Temporary evolution entries
    if (pokemonEntry.containsKey('tempEvolutions')) {
      for (var overrideJson
          in List<Map<String, dynamic>>.from(pokemonEntry['tempEvolutions'])) {
        PokemonBase tempEvoPokemon = PokemonBase.tempEvolutionFromJson(
          pokemonEntry,
          overrideJson,
        );

        tempEvoPokemon.fastMoves.addAll(pokemon.fastMoves);
        tempEvoPokemon.chargeMoves.addAll(pokemon.chargeMoves);

        await basePokemonBox.put(
          tempEvoPokemon.pokemonId,
          tempEvoPokemon.toJson(),
        );
      }
    }
  }

  static Future<void> loadCups(List<dynamic> cupsJson) async {
    if (_rankingsJsonLookup == null) return;

    for (var cupEntry in List<Map<String, dynamic>>.from(cupsJson)) {
      if (_rankingsJsonLookup!.containsKey(cupEntry['cupId'])) {
        cupEntry['rankings'] = _rankingsJsonLookup![cupEntry['cupId']];
        final Cup cup = Cup.fromJson(cupEntry);
        await cupsBox.put(cup.cupId, cup.toJson());
      }
    }
  }

  static Future<List<CupPokemon>> _loadRankings(Cup cup) async {
    final List<dynamic> rankingsJson = _rankingsJsonLookup![cup.cupId];
    final int cp = cup.cp;

    List<CupPokemon> cupPokemon = [];

    for (var rankingsEntry in List<Map<String, dynamic>>.from(rankingsJson)) {
      final List<String> selectedChargeMoveIds =
          List<String>.from(rankingsEntry['idealMoveset']['chargeMoves']);

      final json = basePokemonBox.get(rankingsEntry['pokemonId']);
      if (json == null) continue;

      final PokemonBase pokemon = PokemonBase.fromJson(json);
      final rankedPokemon = CupPokemon(
        ratings: Ratings.fromJson(rankingsEntry['ratings']),
        ivs: pokemon.getIvs(cp),
        selectedFastMoveId: rankingsEntry['idealMoveset']['fastMove'],
        selectedChargeMoveIds: selectedChargeMoveIds,
        base: pokemon,
      );

      cupPokemon.add(rankedPokemon);
    }

    return cupPokemon;
  }

  // --------------------------------------------------------------------------
  // Import / Export
  // --------------------------------------------------------------------------

  static Future<Map<String, dynamic>> exportUserDataToJson() async {
    final Map<String, dynamic> userDataJson = {};
    final List<Map<String, dynamic>> teamsJson = [];
    final List<Map<String, dynamic>> tagsJson = [];

    for (var team in userPokemonTeamsBox.values) {
      teamsJson.add(team);
    }

    for (var tag in tagsBox.values) {
      tagsJson.add(tag);
    }

    userDataJson['teams'] = teamsJson;
    userDataJson['tags'] = tagsJson;
    return userDataJson;
  }

  static Future<void> importUserDataFromJson(Map<String, dynamic> json) async {
    for (var tagEntry in List<Map<String, dynamic>>.from(json['tags'])) {
      putTag(Tag.fromJson(tagEntry));
    }

    for (var teamEntry in List<Map<String, dynamic>>.from(json['teams'])) {
      final team = UserPokemonTeam.fromJson(teamEntry);

      for (var opponentEntry
          in List<Map<String, dynamic>>.from(teamEntry['opponents'])) {
        final opponent = OpponentPokemonTeam.fromJson(opponentEntry);

        if (opponentEntry.containsKey('tag')) {
          opponent.tag = tagsBox.get(teamEntry['tag']);
        }

        team.opponents.add(opponent);
      }

      if (teamEntry.containsKey('tag')) {
        team.tag = tagsBox.get(teamEntry['tag']);
      }
    }
  }

  // --------------------------------------------------------------------------
  // Data Access
  // --------------------------------------------------------------------------

  static FastMove getFastMoveById(String moveId) {
    final json = fastMovesBox.get(moveId);
    if (json == null) return FastMove.none;
    return FastMove.fromJson(Map<String, dynamic>.from(json));
  }

  static ChargeMove getChargeMoveById(String moveId) {
    final json = chargeMovesBox.get(moveId);
    if (json == null) return ChargeMove.none;
    return ChargeMove.fromJson(Map<String, dynamic>.from(json));
  }

  static List<PokemonBase> getPokemon() {
    List<PokemonBase> pokemon = [];
    for (var pokemonJson in basePokemonBox.values) {
      pokemon.add(PokemonBase.fromJson(Map<String, dynamic>.from(pokemonJson)));
    }

    return pokemon;
  }

  static PokemonBase getPokemonById(String pokemonId) {
    final pokemonJson = basePokemonBox.get(pokemonId);
    if (pokemonJson == null) return PokemonBase.missingNo();

    return PokemonBase.fromJson(Map<String, dynamic>.from(pokemonJson));
  }

  static List<Cup> getCups() {
    List<Cup> cups = [];
    for (var cupJson in cupsBox.values) {
      cups.add(Cup.fromJson(Map<String, dynamic>.from(cupJson)));
    }

    return cups;
  }

  static Cup getCupById(String cupId) {
    final cupJson = cupsBox.get(cupId) ?? cupsBox.getAt(0);
    return Cup.fromJson(Map<String, dynamic>.from(cupJson));
  }

  static Tag? getTagByName(String tagName) {
    final json = tagsBox.get(tagName);
    if (json == null) return null;

    return Tag.fromJson(Map<String, dynamic>.from(json));
  }

  static List<Tag> getTags() {
    List<Tag> tags = [];
    for (var tagJson in tagsBox.values) {
      tags.add(Tag.fromJson(Map<String, dynamic>.from(tagJson)));
    }

    return tags;
  }

  static bool tagNameExists(String tagName) {
    return tagsBox.containsKey(tagName);
  }

  static void putTag(Tag tag) {
    tagsBox.put(tag.name, tag.toJson());
  }

  static void deleteTag(String tagName) async {
    await tagsBox.delete(tagName);
  }

  static List<PokemonBase> getCupFilteredPokemonList(Cup cup) {
    List<PokemonBase> pokemon = getPokemon();

    return pokemon.where((pkmn) {
      return pkmn.released &&
          pkmn.fastMoves.isNotEmpty &&
          pkmn.chargeMoves.isNotEmpty &&
          cup.pokemonIsAllowed(pkmn) &&
          !Cups.isBanned(pkmn, cup.cp);
    }).toList();
  }

  // Get a list of Pokemon that contain one of the specified types
  // The rankings category
  // The list length will be up to the limit
  static List<CupPokemon> getCupPokemon(
    Cup cup,
    List<PokemonType> types,
    RankingsCategories rankingsCategory, {
    int limit = 20,
  }) {
    List<CupPokemon> rankedList = cup.getCupPokemonList(rankingsCategory);

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

  static UserPokemonTeam getUserTeam(int id) {
    final json = userPokemonTeamsBox.get(id);
    if (json == null) return UserPokemonTeam();
    return UserPokemonTeam.fromJson(jsonDecode(json));
  }

  static List<UserPokemonTeam> getUserTeams({Tag? tag}) {
    List<UserPokemonTeam> userPokemonTeams = [];
    for (var json in userPokemonTeamsBox.values) {
      userPokemonTeams.add(UserPokemonTeam.fromJson(jsonDecode(json)));
    }

    if (tag == null) {
      return userPokemonTeams;
    }

    return userPokemonTeams
        .where((team) => team.tag?.name == tag.name)
        .toList();
  }

  static List<OpponentPokemonTeam> getOpponentTeams({Tag? tag}) {
    List<OpponentPokemonTeam> opponentPokemonTeams = [];
    for (var json in opponentPokemonTeamsBox.values) {
      opponentPokemonTeams.add(OpponentPokemonTeam.fromJson(jsonDecode(json)));
    }

    if (tag == null) {
      return opponentPokemonTeams;
    }

    return opponentPokemonTeams
        .where((team) => team.tag?.name == tag.name)
        .toList();
  }

  static void putPokemonTeam(PokemonTeam team) {
    if (team.runtimeType == UserPokemonTeam) {
      if (team.id == -1) team.id = userPokemonTeamsBox.length + 1;
      userPokemonTeamsBox.put(
          team.id, jsonEncode((team as UserPokemonTeam).toJson()));
    } else if (team.runtimeType == OpponentPokemonTeam) {
      if (team.id == -1) team.id = opponentPokemonTeamsBox.length + 1;
      opponentPokemonTeamsBox.put(
          team.id, jsonEncode((team as OpponentPokemonTeam).toJson()));
    }
  }

  static void deleteUserPokemonTeam(UserPokemonTeam userTeam) {
    for (OpponentPokemonTeam opponentTeam in userTeam.opponents) {
      deleteOpponentPokemonTeam(opponentTeam.id);
    }

    userPokemonTeamsBox.delete(userTeam.id);
  }

  static void deleteOpponentPokemonTeam(int id) {
    opponentPokemonTeamsBox.delete(id);
  }

  static Future<void> clearUserData() async {
    await Future.wait([
      tagsBox.clear(),
      userPokemonTeamsBox.clear(),
      opponentPokemonTeamsBox.clear(),
    ]);
  }
}
