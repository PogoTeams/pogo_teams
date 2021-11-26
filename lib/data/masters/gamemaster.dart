// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/services.dart';
import 'package:pogo_teams/data/masters/type_master.dart';

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
    required this.moves,
    required this.cups,
  });

  // Read in gamemaster.json and populate the global GameMaster object
  static Future<GameMaster> generateGameMaster() async {
    // Load the JSON string
    final String gmString =
        await rootBundle.loadString('assets/gamemaster.json');
    // Decode to a map
    final Map<String, dynamic> gmJson = jsonDecode(gmString);

    final List<dynamic> cupsJsonList = gmJson['cups'];

    final List<Cup> cups =
        await Future.wait(cupsJsonList.map((dynamic cupJson) async {
      return Cup.generateCup(cupJson);
    }).toList());

    return GameMaster.fromJson(gmJson, cups);
  }

  // JSON -> OBJ conversion
  factory GameMaster.fromJson(Map<String, dynamic> json, List<Cup> cups) {
    final List<dynamic> pokemonJsonList = json['pokemon'];
    final List<dynamic> moveJsonList = json['moves'];

    final List<Move> moves = moveJsonList.map<Move>((dynamic moveJson) {
      return Move.fromJson(moveJson);
    }).toList();

    // Many Pokemon only possess 1 charged move
    // NONE will take that 2nd slot in that case
    moves.add(
      Move(
          moveId: 'NONE',
          name: 'none',
          type: TypeMaster.typeList[18],
          power: 0.0,
          energy: 0.0,
          energyGain: 0.0,
          cooldown: 0.0),
    );

    List<Pokemon> pokemon = [];
    Map<String, Pokemon> pokemonIdMap = {};

    void _parsePokemon(dynamic pokemonJson) {
      // Retrieve the move objects from 'moves' internally for this Pokemon
      final Pokemon pkm = Pokemon.fromJson(pokemonJson, moves);

      pokemon.add(pkm);
      pokemonIdMap[pkm.speciesId] = pkm;
    }

    // Populate the pokemon list from json data
    pokemonJsonList.forEach(_parsePokemon);

    return GameMaster(
      pokemon: pokemon,
      pokemonIdMap: pokemonIdMap,
      moves: moves,
      cups: cups,
    );
  }

  // The master list of ALL moves
  late final List<Move> moves;

  // The master list of ALL pokemon
  late final List<Pokemon> pokemon;

  // A map of ALL pokemon to their speciesId
  late final Map<String, Pokemon> pokemonIdMap;

  // The master list of ALL cups
  late final List<Cup> cups;
}
