// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'colors.dart';
import 'pokemon_rankings.dart';
import 'pokemon/pokemon.dart';
import 'pokemon/typing.dart';

/*
-------------------------------------------------------------------------------
Every possible cup in PVP can be encapsulated here. The GameMaster will read
in a list of cups from the assets/gamemaster.json.
-------------------------------------------------------------------------------
*/

class Cup {
  Cup({
    required this.key,
    required this.title,
    required this.cp,
    required this.cupColor,
    required this.rankings,
  });

  // Called to load in the given cup from a JSON
  // PokemonRankings.load will load all jsons from the pvpoke supplied 'data' directory
  static Future<Cup> generateCup(Map<String, dynamic> json) async {
    final key = json['name'] as String;
    final int cp = json['cp'] ?? 1500;
    final rankings = await PokemonRankings.load(key, cp);

    return Cup.fromJson(json, key, cp, rankings);
  }

  static Cup from(Cup other) {
    return Cup(
      key: other.key,
      title: other.title,
      cp: other.cp,
      cupColor: other.cupColor,
      rankings: other.rankings,
    );
  }

  factory Cup.fromJson(
      Map<String, dynamic> json, String key, int cp, PokemonRankings rankings) {
    final title = json['title'] as String;
    final Color cupColor = (cupColors[title] ?? Colors.cyan);

    return Cup(
      key: key,
      title: title,
      cp: cp,
      cupColor: cupColor,
      rankings: rankings,
    );
  }

  // Get a sorted list of ranked pokemon for this cup, given a category
  List<Pokemon> getRankedPokemonList(String rankingsCategory) {
    return rankings.getRankedPokemonList(rankingsCategory);
  }

  // Given a list of types, and category, generate a list of the top Pokemon
  // the size of the list will at most be the provided limit
  List<Pokemon> getFilteredRankedPokemonList(
      List<Type> types, String rankingsCategory,
      {int limit = 20}) {
    return rankings.getFilteredRankedPokemonList(
        types, rankingsCategory, limit);
  }

  Map<String, dynamic> toJson() {
    return {'cup': title};
  }

  final String key;
  final String title;
  final int cp;
  final Color cupColor;
  final PokemonRankings rankings;
}
