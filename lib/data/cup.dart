// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'colors.dart';

/*
-------------------------------------------------------------------------------
Every possible cup in PVP can be encapsulated here. The GameMaster will read
in a list of cups from the assets/gamemaster.json.
-------------------------------------------------------------------------------
*/

class Cup {
  Cup({
    required this.name,
    required this.title,
    required this.cp,
    required this.cupColor,
  });

  factory Cup.fromJson(
    Map<String, dynamic> json,
  ) {
    final name = json['name'] as String;
    final title = json['title'] as String;
    final cp = json['cp'] as int;
    final cupColor = cupColors[name] as Color;

    return Cup(
      name: name,
      title: title,
      cp: cp,
      cupColor: cupColor,
    );
  }

  final String name;
  final String title;
  final int cp;
  final Color cupColor;
}
