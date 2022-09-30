// Dart Imports
import 'dart:math';

// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../tools/pair.dart';
import '../../pogo_data/pokemon_typing.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/ui/pogo_icons.dart';
import '../../modules/ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Displays a horizontal bar graph, that visually indicates the team's net
coverage against all types. A balanced team should have most of the bars
half way across the screen.
-------------------------------------------------------------------------------
*/

class CoverageGraph extends StatelessWidget {
  const CoverageGraph({
    Key? key,
    required this.netEffectiveness,
  }) : super(key: key);

  final List<Pair<PokemonType, double>> netEffectiveness;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: Sizing.blockSizeHorizontal * 7.0,
            ),
            Text(
              'Poor',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Sizing.h2,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(
              width: Sizing.screenWidth * .61,
            ),
            Text(
              'Excellent',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Sizing.h2,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: Sizing.blockSizeHorizontal * 7.0,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.red, Colors.green],
                  tileMode: TileMode.clamp,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              width: Sizing.screenWidth * .84,
              height: Sizing.blockSizeVertical * .6,
            ),
          ],
        ),
        SizedBox(
          height: Sizing.blockSizeVertical * 1.0,
        ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: netEffectiveness
              .map((pair) => GraphRow(
                    typeData: pair,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class GraphRow extends StatelessWidget {
  const GraphRow({
    Key? key,
    required this.typeData,
  }) : super(key: key);

  final Pair<PokemonType, double> typeData;

  @override
  Widget build(BuildContext context) {
    // Safety check on normalized values
    double barLength = min(typeData.b, 1.6);
    barLength = max(0.1, barLength);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: Sizing.blockSizeHorizontal),
          child: SizedBox(
            width: Sizing.blockSizeHorizontal * 6.0,
            child: PogoIcons.getPokemonTypeIcon(typeData.a.typeId),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: PogoColors.getPokemonTypeColor(typeData.a.typeId),
          ),
          width: Sizing.screenWidth * .52 * barLength,
          height: Sizing.blockSizeVertical * 1.7,
        ),
      ],
    );
  }
}
