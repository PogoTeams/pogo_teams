// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../data/pokemon/pokemon.dart';
import '../nodes/pokemon_nodes.dart';
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
A simple button displaying a Pokemon's species name.
The current filtered search list will render this widget for each Pokemon.
-------------------------------------------------------------------------------
*/

class CompactPokemonNodeButton extends StatelessWidget {
  const CompactPokemonNodeButton({
    Key? key,
    required this.pokemon,
    required this.onPressed,
    required this.onLongPress,
  }) : super(key: key);

  final Pokemon pokemon;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeHorizontal * 2.0,
        right: SizeConfig.blockSizeHorizontal * 4.0,
        bottom: SizeConfig.blockSizeHorizontal * 2.0,
        left: SizeConfig.blockSizeHorizontal * 4.0,
      ),

      // Callbacks
      onPressed: onPressed,
      onLongPress: onLongPress,

      // Pokemon name and button styling
      child: CompactPokemonNode(pokemon: pokemon),
    );
  }
}
