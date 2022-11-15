// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../pogo_objects/pokemon_stats.dart';

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
          style: Theme.of(context).textTheme.headline5?.apply(
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
        Text(
          '${ivs.atk} | ${ivs.def} | ${ivs.hp}',
          style: Theme.of(context).textTheme.headline5?.apply(
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
