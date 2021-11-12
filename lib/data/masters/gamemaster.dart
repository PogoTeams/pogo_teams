// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter/services.dart';

// Local Imports
import '../pokemon/pokemon.dart';
import '../pokemon/move.dart';
import '../cup.dart';

/*
-------------------------------------------------------------------------------
The gamemaster contains all Pokemon Go data. A global GameMaster object is
populated by assets/gamemaster.json. GameMaster can be considered the model of
the entire app.
-------------------------------------------------------------------------------
*/

class GameMaster {
  GameMaster({
    required this.pokemon,
    required this.pokemonIdMap,
    required this.shadowPokemon,
    required this.shadowPokemonKeys,
    required this.xsPokemon,
    required this.moves,
    required this.cups,
  });

  // Read in gamemaster.json and populate the global GameMaster object
  static Future<GameMaster> generateGameMaster() async {
    // Ensure the application layer is built so gamemaster.json can be parsed
    WidgetsFlutterBinding.ensureInitialized();
    // Load the JSON string
    final String gmString =
        await rootBundle.loadString('assets/gamemaster.json');
    // Decode to a map
    final Map<String, dynamic> gmJson = jsonDecode(gmString);

    return GameMaster.fromJson(gmJson);
  }

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
    Map<String, Pokemon> pokemonIdMap = {};
    List<Pokemon> shadowPokemon = [];
    List<Pokemon> xsPokemon = [];

    final List<Cup> cups = cupsJsonList.map<Cup>((dynamic cupJson) {
      return Cup.fromJson(cupJson);
    }).toList();

    void _parsePokemon(dynamic pokemonJson) {
      // Populate all pokemon data
      // Retrieve the move objects from 'moves' internally for this Pokemon
      final Pokemon pkm = Pokemon.fromJson(pokemonJson, moves);
      final id = pkm.speciesId;

      if (!id.contains('shadow') && !id.contains('xs')) {
        pokemon.add(pkm);
        pokemonIdMap[pkm.speciesId] = pkm;
      }
    }

    // Populate the pokemon list from json data
    pokemonJsonList.forEach(_parsePokemon);

    return GameMaster(
      pokemon: pokemon,
      pokemonIdMap: pokemonIdMap,
      shadowPokemon: shadowPokemon,
      shadowPokemonKeys: shadowPokemonKeys,
      xsPokemon: xsPokemon,
      moves: moves,
      cups: cups,
    );
  }

  // Load the Pokemon Rankings for each cup
  void initializeRankings() {
    void loadCup(Cup cup) => cup.loadRankings();
    cups.forEach(loadCup);
  }

  // The master list of ALL moves
  late final List<Move> moves;

  // The master list of ALL pokemon
  late final List<Pokemon> pokemon;

  // A map of ALL pokemon to their speciesId
  late final Map<String, Pokemon> pokemonIdMap;

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
