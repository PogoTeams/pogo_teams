// Dart Imports
import 'dart:convert';
import 'dart:math';

// Flutter Imports
import 'package:flutter/services.dart';

// Local Imports
import 'pokemon/pokemon.dart';
import 'pokemon/typing.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
All pokemon rankings are managed here. For every 'cup' available in the
assets/gamemaster.json is a PokemonRankings object. Within this cup, there is a
list of Pokemon and respective movesets that are ranked in 7 different
categories.

The rankings data in assets/rankings/ is made available by pvpoke.com and
their outstanding ranking interface. This app uses the ranking to make
helpful recommendations to the user when building a team.
-------------------------------------------------------------------------------
*/

class PokemonRankings {
  PokemonRankings({required this.rankingsMap});

  // JSON -> OBJ Conversion
  static Future<PokemonRankings> load(String cupKey, int cp) async {
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

    strBuffer = await _loadCategory(cupKey, 'switches', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    switches = _loadJson(jsonBuffer);

    strBuffer = await _loadCategory(cupKey, 'overall', cpString);
    jsonBuffer = jsonDecode(strBuffer);
    overall = _loadJson(jsonBuffer);

    final Map<String, RankedPokemon> rankingsMap = {};

    for (int i = 0; i < overall.length; ++i) {
      rankingsMap[overall[i].speciesId] = overall[i];
    }

    for (int i = 0; i < attackers.length; ++i) {
      rankingsMap[attackers[i].speciesId]!.attackers = attackers[i].rating;
      rankingsMap[chargers[i].speciesId]!.chargers = chargers[i].rating;
      rankingsMap[closers[i].speciesId]!.closers = closers[i].rating;
      rankingsMap[consistency[i].speciesId]!.consistency =
          consistency[i].rating;
      rankingsMap[leads[i].speciesId]!.leads = leads[i].rating;
      rankingsMap[switches[i].speciesId]!.switches = switches[i].rating;
    }

    num topRating = 0;
    _calculateOverallRating(rankedPokemon) {
      final num rating = rankedPokemon.calculateOverallRating();
      if (rating > topRating) topRating = rating;
    }

    rankingsMap.values.forEach(_calculateOverallRating);

    if (topRating > 0) {
      _normalizeOverallRating(RankedPokemon rankedPokemon) =>
          rankedPokemon.overall /= (topRating * .01);
      rankingsMap.values.forEach(_normalizeOverallRating);
    }

    return PokemonRankings(rankingsMap: rankingsMap);
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

    // Sort ratings
    ratings.sort((a, b) => ((b.rating - a.rating) * 1000).toInt());

    final num topRating = ratings.first.rating;

    // Normalize scores based on the top rating
    // After this, every rating will be between 0 and 100
    _normalizeScore(RankedPokemon rankedPokemon) =>
        rankedPokemon.rating /= (topRating * .01);

    ratings.forEach(_normalizeScore);

    return ratings;
  }

  // Get a sorted list of Pokemon from the rankings category specified
  // Each Pokemon will have a rating based on that category
  List<Pokemon> getRankedPokemonList(String rankingsCategory) {
    final rankedList =
        rankingsMap.values.map<Pokemon>((RankedPokemon rankedPokemon) {
      final Pokemon pokemon = Pokemon.from(
          globals.gamemaster.retrievePokemon(rankedPokemon.speciesId));

      pokemon.initializeMetaMoves(rankedPokemon.moveset);
      pokemon.setRating(rankedPokemon.getRating(rankingsCategory));
      return pokemon;
    }).toList();

    rankedList.sort((a, b) => ((b.rating - a.rating) * 100).toInt());

    return rankedList;
  }

  // Get a list of Pokemon that contain one of the specified types
  // The rankings category
  // The list length will be up to the limit
  List<Pokemon> getFilteredRankedPokemonList(
      List<Type> types, String rankingsCategory, int limit) {
    List<Pokemon> rankedList = getRankedPokemonList(rankingsCategory);

    rankedList = rankedList.where((pokemon) => pokemon.hasType(types)).toList();

    // There weren't enough Pokemon in this cup to satisfy the filtered limit
    if (rankedList.length < limit) {
      return rankedList;
    }

    return rankedList.getRange(0, limit).toList();
  }

  final Map<String, RankedPokemon> rankingsMap;
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
  num rating; // Used for caching a rating from one of the categories
  final List<String> moveset;

  num attackers = 0;
  num chargers = 0;
  num closers = 0;
  num consistency = 0;
  num leads = 0;
  num overall = 0;
  num switches = 0;

  num getRating(String rankingsCategory) {
    switch (rankingsCategory) {
      case 'attackers':
        return attackers;

      case 'chargers':
        return chargers;

      case 'closers':
        return closers;

      case 'consistency':
        return consistency;

      case 'leads':
        return leads;

      case 'overall':
        return overall;

      case 'switches':
        return switches;

      default:
        break;
    }
    return overall;
  }

  num calculateOverallRating() {
    List<num> ratings = [
      leads,
      closers,
      max(switches, chargers),
      attackers,
    ];

    ratings.sort((a, b) => ((b - a) * 100).toInt());
    overall = pow(
        pow(ratings[0], 9) *
            pow(ratings[1], 7) *
            pow(ratings[2], 6) *
            pow(ratings[3], 2),
        (1 / 27));

    overall = ((overall * 10) / 10).floor();

    return overall;
  }
}
