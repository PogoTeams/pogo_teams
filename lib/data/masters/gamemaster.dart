// Package Imports
import 'package:http/http.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Local Imports
import '../pokemon/pokemon.dart';
import '../pokemon/move.dart';
import '../cup.dart';
import '../pokemon/typing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The gamemaster contains all Pokemon Go data. A global GameMaster object is
populated by assets/gamemaster.json. GameMaster can be considered the model of
the entire app.
-------------------------------------------------------------------------------
*/

class GameMaster {
  GameMaster.empty() {
    moves = List.empty(growable: true);
    pokemon = List.empty(growable: true);
    pokemonIdMap = {};
    cups = List.empty(growable: true);
  }

  GameMaster({
    required this.moves,
    required this.pokemon,
    required this.pokemonIdMap,
    required this.cups,
  });

  // Read in gamemaster.json and populate the global GameMaster object
  static Future<GameMaster> generateGameMaster(
      gmJson, Client client, Box rankingsBox,
      {bool update = false}) async {
    // All available cups data
    final List<dynamic> cupsJson = gmJson['openCups'];
    List<Cup> cups = List.empty(growable: true);
    Cup cupBuffer;

    // An update is available, attempt to retrieve new Rankings with HTTPS
    if (update) {
      try {
        for (int i = 0; i < cupsJson.length; ++i) {
          cupBuffer = await Cup.updateCup(cupsJson[i], rankingsBox, client);
          cups.add(cupBuffer);
        }
      }
      // HTTPS fail : attempt to read from db, then assets as last resort
      catch (_) {
        try {
          cups.clear();
          for (int i = 0; i < cupsJson.length; ++i) {
            cupBuffer = await Cup.loadCup(cupsJson[i], rankingsBox);
            cups.add(cupBuffer);
          }
        } catch (_) {}
      }
    }
    // No update available, read Rankings from db, then assets as last resort
    else {
      for (int i = 0; i < cupsJson.length; ++i) {
        try {
          cupBuffer = await Cup.loadCup(cupsJson[i], rankingsBox);
          cups.add(cupBuffer);
        } catch (_) {}
      }
    }

    return GameMaster.fromJson(gmJson, cups);
  }

  // JSON -> OBJ conversion
  factory GameMaster.fromJson(json, List<Cup> cups) {
    final List<dynamic> pokemonJsonList = json['pokemon'];
    final List<dynamic> moveJsonList = json['moves'];

    List<Move> moves = List.empty(growable: true);
    List<Pokemon> pokemon = List.empty(growable: true);
    Map<String, Pokemon> pokemonIdMap = {};

    moves = moveJsonList.map<Move>((dynamic moveJson) {
      return Move.fromJson(moveJson);
    }).toList();

    // Many Pokemon only possess 1 charged move
    // NONE will take that 2nd slot in that case
    moves.add(
      Move(
        moveId: 'NONE',
        name: 'none',
        type: Type(typeKey: 'none'),
        power: 0.0,
        energy: 0.0,
        energyGain: 0.0,
        cooldown: 0.0,
      ),
    );

    void _parsePokemon(dynamic pokemonJson) async {
      // Retrieve the move objects from 'moves' internally for this Pokemon
      final Pokemon pkm = Pokemon.fromJson(pokemonJson, moves);

      pokemon.add(pkm);
      pokemonIdMap[pkm.speciesId] = pkm;
    }

    // Populate the pokemon list from json data
    pokemonJsonList.forEach(_parsePokemon);

    return GameMaster(
      moves: moves,
      pokemon: pokemon,
      pokemonIdMap: pokemonIdMap,
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
