// Dart
import 'dart:convert';

// Packages
//import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

// Local
import '../../enums/rankings_categories.dart';
import '../../tools/pair.dart';
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/pokemon_typing.dart';
import '../../pogo_objects/ratings.dart';
import '../../pogo_objects/cup.dart';
import '../../pogo_objects/pokemon_team.dart';
import '../../pogo_objects/user_teams.dart';
import '../../pogo_objects/opponent_teams.dart';
import '../../pogo_objects/move.dart';
import '../../pogo_objects/move.dart';
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/ratings.dart';
import '../data/cups.dart';
//import '../ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PogoData {
  static late final Isar isar;

  static List<Cup> get cups => isar.cups.where().findAllSync();
  static List<Pokemon> get pokemon => isar.pokemon.where().findAllSync();

  static Future<void> init() async {
    isar = await Isar.open([
      FastMoveSchema,
      ChargeMoveSchema,
      CupSchema,
      CupFilterSchema,
      PokemonSchema,
      EvolutionSchema,
      TempEvolutionSchema,
      RankedPokemonSchema,
    ]);

    await isar.writeTxn(() async => await isar.clear());
  }

  static Stream<Pair<String, double>> loadPogoData() async* {
    final Map<String, dynamic>? pogoDataJson = {}; //jsonDecode(
    //await rootBundle.loadString('bin/json/niantic-snapshot.json'));
    if (pogoDataJson == null) return;

    await loadFromJson(pogoDataJson);
  }

  static Future<void> loadFromJson(Map<String, dynamic> json) async {
    await isar.writeTxn(() async {
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
    Pokemon pokemon = Pokemon.fromJson(pokemonEntry);
    List<FastMove> fastMove = [];
    List<ChargeMove> chargeMove = [];

    if (pokemonEntry.containsKey('fastMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['fastMoves'])) {
        FastMove? move = await isar.fastMoves
            .where()
            .filter()
            .moveIdEqualTo(moveId)
            .findFirst();

        if (move != null) fastMove.add(move);
      }
    }

    if (pokemonEntry.containsKey('chargeMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['chargeMoves'])) {
        ChargeMove? move =
            await isar.chargeMoves.filter().moveIdEqualTo(moveId).findFirst();

        if (move != null) chargeMove.add(move);
      }
    }

    if (pokemonEntry.containsKey('eliteFastMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['eliteFastMoves'])) {
        FastMove? move =
            await isar.fastMoves.filter().moveIdEqualTo(moveId).findFirst();

        if (move != null) fastMove.add(move);
      }
    }

    if (pokemonEntry.containsKey('eliteChargeMoves')) {
      for (var moveId in List<String>.from(pokemonEntry['eliteChargeMoves'])) {
        ChargeMove? move =
            await isar.chargeMoves.filter().moveIdEqualTo(moveId).findFirst();

        if (move != null) chargeMove.add(move);
      }
    }

    if (pokemonEntry.containsKey('shadow') &&
        pokemonEntry['shadow']['released']) {
      ChargeMove? move = await isar.chargeMoves
          .filter()
          .moveIdEqualTo(pokemonEntry['shadow']['purifiedChargeMove'])
          .findFirst();

      if (move != null) chargeMove.add(move);
    }

    pokemon.fastMoves.addAll(fastMove);
    pokemon.chargeMoves.addAll(chargeMove);

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

    await isar.pokemon.put(pokemon);
    await pokemon.evolutions.save();
    await pokemon.tempEvolutions.save();
    await pokemon.fastMoves.save();
    await pokemon.chargeMoves.save();

    // Shadow entries
    if (pokemonEntry.containsKey('shadow')) {
      Pokemon shadowPokemon = Pokemon.fromJson(pokemonEntry, shadowForm: true);

      shadowPokemon.fastMoves.addAll(fastMove);
      shadowPokemon.chargeMoves.addAll(chargeMove);
      ChargeMove? shadowMove = await isar.chargeMoves
          .filter()
          .moveIdEqualTo(pokemonEntry['shadow']['shadowChargeMove'])
          .findFirst();
      if (shadowMove != null) shadowPokemon.chargeMoves.add(shadowMove);

      await isar.pokemon.put(shadowPokemon);
      await shadowPokemon.fastMoves.save();
      await shadowPokemon.chargeMoves.save();
    }

    // Temporary evolution entries
    if (pokemonEntry.containsKey('tempEvolutions')) {
      for (var overrideJson
          in List<Map<String, dynamic>>.from(pokemonEntry['tempEvolutions'])) {
        Pokemon tempEvoPokemon = Pokemon.tempEvolutionFromJson(
          pokemonEntry,
          overrideJson,
        );

        tempEvoPokemon.fastMoves.addAll(fastMove);
        tempEvoPokemon.chargeMoves.addAll(chargeMove);

        await isar.pokemon.put(tempEvoPokemon);
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

      final List<Id> rankingsIds = []; //await _loadRankings(jsonDecode(
      //await rootBundle.loadString('bin/json/rankings/${cup.cupId}.json')));

      cup.rankings.addAll((await isar.rankedPokemon.getAll(rankingsIds))
          .whereType<RankedPokemon>());

      await isar.cups.put(cup);
      await cup.includeFilters.save();
      await cup.excludeFilters.save();
      await cup.rankings.save();

      //PogoColors.addCupColor(cup.cupId, cupEntry['uiColor'] as String);
    }
  }

  static Future<List<Id>> _loadRankings(List<dynamic> rankingsJson) async {
    List<Id> rankingsIds = [];

    for (var rankingsEntry in List<Map<String, dynamic>>.from(rankingsJson)) {
      final List<String> selectedChargeMoves =
          List<String>.from(rankingsEntry['idealMoveset']['chargeMoves']);

      final rankedPokemon = RankedPokemon(
        ratings: Ratings.fromJson(rankingsEntry['ratings']),
      );

      rankedPokemon
        ..pokemon.value = await isar.pokemon
            .filter()
            .pokemonIdEqualTo(rankingsEntry['pokemonId'])
            .findFirst()
        ..selectedFastMove.value = await isar.fastMoves
            .filter()
            .moveIdEqualTo(rankingsEntry['idealMoveset']['fastMove'])
            .findFirst()
        ..selectedChargeMoves.addAll(await isar.chargeMoves
            .filter()
            .moveIdEqualTo(selectedChargeMoves.first)
            .or()
            .moveIdEqualTo(selectedChargeMoves.last)
            .findAll());

      rankingsIds.add(await isar.rankedPokemon.put(rankedPokemon));
      await rankedPokemon.pokemon.save();
      await rankedPokemon.selectedFastMove.save();
      await rankedPokemon.selectedChargeMoves.save();
    }

    return rankingsIds;
  }

  static Pokemon getPokemonById(String pokemonId) {
    return isar.pokemon.filter().pokemonIdEqualTo(pokemonId).findFirstSync() ??
        Pokemon.missingNo();
  }

  static List<Pokemon> getCupFilteredPokemonList(Cup cup) {
    final filteredPokemonList = isar.pokemon
        .filter()
        .releasedEqualTo(true)
        .and()
        .fastMovesIsNotEmpty()
        .and()
        .chargeMovesIsNotEmpty()
        .findAllSync()
        .where((Pokemon pokemon) =>
            cup.pokemonIsAllowed(pokemon) && !Cups.isBanned(pokemon, cup.cp))
        .toList();

    for (var pokemon in filteredPokemonList) {
      pokemon.fastMoves.loadSync();
      pokemon.chargeMoves.loadSync();
    }

    return filteredPokemonList;
  }

  static Future<List<RankedPokemon>> getRankedPokemonList(
    Cup cup,
    RankingsCategories rankingsCategory,
  ) async {
    if (!cup.rankings.isLoaded) await cup.rankings.load();

    for (var rankedPokemon in cup.rankings) {
      if (rankedPokemon.pokemon.value == null) continue;

      if (!rankedPokemon.pokemon.isLoaded) {
        await rankedPokemon.pokemon.load();
      }
      if (!rankedPokemon.selectedFastMove.isLoaded) {
        await rankedPokemon.selectedFastMove.load();
      }
      if (!rankedPokemon.selectedChargeMoves.isLoaded) {
        await rankedPokemon.selectedChargeMoves.load();
      }
    }

    return cup.rankings.toList();
  }

  // Get a list of Pokemon that contain one of the specified types
  // The rankings category
  // The list length will be up to the limit
  static Future<List<RankedPokemon>> getFilteredRankedPokemonList(
    Cup cup,
    List<PokemonType> types,
    RankingsCategories rankingsCategory, {
    int limit = 20,
  }) async {
    List<RankedPokemon> rankedList =
        await getRankedPokemonList(cup, rankingsCategory);

    // Filter the list to Pokemon that have one of the types in their typing
    // or their selected moveset
    /* TODO
    rankedList = rankedList
        .where((pokemon) =>
            pokemon.hasType(types) || pokemon.hasSelectedMovesetType(types))
        .toList();
        */

    // There weren't enough Pokemon in this cup to satisfy the filtered limit
    if (rankedList.length < limit) {
      return rankedList;
    }

    return rankedList.getRange(0, limit).toList();
  }

  static Future<UserPokemonTeam> updateUserPokemonTeam(
    UserPokemonTeam team, {
    List<String>? updateMask,
  }) async {
    return team;
  }

  static void deleteUserPokemonTeam(String? teamId) {
    if (teamId == null || teamId.isEmpty) return;
  }

  static Future<OpponentPokemonTeams> getOpponentPokemonTeams(
    String? teamId,
  ) async {
    OpponentPokemonTeams teams = OpponentPokemonTeams();
    return teams;
  }

  static Future<OpponentPokemonTeam> updateOpponentPokemonTeam(
    OpponentPokemonTeam team, {
    List<String>? updateMask,
  }) async {
    return team;
  }

  static void deleteOpponentPokemonTeam(String? teamId) {
    if (teamId == null || teamId.isEmpty) return;
  }
}
