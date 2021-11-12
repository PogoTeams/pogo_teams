// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'colors.dart';
import 'rankings.dart';
import 'pokemon/pokemon.dart';

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
  });

  factory Cup.fromJson(Map<String, dynamic> json) {
    final key = json['key'] as String;
    final title = json['title'] as String;
    final cp = json['cp'] as int;
    final cupColor = cupColors[title] as Color;

    return Cup(
      key: key,
      title: title,
      cp: cp,
      cupColor: cupColor,
    );
  }

  // Load the rankings information for this cup
  void loadRankings() async {
    rankings = await Rankings.load(key, cp);
  }

  // Get a sorted list of ranked pokemon for this cup, given a category
  List<Pokemon> getRankedPokemonList(String rankingsCategory) {
    return rankings.getRankedPokemonList(rankingsCategory);
  }

  final String key;
  final String title;
  final int cp;
  final Color cupColor;
  late Rankings rankings;
}
