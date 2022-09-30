// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../pogo_data/pokemon.dart';
import '../modules/ui/sizing.dart';

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
    Key? key,
    required this.pokemon,
    this.scale = 1.0,
  }) : super(key: key);

  final Pokemon pokemon;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //pokemon.isXL ? XlIcon(scale: scale) : Container(),
          pokemon.isShadow ? ShadowIcon(scale: scale) : Container(),
        ],
      ),
    );
  }
}

class XlIcon extends StatelessWidget {
  const XlIcon({
    Key? key,
    required this.scale,
  }) : super(key: key);

  final double scale;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: Sizing.blockSizeVertical * 3.0 * scale,
        child: Padding(
          padding: EdgeInsets.only(
            left: Sizing.blockSizeHorizontal * 2.5 * scale,
            right: Sizing.blockSizeHorizontal * 2.5 * scale,
          ),
          child: Center(
            child: Text(
              'X L',
              style: TextStyle(
                fontSize: Sizing.h3 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShadowIcon extends StatelessWidget {
  const ShadowIcon({
    Key? key,
    required this.scale,
  }) : super(key: key);

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.local_fire_department_rounded,
      color: Colors.purple[900]!,
      size: Sizing.blockSizeHorizontal * 6.0 * scale,
    );
  }
}
