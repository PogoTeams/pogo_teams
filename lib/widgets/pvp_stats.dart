// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../model/pokemon_stats.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A display of a Pokemon's max CP and perfect IVs, given the cup in question.
-------------------------------------------------------------------------------
*/

class PvpStats extends StatelessWidget {
  const PvpStats({
    super.key,
    required this.cp,
    required this.ivs,
  });

  final int cp;
  final IVs ivs;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'CP $cp',
          style: Theme.of(context).textTheme.titleLarge?.apply(
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
        Text(
          '${ivs.atk} | ${ivs.def} | ${ivs.hp}',
          style: Theme.of(context).textTheme.titleLarge?.apply(
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
