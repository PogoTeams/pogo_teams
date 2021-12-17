// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package Imports
import 'package:http/http.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Local Imports
import 'colors.dart';
import 'pokemon_rankings.dart';
import 'pokemon/pokemon.dart';
import 'pokemon/typing.dart';
import 'masters/type_master.dart';

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
    required this.includedTypesKeys,
  });

  // Called to load in the given cup from a JSON
  // PokemonRankings.load will load all jsons from the pvpoke supplied 'data' directory
  static Future<Cup> loadCup(json, Box rankingsBox) async {
    final key = json['name'] as String;
    final int cp = json['cp'] ?? 1500;
    final rankings =
        await PokemonRankings.load(key, cp.toString(), rankingsBox);

    return Cup.fromJson(json, key, cp, rankings);
  }

  static Future<Cup> updateCup(
    json,
    Box rankingsBox,
    Client client,
  ) async {
    final key = json['name'] as String;
    final int cp = json['cp'] ?? 1500;
    final rankings =
        await PokemonRankings.update(key, cp.toString(), rankingsBox, client);

    return Cup.fromJson(json, key, cp, rankings);
  }

  factory Cup.fromJson(json, String key, int cp, PokemonRankings rankings) {
    final title = json['title'] as String;
    final Color cupColor = CupColors.getCupColor(title);

    List<String>? includedTypesKeys;

    // Get included types for this cup
    if (json.containsKey('include')) {
      final includes = List.from(json['include']);
      for (int i = 0; i < includes.length; ++i) {
        if (includes[i]['filterType'] == 'type') {
          includedTypesKeys = List<String>.from(includes[i]['values']);
        }
      }
    }

    // If included type keys is not specified, all types are included
    includedTypesKeys ??= TypeMaster.typeKeysList;

    return Cup(
      key: key,
      title: title,
      cp: cp,
      cupColor: cupColor,
      rankings: rankings,
      includedTypesKeys: includedTypesKeys,
    );
  }

  static Cup from(Cup other) {
    return Cup(
      key: other.key,
      title: other.title,
      cp: other.cp,
      cupColor: other.cupColor,
      rankings: other.rankings,
      includedTypesKeys: other.includedTypesKeys,
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
  final List<String> includedTypesKeys;
}
