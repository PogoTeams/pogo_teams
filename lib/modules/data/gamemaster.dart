// Local
import 'cups.dart';
import '../../game_objects/move.dart';
import '../../game_objects/pokemon.dart';
import '../../game_objects/cup.dart';

class Gamemaster {
  // a map of ALL fast moves to their moveId
  static final Map<String, FastMove> _fastMoveMap = {};

  // a map of ALL charge moves to their moveId
  static final Map<String, ChargeMove> _chargeMoveMap = {};

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
    for (var moveJson in List<Map<String, dynamic>>.from(fastMovesJson)) {
      FastMove fastMove = FastMove.fromJson(moveJson);
      _fastMoveMap[fastMove.moveId] = fastMove;
    }
  }

  static void loadChargeMoves(List<Map<String, dynamic>> chargeMovesJson) {
    for (var moveJson in List<Map<String, dynamic>>.from(chargeMovesJson)) {
      ChargeMove chargeMove = ChargeMove.fromJson(moveJson);
      _chargeMoveMap[chargeMove.moveId] = chargeMove;
    }
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

  static Pokemon getPokemonById(String pokemonId) => pokemonMap[pokemonId]!;

  static FastMove getFastMoveById(String moveId) =>
      _fastMoveMap[moveId] ?? FastMove.none;

  static ChargeMove getChargeMoveById(String moveId) =>
      _chargeMoveMap[moveId] ?? ChargeMove.none;

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
}
