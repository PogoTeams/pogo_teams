// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'colors.dart';
import 'rankings.dart';
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
  // Rankings.load will load all jsons from the pvpoke supplied 'data' directory
  static Future<Cup> generateCup(Map<String, dynamic> json) async {
    final key = json['key'] as String;
    final cp = json['cp'] as int;
    final rankings = await Rankings.load(key, cp);

    return Cup.fromJson(json, key, cp, rankings);
  }

  factory Cup.fromJson(
      Map<String, dynamic> json, String key, int cp, Rankings rankings) {
    final title = json['title'] as String;
    final cupColor = cupColors[title] as Color;

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

  List<Pokemon> getFilteredRankedPokemonList(
      List<Type> types, String rankingsCategory,
      {int limit = 20}) {
    return rankings.getFilteredRankedPokemonList(
        types, rankingsCategory, limit);
  }

  final String key;
  final String title;
  final int cp;
  final Color cupColor;
  final Rankings rankings;
}
