// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../pogo_objects/pokemon.dart';
import '../modules/ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
This Container will take a Pokemon, and apply a color style based off of that
Pokemon's typing. If it is mono-type, a solid color cooresponding to that
color will be applied, otherwise a linear gradient will be applied.
-------------------------------------------------------------------------------
*/

class ColoredContainer extends StatelessWidget {
  const ColoredContainer({
    Key? key,
    this.height,
    this.padding,
    required this.pokemon,
    required this.child,
  }) : super(key: key);

  final double? height;
  final EdgeInsets? padding;
  final Pokemon pokemon;
  final Widget child;

  // If the pokemon is monotype, color the node to this type
  // For duotyping, render a linear gradient between the type colors
  BoxDecoration _buildDecoration(Pokemon pokemon) {
    if (pokemon.typing.isMonoType()) {
      return BoxDecoration(
        color: PogoColors.getPokemonTypeColor(pokemon.typing.typeA.typeId),
        borderRadius: BorderRadius.circular(20),
      );
    }

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: PogoColors.getPokemonTypingColors(pokemon.typing),
        tileMode: TileMode.clamp,
      ),
      borderRadius: BorderRadius.circular(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: padding,
      decoration: _buildDecoration(pokemon),
      child: child,
    );
  }
}
