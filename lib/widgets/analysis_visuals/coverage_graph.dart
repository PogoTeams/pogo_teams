// Dart Imports
import 'dart:math';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Local Imports
import 'coverage_grids.dart';
import '../../tools/pair.dart';
import '../../data/pokemon/typing.dart';
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
Displays a horizontal bar graph, that visually indicates the team's net
coverage against all types. A balanced team should have most of the bars
half way across the screen.
-------------------------------------------------------------------------------
*/

class CoverageGraph extends StatelessWidget {
  const CoverageGraph({
    Key? key,
    required this.netEffectiveness,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.teamSize,
  }) : super(key: key);

  final List<Pair<Type, double>> netEffectiveness;
  final List<Pair<Type, double>> defenseThreats;
  final List<Pair<Type, double>> offenseCoverage;
  final int teamSize;

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;
    // Graph row mapping
    return Column(
      children: [
        CoverageGrids(
          defenseThreats: defenseThreats,
          offenseCoverage: offenseCoverage,
        ),

        // Spacer
        SizedBox(
          height: blockSize * 2.5,
        ),

        // Horizontal divider
        Divider(
          height: blockSize * 5.0,
          thickness: blockSize * .5,
          indent: blockSize * 1.5,
          endIndent: blockSize * 1.5,
          color: Colors.white54,
        ),

        // Spacer
        SizedBox(
          height: blockSize * 1.5,
        ),

        // Header
        Text(
          'Net Type Coverage',
          style: TextStyle(
            letterSpacing: SizeConfig.blockSizeHorizontal * .8,
            fontSize: SizeConfig.h1,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Spacer
        SizedBox(
          height: blockSize * 2.5,
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

  final Pair<Type, double> typeData;
  final int teamSize;

  @override
  Widget build(BuildContext context) {
    // Safety check on normalized values overflowing
    double barLength = min(typeData.b, 1.0);
    barLength = max(0.0, barLength);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal),
          child: typeData.a.getIcon(
            iconColor: 'white',
            scale: SizeConfig.blockSizeHorizontal * 1.2,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * .9),
            color: typeData.a.typeColor,
          ),
          width: SizeConfig.screenWidth * .85 * barLength,
          height: SizeConfig.blockSizeVertical * 1.7,
        ),
      ],
    );
  }
}
