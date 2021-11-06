import 'package:flutter/material.dart';
import 'colors.dart';

/*
A single Pokemon move which is either a fast move or charged move with
respective typing, coloring, and stats.
*/
class Move {
  Move({
    required this.moveId,
    required this.name,
    required this.type,
    required this.typeColor,
    required this.power,
    required this.energy,
    required this.cooldown,
    this.archetype,
    this.abbreviation,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    final moveId = json['moveId'] as String;
    final name = json['name'] as String;
    final type = json['type'] as String;
    final typeColor = typeColors[type] as Color;
    final power = json['power'] as num;
    final energy = json['energy'] as num;
    final cooldown = json['cooldown'] as num;

    final abbreviation = json['abbreviation'] as String?;
    final archetype = json['archetype'] as String?;

    return Move(
      moveId: moveId,
      name: name,
      type: type,
      typeColor: typeColor,
      power: power,
      energy: energy,
      cooldown: cooldown,
      abbreviation: abbreviation,
      archetype: archetype,
    );
  }

  final String moveId;
  final String name;
  final String type;
  final Color typeColor;
  final num power;
  final num energy;
  final num cooldown;
  final String? abbreviation;
  final String? archetype;
}
