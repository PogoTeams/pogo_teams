// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../model/pokemon_base.dart';
import '../app/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
These icons will appear in a row in a Pokemon's node. Here are the current
possible icons :
XL - XL candy Pokemon
Flame - Shadow Pokemon
-------------------------------------------------------------------------------
*/

class TraitsIcons extends StatelessWidget {
  const TraitsIcons({
    super.key,
    required this.pokemon,
    this.scale = 1.0,
  });

  final PokemonBase pokemon;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //pokemon.isXL ? XlIcon(scale: scale) : Container(),
          pokemon.isShadow() ? ShadowIcon(scale: scale) : Container(),
        ],
      ),
    );
  }
}

class XlIcon extends StatelessWidget {
  const XlIcon({
    super.key,
    required this.scale,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: Sizing.screenHeight(context) * .03 * scale,
        child: Padding(
          padding: EdgeInsets.only(
            left: Sizing.screenWidth(context) * .025 * scale,
            right: Sizing.screenWidth(context) * .025 * scale,
          ),
          child: Center(
            child: Text(
              'X L',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    );
  }
}

class ShadowIcon extends StatelessWidget {
  const ShadowIcon({
    super.key,
    required this.scale,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.local_fire_department_rounded,
      color: Colors.purple[900]!,
      size: Sizing.screenWidth(context) * .06 * scale,
    );
  }
}
