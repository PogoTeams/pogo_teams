// Local
import 'package:pogo_teams/modules/ui/pogo_colors.dart';

import '../../pogo_data/move.dart';
import '../../pogo_data/pokemon.dart';
import '../../pogo_data/pokemon_typing.dart';
import '../../pogo_data/cup.dart';
import 'stats.dart';
import 'cups.dart';

class Gamemaster {
  // The master list of ALL fast moves
  static late final List<FastMove> fastMoves;

  // The master list of ALL charge moves
  static late final List<ChargeMove> chargeMoves;

  // The master list of ALL pokemon
  static final List<Pokemon> pokemonList = [];

  // A map of ALL pokemon to their speciesId
  static final Map<String, Pokemon> pokemonMap = {};

  // The master list of ALL cups
  static late final List<Cup> cups;

  static void load(Map<String, dynamic> json) {
    fastMoves = List<Map<String, dynamic>>.from(json['fastMoves'])
        .map<FastMove>((moveJson) => FastMove.fromJson(moveJson))
        .toList();
    chargeMoves = List<Map<String, dynamic>>.from(json['chargeMoves'])
        .map<ChargeMove>((moveJson) => ChargeMove.fromJson(moveJson))
        .toList();
    var jsonList = List<Map<String, dynamic>>.from(json['pokemon']);
    for (var pokemonJson in jsonList) {
      // Standard Pokemon entries
      Pokemon pokemon = Pokemon.fromJson(pokemonJson);
      pokemonList.add(pokemon);
      pokemonMap[pokemon.pokemonId] = pokemon;

      // Shadow entries
      if (pokemonJson.containsKey('shadow')) {
        Pokemon shadowPokemon = Pokemon.fromJson(pokemonJson, shadowForm: true);
        pokemonList.add(shadowPokemon);
        pokemonMap[shadowPokemon.pokemonId] = shadowPokemon;
      }

      // Temporary evolution entries
      if (pokemonJson.containsKey('tempEvolutions')) {
        List<dynamic> tempEvolutions = pokemonJson['tempEvolutions'];
        for (var overrideJson in tempEvolutions) {
          Pokemon tempEvoPokemon = Pokemon.tempEvolutionFromJson(
            pokemonJson,
            overrideJson,
          );
          pokemonList.add(tempEvoPokemon);
          pokemonMap[tempEvoPokemon.pokemonId] = tempEvoPokemon;
        }
      }
    }

    cups = List<Map<String, dynamic>>.from(json['cups'])
        .map<Cup>((cupJson) => Cup.fromJson(cupJson))
        .toList();

    for (var cupEntry in json['cups']) {
      PogoColors.addCupColor(cupEntry['cupId'], cupEntry['cupColorHex']);
    }
  }

  static Pokemon getPokemonById(String pokemonId) {
    return pokemonMap[pokemonId]!;
  }

  static void debugDisplayFastMoveRatings() {
    for (var fastMove in fastMoves) {
      fastMove.debugPrint();
    }
  }

  static List<Pokemon> getCupFilteredPokemonList(Cup cup) {
    return pokemonList
        .where((Pokemon pokemon) =>
            cup.pokemonIsAllowed(pokemon) &&
            !Cups.isBanned(pokemon, cup.cp) &&
            (pokemon.minLevel != null
                ? Stats.calculateMinEncounterCp(
                      pokemon.stats,
                      pokemon.minLevel!,
                    ) <=
                    cup.cp
                : true) &&
            pokemon.released &&
            pokemon.fastMoves.isNotEmpty &&
            pokemon.chargeMoves.isNotEmpty)
        .toList();
  }

  static List<Pokemon> getRankedPokemonList(Cup cup, String rankingsCategory) {
    return pokemonList;
  }

  // Get a list of Pokemon that contain one of the specified types
  // The rankings category
  // The list length will be up to the limit
  static List<Pokemon> getFilteredRankedPokemonList(
    Cup cup,
    List<PokemonType> types,
    String rankingsCategory, {
    int limit = 20,
  }) {
    List<Pokemon> rankedList = getRankedPokemonList(cup, rankingsCategory);

    // Filter the list to Pokemon that have one of the types in their typing
    // or their selected moveset
    rankedList = rankedList
        .where((pokemon) =>
            pokemon.hasType(types) || pokemon.hasSelectedMovesetType(types))
        .toList();

    // There weren't enough Pokemon in this cup to satisfy the filtered limit
    if (rankedList.length < limit) {
      return rankedList;
    }

    return rankedList.getRange(0, limit).toList();
  }
}
