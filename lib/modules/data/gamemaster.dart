// Local
import 'cups.dart';
import '../../pogo_data/move.dart';
import '../../pogo_data/pokemon.dart';
import '../../pogo_data/cup.dart';

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

  static void loadFromJson(Map<String, dynamic> json) {
    loadFastMoves(List<Map<String, dynamic>>.from(json['fastMoves']));
    loadChargeMoves(List<Map<String, dynamic>>.from(json['chargeMoves']));
    loadPokemon(List<Map<String, dynamic>>.from(json['pokemon']));
    loadCups(List<Map<String, dynamic>>.from(json['cups']));
  }

  static void loadFastMoves(List<Map<String, dynamic>> fastMovesJson) {
    fastMoves = List<Map<String, dynamic>>.from(fastMovesJson)
        .map<FastMove>((moveJson) => FastMove.fromJson(moveJson))
        .toList();
  }

  static void loadChargeMoves(List<Map<String, dynamic>> chargeMovesJson) {
    chargeMoves = List<Map<String, dynamic>>.from(chargeMovesJson)
        .map<ChargeMove>((moveJson) => ChargeMove.fromJson(moveJson))
        .toList();
  }

  static void loadPokemon(List<Map<String, dynamic>> pokemonJson) {
    for (var pokemonEntry in pokemonJson) {
      _processPokemonEntry(pokemonEntry);
    }
  }

  static void _processPokemonEntry(Map<String, dynamic> pokemonEntry) {
    // Standard Pokemon entries
    Pokemon pokemon = Pokemon.fromJson(pokemonEntry);
    pokemonList.add(pokemon);
    pokemonMap[pokemon.pokemonId] = pokemon;

    // Shadow entries
    if (pokemonEntry.containsKey('shadow')) {
      Pokemon shadowPokemon = Pokemon.fromJson(pokemonEntry, shadowForm: true);
      pokemonList.add(shadowPokemon);
      pokemonMap[shadowPokemon.pokemonId] = shadowPokemon;
    }

    // Temporary evolution entries
    if (pokemonEntry.containsKey('tempEvolutions')) {
      List<dynamic> tempEvolutions = pokemonEntry['tempEvolutions'];
      for (var overrideJson in tempEvolutions) {
        Pokemon tempEvoPokemon = Pokemon.tempEvolutionFromJson(
          pokemonEntry,
          overrideJson,
        );
        pokemonList.add(tempEvoPokemon);
        pokemonMap[tempEvoPokemon.pokemonId] = tempEvoPokemon;
      }
    }
  }

  static void loadCups(List<Map<String, dynamic>> cupsJson) {
    cups = List<Map<String, dynamic>>.from(cupsJson)
        .map<Cup>((cupJson) => Cup.fromJson(cupJson))
        .toList();
  }

  static Pokemon getPokemonById(String pokemonId) {
    return pokemonMap[pokemonId]!;
  }

  static List<Pokemon> getCupFilteredPokemonList(Cup cup) {
    return pokemonList
        .where((Pokemon pokemon) =>
            cup.pokemonIsAllowed(pokemon) &&
            !Cups.isBanned(pokemon, cup.cp) &&
            pokemon.released &&
            pokemon.fastMoves.isNotEmpty &&
            pokemon.chargeMoves.isNotEmpty)
        .toList();
  }

  static void debugDisplayFastMoveRatings() {
    for (var fastMove in fastMoves) {
      fastMove.debugPrint();
    }
  }
}
