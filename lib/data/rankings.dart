// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/services.dart';

// Local Imports
import 'pokemon/pokemon.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
All pokemon rankings are managed here. For every 'cup' available in the
assets/gamemaster.json is a Rankings object. Within this cup, there is a
list of Pokemon and respective movesets that are ranked in 7 different
categories.

The rankings data in assets/rankings/ is made available by pvpoke.com and
their outstanding ranking interface. This app uses the ranking to make
helpful recommendations to the user when building a team.
-------------------------------------------------------------------------------
*/

class Rankings {
  Rankings({
    required this.attackers,
    required this.chargers,
    required this.closers,
    required this.consistency,
    required this.leads,
    required this.overall,
    required this.switches,
  });

  // JSON -> OBJ Conversion
  static Future<Rankings> load(String cupKey, int cp) async {
    final String cpString = cp.toString();
    String strBuffer;
    List<dynamic> jsonBuffer;

    List<RankedPokemon> attackers = [];
    List<RankedPokemon> chargers = [];
    List<RankedPokemon> closers = [];
    List<RankedPokemon> consistency = [];
    List<RankedPokemon> leads = [];
    List<RankedPokemon> overall = [];
    List<RankedPokemon> switches = [];

    strBuffer = await loadCategory(cupKey, 'attackers', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    attackers = loadJson(jsonBuffer);

    strBuffer = await loadCategory(cupKey, 'chargers', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    chargers = loadJson(jsonBuffer);

    strBuffer = await loadCategory(cupKey, 'closers', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    closers = loadJson(jsonBuffer);

    strBuffer = await loadCategory(cupKey, 'consistency', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    consistency = loadJson(jsonBuffer);

    strBuffer = await loadCategory(cupKey, 'leads', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    leads = loadJson(jsonBuffer);

    strBuffer = await loadCategory(cupKey, 'overall', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    overall = loadJson(jsonBuffer);

    strBuffer = await loadCategory(cupKey, 'switches', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    switches = loadJson(jsonBuffer);

    return Rankings(
      attackers: attackers,
      chargers: chargers,
      closers: closers,
      consistency: consistency,
      leads: leads,
      overall: overall,
      switches: switches,
    );
  }

  // Used in fromJson to load a ranking category's json
  static Future<String> loadCategory(
      String cupKey, String category, String cp) {
    return rootBundle.loadString('assets/rankings/' +
        cupKey +
        '/' +
        category +
        '/rankings-' +
        cp +
        '.json');
  }

  // Used in fromJson to load the json's pokemon into their list
  static List<RankedPokemon> loadJson(List<dynamic> json) {
    List<RankedPokemon> ratings = [];
    int jsonLen = json.length;

    for (int i = 0; i < jsonLen; ++i) {
      final rankedPokemon = RankedPokemon.fromJson(json[i]);
      ratings.add(rankedPokemon);
    }

    ratings.sort((a, b) => ((b.rating - a.rating) * 1000).toInt());
    return ratings;
  }

  // Branch for all possible categories
  List<Pokemon> getRankedPokemonList(String rankingsCategory) {
    switch (rankingsCategory) {
      case 'attackers':
        return getRankedList(attackers);

      case 'chargers':
        return getRankedList(chargers);

      case 'closers':
        return getRankedList(closers);

      case 'consistency':
        return getRankedList(consistency);

      case 'leads':
        return getRankedList(leads);

      case 'overall':
        return getRankedList(overall);

      case 'switches':
        return getRankedList(switches);

      default:
        break;
    }
    return getRankedList(overall);
  }

  // Generate a list of Pokemon objects from the global id map
  List<Pokemon> getRankedList(List<RankedPokemon> rankingsList) {
    final idMap = globals.gamemaster.pokemonIdMap;

    return rankingsList.map<Pokemon>((RankedPokemon rankedPokemon) {
      final Pokemon pokemon = idMap[rankedPokemon.speciesId]!;
      pokemon.initializeMetaMoves(rankedPokemon.moveset);
      pokemon.setRating(rankedPokemon.rating);
      return pokemon;
    }).toList();
  }

  late final List<RankedPokemon> attackers;
  late final List<RankedPokemon> chargers;
  late final List<RankedPokemon> closers;
  late final List<RankedPokemon> consistency;
  late final List<RankedPokemon> leads;
  late final List<RankedPokemon> overall;
  late final List<RankedPokemon> switches;
}

// Container for ranking information
// The moveset field contains the ideal moveset for any given Pokemon
class RankedPokemon {
  RankedPokemon({
    required this.speciesId,
    required this.rating,
    required this.moveset,
  });

  factory RankedPokemon.fromJson(Map<String, dynamic> json) {
    final speciesId = json['speciesId'] as String;
    final rating = json['rating'] as num;
    final moveset = List<String>.from(json['moveset']);

    return RankedPokemon(
      speciesId: speciesId,
      rating: rating,
      moveset: moveset,
    );
  }

  String speciesId;
  final num rating;
  final List<String> moveset;
}
