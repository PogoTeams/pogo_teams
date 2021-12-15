// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/services.dart';
import 'package:pogo_teams/data/masters/type_master.dart';

// Local Imports
import '../pokemon/pokemon.dart';
import '../pokemon/move.dart';
import '../cup.dart';
import '../colors.dart';
import '../pokemon_rankings.dart';

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

    // Standard GBL cups
    final List<Cup> cups = [
      Cup(
        key: 'all',
        title: 'Great League',
        cp: 1500,
        cupColor: cupColors['Great League']!,
        rankings: await PokemonRankings.load('all', 1500),
      ),
      Cup(
        key: 'all',
        title: 'Ultra League',
        cp: 2500,
        cupColor: cupColors['Ultra League']!,
        rankings: await PokemonRankings.load('all', 2500),
      ),
      Cup(
        key: 'all',
        title: 'Master League',
        cp: 10000,
        cupColor: cupColors['Master League']!,
        rankings: await PokemonRankings.load('all', 10000),
      ),
      Cup(
        key: 'remix',
        title: 'Great League (Remix)',
        cp: 1500,
        cupColor: cupColors['Great League']!,
        rankings: await PokemonRankings.load('remix', 1500),
      ),
      Cup(
        key: 'remix',
        title: 'Ultra League (Remix)',
        cp: 2500,
        cupColor: cupColors['Ultra League']!,
        rankings: await PokemonRankings.load('remix', 2500),
      ),
      Cup(
        key: 'remix',
        title: 'Master League (Remix)',
        cp: 10000,
        cupColor: cupColors['Master League']!,
        rankings: await PokemonRankings.load('remix', 10000),
      ),
    ];

    // All keys cooresponding to the cups that should be loaded
    final List<String> openCups = List<String>.from(gmJson['openCups']);

    // Load non-standard cups
    List<dynamic> cupsJsonList = gmJson['cups'];

    cupsJsonList = cupsJsonList
        .where((cupJson) => openCups.contains(cupJson['name']))
        .toList();

    final List<Cup> nonStandardCups =
        await Future.wait(cupsJsonList.map((dynamic cupJson) async {
      return Cup.generateCup(cupJson);
    }).toList());

    // Append the non-standard cups
    cups.addAll(nonStandardCups);

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

  // Attempt to retrieve by the idMap
  // If this fails, find the closest matching ID in the list
  // This should guarantee a non-null Pokemon return
  Pokemon retrievePokemon(String speciesId) {
    return (pokemonIdMap[speciesId] == null
        ? pokemon.firstWhere((pokemon) {
            return speciesId.contains(pokemon.speciesId) ||
                pokemon.speciesId.contains(speciesId);
          })
        : pokemonIdMap[speciesId]!);
  }
}
