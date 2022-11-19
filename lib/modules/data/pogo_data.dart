// Dart
import 'dart:convert';

// Packages
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';

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
import '../../pogo_objects/pokemon_team.dart';
import '../data/cups.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PogoData {
  static late final Isar isar;

  static List<Cup> get cups => isar.cups.where().findAllSync();
  static List<PokemonBase> get pokemon =>
      isar.basePokemon.where().findAllSync();

  static Future<void> init() async {
    isar = await Isar.open([
      FastMoveSchema,
      ChargeMoveSchema,
      CupSchema,
      CupFilterSchema,
      PokemonBaseSchema,
      PokemonSchema,
      EvolutionSchema,
      TempEvolutionSchema,
      UserPokemonTeamSchema,
      OpponentPokemonTeamSchema,
    ]);
  }

  static Stream<Pair<String, double>> loadPogoData(
      {bool forceUpdate = false}) async* {
    /*
    final Map<String, dynamic>? pogoDataJson = jsonDecode(
        await rootBundle.loadString('bin/json/niantic-snapshot.json'));
    if (pogoDataJson == null) return;
        bool update = false; // Flag for whether the local gamemaster an update
        */
    bool update = false; // Flag for whether the local gamemaster an update
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

    String message =
        loadMessagePrefix + 'Loading...'; // Message above progress bar
    final client = RetryClient(Client());

    try {
      // If an update is available
      // make an http request for the new data
      if (await _updateAvailable(localSettings, client, pathPrefix)) {
        message = loadMessagePrefix + 'Updating Pogo Teams...';
        yield Pair(a: message, b: .8);

        update = true;
        // Retrieve gamemaster
        String response = await client.read(Uri.https(
            Globals.pogoDataSourceUrl, '${pathPrefix}pogo_data_source.json'));

        // If request was successful, load in the new gamemaster,
        final pogoDataSourceJson = jsonDecode(response);
        await loadFromJson(pogoDataSourceJson);
      }
    }

    // If HTTP request or json decoding fails
    catch (error) {
      message = loadMessagePrefix + 'No Network Connection...';
      update = false;
      yield Pair(a: message, b: .8);
    } finally {
      client.close();
      localSettings.close();
    }

    yield Pair(a: message, b: .9);

    yield Pair(a: message, b: 1.0);

    // Just an asthetic for allowing the loading progress indicator to fill
    await Future.delayed(const Duration(seconds: 2));
  }

  static Future<bool> _updateAvailable(
      Box localSettings, Client client, String pathPrefix) async {
    bool updateAvailable = false;

    // Retrieve local timestamp
    final String timestampString =
        localSettings.get('timestamp') ?? Globals.earliestTimestamp;
    DateTime localTimeStamp = DateTime.parse(timestampString);

    // Retrieve server timestamp
    String response = await client.read(
        Uri.https(Globals.pogoDataSourceUrl, '${pathPrefix}timestamp.txt'));

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

  static Future<void> loadFromJson(Map<String, dynamic> json) async {
    await isar.writeTxn(() async {
      await isar.clear();
      await loadFastMoves(json['fastMoves']);
      await loadChargeMoves(json['chargeMoves']);
      await loadPokemon(json['pokemon']);
      await loadCups(json['cups']);
    });
  }

  static Future<void> loadFastMoves(List<dynamic> fastMovesJson) async {
    for (var moveJson in List<Map<String, dynamic>>.from(fastMovesJson)) {
      await isar.fastMoves.put(FastMove.fromJson(moveJson));
    }
  }

  static Future<void> loadChargeMoves(List<dynamic> chargeMovesJson) async {
    for (var moveJson in List<Map<String, dynamic>>.from(chargeMovesJson)) {
      await isar.chargeMoves.put(ChargeMove.fromJson(moveJson));
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

    if (pokemonEntry.containsKey('fastMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['fastMoves'])) {
        FastMove? move = await isar.fastMoves
            .where()
            .filter()
            .moveIdEqualTo(moveId)
            .findFirst();

        if (move != null) fastMoves.add(move);
      }
    }

    if (pokemonEntry.containsKey('chargeMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['chargeMoves'])) {
        ChargeMove? move =
            await isar.chargeMoves.filter().moveIdEqualTo(moveId).findFirst();

        if (move != null) chargeMoves.add(move);
      }
    }

    if (pokemonEntry.containsKey('eliteFastMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['eliteFastMoves'])) {
        FastMove? move =
            await isar.fastMoves.filter().moveIdEqualTo(moveId).findFirst();

        if (move != null) fastMoves.add(move);
      }
    }

    if (pokemonEntry.containsKey('eliteChargeMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['eliteChargeMoves'])) {
        ChargeMove? move =
            await isar.chargeMoves.filter().moveIdEqualTo(moveId).findFirst();

        if (move != null) chargeMoves.add(move);
      }
    }

    if (pokemonEntry.containsKey('shadow') &&
        pokemonEntry['shadow']['released']) {
      ChargeMove? move = await isar.chargeMoves
          .filter()
          .moveIdEqualTo(pokemonEntry['shadow']['purifiedChargeMove'])
          .findFirst();

      if (move != null) chargeMoves.add(move);
    }

    pokemon.fastMoves.addAll(fastMoves);
    pokemon.chargeMoves.addAll(chargeMoves);

    if (pokemonEntry.containsKey('evolutions')) {
      final evolutions = List<Map<String, dynamic>>.from(
              pokemonEntry['evolutions'])
          .map<Evolution>((evolutionJson) => Evolution.fromJson(evolutionJson))
          .toList();

      await isar.evolutions.putAll(evolutions);
      pokemon.evolutions.addAll(evolutions);
    }

    if (pokemonEntry.containsKey('tempEvolutions')) {
      final evolutions =
          List<Map<String, dynamic>>.from(pokemonEntry['tempEvolutions'])
              .map<TempEvolution>(
                  (evolutionJson) => TempEvolution.fromJson(evolutionJson))
              .toList();

      await isar.tempEvolutions.putAll(evolutions);
      pokemon.tempEvolutions.addAll(evolutions);
    }

    await isar.basePokemon.put(pokemon);
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
      ChargeMove? shadowMove = await isar.chargeMoves
          .filter()
          .moveIdEqualTo(pokemonEntry['shadow']['shadowChargeMove'])
          .findFirst();
      if (shadowMove != null) shadowPokemon.chargeMoves.add(shadowMove);

      await isar.basePokemon.put(shadowPokemon);
      await shadowPokemon.fastMoves.save();
      await shadowPokemon.chargeMoves.save();
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

        await isar.basePokemon.put(tempEvoPokemon);
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
        await isar.cupFilters.putAll(includeFilters);
        cup.includeFilters.addAll(includeFilters);
      }

      if (cupEntry.containsKey('exclude')) {
        final List<CupFilter> excludeFilters =
            List<Map<String, dynamic>>.from(cupEntry['exclude'])
                .map<CupFilter>((filter) => CupFilter.fromJson(filter))
                .toList();
        await isar.cupFilters.putAll(excludeFilters);
        cup.excludeFilters.addAll(excludeFilters);
      }

      final List<Id> rankingsIds = await _loadRankings(
        jsonDecode(
            await rootBundle.loadString('bin/json/rankings/${cup.cupId}.json')),
        cup.cp,
      );

      cup.rankings.addAll(
          (await isar.pokemon.getAll(rankingsIds)).whereType<Pokemon>());

      await isar.cups.put(cup);
      await cup.includeFilters.save();
      await cup.excludeFilters.save();
      await cup.rankings.save();
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

      final PokemonBase? pokemon = await isar.basePokemon
          .filter()
          .pokemonIdEqualTo(rankingsEntry['pokemonId'])
          .findFirst();

      if (pokemon == null) continue;

      final rankedPokemon = Pokemon(
        ratings: Ratings.fromJson(rankingsEntry['ratings']),
        ivs: pokemon.getIvs(cp),
        selectedFastMoveId: rankingsEntry['idealMoveset']['fastMove'],
        selectedChargeMoveIds: selectedChargeMoveIds,
        base: pokemon,
      );

      rankingsIds.add(await isar.pokemon.put(rankedPokemon));
      await rankedPokemon.base.save();
    }

    return rankingsIds;
  }

  static PokemonBase getPokemonById(String pokemonId) {
    return isar.basePokemon
            .filter()
            .pokemonIdEqualTo(pokemonId)
            .findFirstSync() ??
        PokemonBase.missingNo();
  }

  static Cup getCupById(String cupId) {
    return isar.cups.filter().cupIdEqualTo(cupId).findFirstSync() ?? cups.first;
  }

  static List<PokemonBase> getCupFilteredPokemonList(Cup cup) {
    final filteredPokemonList = isar.basePokemon
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
  static Future<List<Pokemon>> getFilteredRankedPokemonList(
    Cup cup,
    List<PokemonType> types,
    RankingsCategories rankingsCategory, {
    int limit = 20,
  }) async {
    List<Pokemon> rankedList = cup.getRankedPokemonList(rankingsCategory);

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

  static void updatePokemonSync(Pokemon pokemon) {
    isar.writeTxnSync(() => isar.pokemon.putSync(pokemon));
  }

  static UserPokemonTeam getUserPokemonTeamSync(Id id) {
    return isar.userPokemonTeams.getSync(id) ?? UserPokemonTeam();
  }

  static List<UserPokemonTeam> getUserPokemonTeamsSync() {
    return isar.userPokemonTeams.where().findAllSync();
  }

  static void createPokemonTeamSync(PokemonTeam team) {
    isar.writeTxnSync(() {
      if (team.runtimeType == UserPokemonTeam) {
        isar.userPokemonTeams.putSync(team as UserPokemonTeam);
      } else if (team.runtimeType == OpponentPokemonTeam) {
        isar.opponentPokemonTeams.putSync(team as OpponentPokemonTeam);
      }
    });
  }

  static Id updatePokemonTeamSync(
    PokemonTeam team, {
    bool updatePokemon = true,
    List<Pokemon?>? newPokemonTeam,
  }) {
    Id id = -1;
    isar.writeTxnSync(() {
      if (updatePokemon) {
        // Existing Pokemon Team
        if (newPokemonTeam == null) {
          for (var pokemon in team.getPokemonTeam()) {
            isar.pokemon.putSync(pokemon);
          }
        }

        // New Pokemon Team
        else {
          int i = 0;
          List<Pokemon> links = [];
          for (var pokemon in newPokemonTeam) {
            if (pokemon != null) {
              pokemon.teamIndex = i;
              isar.pokemon.putSync(pokemon);
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

      if (team.runtimeType == UserPokemonTeam) {
        id = isar.userPokemonTeams.putSync(team as UserPokemonTeam);
      } else if (team.runtimeType == OpponentPokemonTeam) {
        id = isar.opponentPokemonTeams.putSync(team as OpponentPokemonTeam);
      }
    });

    return id;
  }

  static void deleteUserPokemonTeamSync(Id id) {
    isar.writeTxnSync(() => isar.userPokemonTeams.deleteSync(id));
  }

  static void deleteOpponentPokemonTeamSync(Id id) {
    isar.writeTxnSync(() => isar.opponentPokemonTeams.deleteSync(id));
  }
}
