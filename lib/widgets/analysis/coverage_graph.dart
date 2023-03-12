// Dart
import 'dart:math';

// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../tools/pair.dart';
import '../../tools/logic.dart';
import '../../pogo_objects/pokemon_typing.dart';
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
    required this.teamSize,
  }) : super(key: key);

  final List<Pair<PokemonType, double>> netEffectiveness;
  final int teamSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: Sizing.blockSizeHorizontal * 7.0,
            right: Sizing.blockSizeHorizontal * 5.0,
            bottom: 4.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Poor',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline6?.apply(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Text(
                'Excellent',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline6?.apply(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: Sizing.blockSizeHorizontal * 7.0,
            right: Sizing.blockSizeHorizontal * 5.0,
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
            width: Sizing.screenWidth * .84,
            height: Sizing.blockSizeVertical * .6,
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
    Key? key,
    required this.typeData,
    required this.teamSize,
  }) : super(key: key);

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
            width: Sizing.blockSizeHorizontal * 6.0,
            child: PogoIcons.getPokemonTypeIcon(typeData.a.typeId),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: Sizing.blockSizeHorizontal * 5.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: PogoColors.getPokemonTypeColor(typeData.a.typeId),
            ),
            width: normalize(barLength / teamFactor, 0, 1) *
                Sizing.screenWidth *
                .8,
            height: Sizing.blockSizeVertical * 1.7,
          ),
        ),
      ],
    );
  }
}
