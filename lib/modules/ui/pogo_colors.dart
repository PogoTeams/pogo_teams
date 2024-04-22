// dart
import 'dart:math';

// Flutter
import 'package:flutter/material.dart';

// Local
import '../../pogo_objects/pokemon_typing.dart';
import '../../pogo_objects/move.dart';
import '../../pogo_objects/cup.dart';
import '../../enums/battle_outcome.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All color association is handled by the mappings that are implemented here.
-------------------------------------------------------------------------------
*/

class PogoColors {
  static const Color green = Color.fromARGB(255, 6, 201, 32);
  static const Color green2 = Color.fromARGB(255, 10, 187, 122);
  static const Color red = Color.fromARGB(255, 231, 63, 61);
  static const Color red2 = Color.fromARGB(255, 255, 135, 153);
  static const Color inactiveGrey = Color.fromARGB(255, 132, 132, 132);
  static const Color error = Color.fromARGB(255, 255, 174, 11);

  static const List<Color> greenGradient = [
    green,
    green2,
  ];

  static const List<Color> redGradient = [
    red,
    red2,
  ];

  static Color getRandomColor() =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  static const Map<String, Color> _typeColors = {
    'normal': Color(0xFFA8A77A),
    'fire': Color(0xFFEE8130),
    'water': Color(0xFF6390F0),
    'electric': Color(0xFFC7B000),
    'grass': Color(0xFF7AC74C),
    'ice': Color(0xFF96D9D6),
    'fighting': Color(0xFFC22E28),
    'poison': Color(0xFFA33EA1),
    'ground': Color(0xFFE2BF65),
    'flying': Color(0xFFA98FF3),
    'psychic': Color(0xFFF95587),
    'bug': Color(0xFFA6B91A),
    'rock': Color(0xFFB6A136),
    'ghost': Color(0xFF735797),
    'dragon': Color(0xFF6F35FC),
    'dark': Color(0xFF705746),
    'steel': Color(0xFFB7B7CE),
    'fairy': Color(0xFFD685AD),
  };

  static Color get defaultTypeColor => Colors.black;
  static Color get defaultCupColor => Colors.cyan;

  static Color getPokemonTypeColor(String typeId) =>
      _typeColors[typeId] ?? defaultTypeColor;

  static List<Color> getPokemonTypingColors(PokemonTyping typing) {
    if (typing.isMonoType()) {
      return [_typeColors[typing.typeA.typeId] ?? defaultTypeColor];
    }

    return [
      _typeColors[typing.typeA.typeId] ?? defaultTypeColor,
      _typeColors[typing.typeB?.typeId] ?? defaultTypeColor,
    ];
  }

  static List<Color> getPokemonMovesetColors(List<Move> moveset) => moveset
      .map((move) => _typeColors[move.type.typeId] ?? defaultTypeColor)
      .toList();

  static Color getCupColor(Cup cup) =>
      cup.uiColor == null ? defaultCupColor : Color(int.parse(cup.uiColor!));

  static Color getBattleOutcomeColor(BattleOutcome outcome) {
    Color color;

    switch (outcome) {
      case BattleOutcome.win:
        color = const Color.fromARGB(188, 9, 210, 126);
        break;

      case BattleOutcome.loss:
        color = Colors.deepOrange;
        break;

      case BattleOutcome.tie:
        color = Colors.grey;
        break;
    }

    return color;
  }
}
