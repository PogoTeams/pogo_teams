import 'pokemon.dart';
import 'move.dart';
import 'cup.dart';

/*
GameMaster contains all necessary information about the game
- A list of all Pokemon
- A list of all moves
*/
class GameMaster {
  GameMaster({
    required this.pokemon,
    required this.shadowPokemon,
    required this.shadowPokemonKeys,
    required this.xsPokemon,
    required this.moves,
    required this.cups,
  });

  // JSON -> OBJ conversion
  factory GameMaster.fromJson(Map<String, dynamic> json) {
    final List<dynamic> pokemonJsonList = json['pokemon'];
    final shadowPokemonKeys = List<String>.from(json['shadowPokemon']);
    final List<dynamic> moveJsonList = json['moves'];
    final List<dynamic> cupsJsonList = json['cups'];

    final List<Move> moves = moveJsonList.map<Move>((dynamic moveJson) {
      return Move.fromJson(moveJson);
    }).toList();

    // Pokemon are separated into 3 separate lists
    // Standard Pokemon
    // Shadow Pokemon
    // XS Pokemon
    List<Pokemon> pokemon = [];
    List<Pokemon> shadowPokemon = [];
    List<Pokemon> xsPokemon = [];

    final List<Cup> cups = cupsJsonList.map<Cup>((dynamic cupJson) {
      return Cup.fromJson(cupJson);
    }).toList();

    void _parsePokemon(dynamic pokemonJson) {
      // Populate all pokemon data
      // Retrieve the move objects from 'moves' internally for this Pokemon
      final Pokemon pkm = Pokemon.fromJson(pokemonJson, moves);

      // Assign the pokemon to either the shadow, xs, or standard list
      if (pkm.tags!.contains('shadow')) {
        shadowPokemon.add(pkm);
      } else if (pkm.tags!.contains('xs')) {
        xsPokemon.add(pkm);
      } else {
        pokemon.add(pkm);
      }
    }

    // Populate the pokemon list from json data
    pokemonJsonList.forEach(_parsePokemon);

    return GameMaster(
      pokemon: pokemon,
      shadowPokemon: shadowPokemon,
      shadowPokemonKeys: shadowPokemonKeys,
      xsPokemon: xsPokemon,
      moves: moves,
      cups: cups,
    );
  }

  // The master list of ALL moves
  late final List<Move> moves;

  // The master list of ALL pokemon
  late final List<Pokemon> pokemon;

  // The master list of ALL shadow pokemon
  late final List<Pokemon> shadowPokemon;

  // The master list of ALL Pokemon keys that are shadow eligible
  late final List<String> shadowPokemonKeys;

  // Pokemon that benefit from the XL  candy power up.
  // This option is presented to the user as an alternative
  // due to how inaccessible XL candy are.
  late final List<Pokemon> xsPokemon;

  // The master list of ALL cups
  late final List<Cup> cups;
}
