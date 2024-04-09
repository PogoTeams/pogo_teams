// Flutter
import 'package:flutter/material.dart';

// Local
import '../../pogo_objects/pokemon_typing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A module for Pokemon related Icons.
-------------------------------------------------------------------------------
*/

class PogoIcons {
  // Get a type icon for this type, if size is not specified, the default size
  // will render
  static Widget getPokemonTypeIcon(typeId, {double scale = 1.0}) {
    if (typeId == 'none') return Container();
    return Image.asset(
      '${'assets/white_type_icons/' + typeId}.png',
      scale: scale,
    );
  }

  static List<Widget> getPokemonTypingIcons(
    PokemonTyping typing, {
    double scale = 1.0,
  }) {
    if (typing.typeA.isNone()) return [];

    if (typing.isMonoType()) {
      return [
        Image.asset(
          'assets/white_type_icons/${typing.typeA.typeId}.png',
          scale: scale,
        )
      ];
    }
    return [
      Image.asset(
        'assets/white_type_icons/${typing.typeA.typeId}.png',
        scale: scale,
      ),
      Image.asset(
        'assets/white_type_icons/${typing.typeB!.typeId}.png',
        scale: scale,
      ),
    ];
  }
}
