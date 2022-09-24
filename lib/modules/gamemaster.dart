// Local
import '../pogo_data/move.dart';
import '../pogo_data/pokemon.dart';
import '../pogo_data/cup.dart';

class GameMaster {
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

  static load(Map<String, dynamic> json) {
    fastMoves = List<Map<String, dynamic>>.from(json['fastMoves'])
        .map<FastMove>((moveJson) => FastMove.fromJson(moveJson))
        .toList();
    chargeMoves = List<Map<String, dynamic>>.from(json['chargeMoves'])
        .map<ChargeMove>((moveJson) => ChargeMove.fromJson(moveJson))
        .toList();
    var jsonList = List<Map<String, dynamic>>.from(json['pokemon']);
    for (var pokemonJson in jsonList) {
      Pokemon pokemon = Pokemon.fromJson(pokemonJson);
      pokemonList.add(pokemon);
      pokemonMap[pokemon.pokemonId] = pokemon;
    }
    cups = List<Map<String, dynamic>>.from(json['cups'])
        .map<Cup>((cupJson) => Cup.fromJson(cupJson))
        .toList();
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
            pokemon.released &&
            pokemon.fastMoves.isNotEmpty &&
            pokemon.chargeMoves.isNotEmpty)
        .toList();
  }
}
