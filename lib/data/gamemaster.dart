import 'pogo_data.dart';

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
    required this.moves,
  });

  // JSON -> OBJ conversion
  factory GameMaster.fromJson(Map<String, dynamic> data) {
    final List<dynamic> pokeList = data['pokemon'];
    final shadowPokemonKeys = List<String>.from(data['shadowPokemon']);
    final List<dynamic> moveList = data['moves'];

    List<Pokemon> pokemon = [];
    List<Pokemon> shadowPokemon = [];
    List<Move> moves = [];

    // Callback for 'forEach'
    void parseMove(json) {
      moves.add(Move.fromJson(json));
    }

    // Populate the move list
    moveList.forEach(parseMove);

    // Callback for 'forEach'
    // Add the Pokemon to either the normal or shadow list
    void parsePkm(json) {
      // Populate all pokemon data
      // Retrieve the move objects from 'moves' internally for this Pokemon
      final Pokemon pkm = Pokemon.fromJson(json, moves);

      if (pkm.tags!.contains('shadow')) {
        shadowPokemon.add(pkm);
      } else {
        pokemon.add(pkm);
      }
    }

    pokeList.forEach(parsePkm);

    return GameMaster(
      pokemon: pokemon,
      shadowPokemon: shadowPokemon,
      shadowPokemonKeys: shadowPokemonKeys,
      moves: moves,
    );
  }

  // The master list of ALL moves
  late List<Move> moves;

  // The master list of ALL pokemon
  late List<Pokemon> pokemon;

  // The master list of ALL shadow pokemon
  late List<Pokemon> shadowPokemon;

  // The master list of ALL Pokemon keys that are shadow eligible
  late List<String> shadowPokemonKeys;

  // The list of leagues
  final List<League> leagues = [
    League(title: 'Great League', cpCap: 1500),
    League(title: 'Ultra League', cpCap: 2500),
    League(title: 'Master League', cpCap: 9999),
  ];
}
