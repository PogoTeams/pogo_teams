// Flutter Imports
import 'package:flutter/material.dart';

/*
-------------------------------------------------------------------------------
All color association is handled by the maps that are implemented here.
-------------------------------------------------------------------------------
*/

final Map<String, Color> typeColors = {
  'normal': const Color(0xFFA8A77A),
  'fire': const Color(0xFFEE8130),
  'water': const Color(0xFF6390F0),
  'electric': const Color(0xFFC7B000),
  'grass': const Color(0xFF7AC74C),
  'ice': const Color(0xFF96D9D6),
  'fighting': const Color(0xFFC22E28),
  'poison': const Color(0xFFA33EA1),
  'ground': const Color(0xFFE2BF65),
  'flying': const Color(0xFFA98FF3),
  'psychic': const Color(0xFFF95587),
  'bug': const Color(0xFFA6B91A),
  'rock': const Color(0xFFB6A136),
  'ghost': const Color(0xFF735797),
  'dragon': const Color(0xFF6F35FC),
  'dark': const Color(0xFF705746),
  'steel': const Color(0xFFB7B7CE),
  'fairy': const Color(0xFFD685AD),
  'none': Colors.black,
};

class CupColors {
  // Attempt to retrieve a unique color for the cup
  // Otherwise the default is cyan
  static Color getCupColor(String cupTitle) {
    String key = cupColors.keys
        .firstWhere((key) => cupTitle.contains(key), orElse: () => 'default');
    return cupColors[key] ?? Colors.cyan;
  }

  static const Map<String, Color> cupColors = {
    'Great League': Colors.blue,
    'Ultra League': Color(0xFFC8B603),
    'Master League': Colors.purple,
    'default': Colors.cyan,
  };
}
