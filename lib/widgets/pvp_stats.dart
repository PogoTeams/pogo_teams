// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../game_objects/pokemon_stats.dart';
import '../modules/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A display of a Pokemon's max CP and perfect IVs, given the cup in question.
-------------------------------------------------------------------------------
*/

class PvpStats extends StatelessWidget {
  const PvpStats({
    Key? key,
    required this.cp,
    required this.ivs,
  }) : super(key: key);

  final int cp;
  final IVs ivs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'CP $cp',
          style: TextStyle(
            letterSpacing: Sizing.blockSizeHorizontal * .7,
            fontSize: Sizing.p,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          '${ivs.atk} | ${ivs.def} | ${ivs.hp}',
          style: TextStyle(
            letterSpacing: Sizing.blockSizeHorizontal * .7,
            fontSize: Sizing.h3,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
