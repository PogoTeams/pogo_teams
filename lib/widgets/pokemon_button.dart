// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/pokemon/pokemon.dart';
import 'colored_container.dart';

/*
-------------------------------------------------------------------------------
A simple button displaying a Pokemon's species name.
The current filtered search list will render this widget for each Pokemon.
-------------------------------------------------------------------------------
*/

class PokemonButton extends StatelessWidget {
  const PokemonButton({
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
    return TextButton(
      // Callbacks
      onPressed: onPressed,
      onLongPress: onLongPress,

      // Pokemon name and button styling
      child: ColoredContainer(
        pokemon: pokemon,
        height: SizeConfig.blockSizeVertical * 4.5,
        child: Center(
          child: Text(
            pokemon.speciesName + ' ' + pokemon.rating.toString(),
            style: TextStyle(
              fontSize: SizeConfig.h2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
