// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/services.dart';

// Local Imports
import 'pokemon/pokemon.dart';
import 'pokemon/typing.dart';
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

    strBuffer = await _loadCategory(cupKey, 'attackers', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    attackers = _loadJson(jsonBuffer);

    strBuffer = await _loadCategory(cupKey, 'chargers', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    chargers = _loadJson(jsonBuffer);

    strBuffer = await _loadCategory(cupKey, 'closers', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    closers = _loadJson(jsonBuffer);

    strBuffer = await _loadCategory(cupKey, 'consistency', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    consistency = _loadJson(jsonBuffer);

    strBuffer = await _loadCategory(cupKey, 'leads', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    leads = _loadJson(jsonBuffer);

    strBuffer = await _loadCategory(cupKey, 'overall', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    overall = _loadJson(jsonBuffer);

    strBuffer = await _loadCategory(cupKey, 'switches', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    switches = _loadJson(jsonBuffer);

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
  static Future<String> _loadCategory(
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
  static List<RankedPokemon> _loadJson(List<dynamic> json) {
    List<RankedPokemon> ratings = [];

    for (int i = 0; i < json.length; ++i) {
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
        return _getRankedList(attackers);

      case 'chargers':
        return _getRankedList(chargers);

      case 'closers':
        return _getRankedList(closers);

      case 'consistency':
        return _getRankedList(consistency);

      case 'leads':
        return _getRankedList(leads);

      case 'overall':
        return _getRankedList(overall);

      case 'switches':
        return _getRankedList(switches);

      default:
        break;
    }
    return _getRankedList(overall);
  }

  // Generate a list of Pokemon objects from the global id map
  List<Pokemon> _getRankedList(List<RankedPokemon> rankingsList) {
    final idMap = globals.gamemaster.pokemonIdMap;

    return rankingsList.map<Pokemon>((RankedPokemon rankedPokemon) {
      final Pokemon pokemon = Pokemon.from(idMap[rankedPokemon.speciesId]!);

      pokemon.initializeMetaMoves(rankedPokemon.moveset);
      pokemon.setRating(rankedPokemon.rating);
      return pokemon;
    }).toList();
  }

  List<Pokemon> getFilteredRankedPokemonList(
      List<Type> types, String rankingsCategory, int limit) {
    List<Pokemon> rankedList = getRankedPokemonList(rankingsCategory);

    return rankedList
        .where((pokemon) => pokemon.hasType(types))
        .toList()
        .getRange(0, limit)
        .toList();
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
