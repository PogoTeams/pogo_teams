// Dart
import 'dart:math';

// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../utils/pair.dart';
import '../../utils/logic.dart';
import '../../model/pokemon_typing.dart';
import '../../app/ui/sizing.dart';
import '../../app/ui/pogo_icons.dart';
import '../../app/ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Displays a horizontal bar graph, that visually indicates the team's net
coverage against all types. A balanced team should have most of the bars
half way across the screen.
-------------------------------------------------------------------------------
*/

class CoverageGraph extends StatelessWidget {
  const CoverageGraph({
    super.key,
    required this.netEffectiveness,
    required this.teamSize,
  });

  final List<Pair<PokemonType, double>> netEffectiveness;
  final int teamSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: Sizing.screenWidth(context) * .7,
            right: Sizing.screenWidth(context) * .5,
            bottom: 4.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Poor',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge?.apply(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Text(
                'Excellent',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.titleLarge?.apply(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: Sizing.screenWidth(context) * .7,
            right: Sizing.screenWidth(context) * .5,
            bottom: 10.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.deepOrange, Color(0xBF29F19C)],
                tileMode: TileMode.clamp,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            width: Sizing.screenWidth(context) * .84,
            height: Sizing.screenHeight(context) * .05,
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: netEffectiveness
              .map((pair) => GraphRow(
                    typeData: pair,
                    teamSize: teamSize,
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class GraphRow extends StatelessWidget {
  const GraphRow({
    super.key,
    required this.typeData,
    required this.teamSize,
  });

  final Pair<PokemonType, double> typeData;
  final int teamSize;

  @override
  Widget build(BuildContext context) {
    // Safety check on normalized values
    double teamFactor = min(3, teamSize ~/ 3) * 4.096;
    double barLength = max(0.1, min(typeData.b, teamFactor));

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: SizedBox(
            width: Sizing.screenWidth(context) * .6,
            child: PogoIcons.getPokemonTypeIcon(typeData.a.typeId),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: Sizing.screenWidth(context) * .5,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: PogoColors.getPokemonTypeColor(typeData.a.typeId),
            ),
            width: normalize(barLength / teamFactor, 0, 1) *
                Sizing.screenWidth(context) *
                .8,
            height: Sizing.screenHeight(context) * .1,
          ),
        ),
      ],
    );
  }
}
