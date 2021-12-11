// Dart Imports
import 'dart:math';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Local Imports
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
  }) : super(key: key);

  final List<Pair<Type, double>> netEffectiveness;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 7.0,
            ),
            Text(
              'Poor',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.h2,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 61.0,
            ),
            Text(
              'Excellent',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.h2,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 7.0,
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
              width: SizeConfig.blockSizeHorizontal * 84.0,
              height: SizeConfig.blockSizeVertical * .6,
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 1.0,
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

  final Pair<Type, double> typeData;

  @override
  Widget build(BuildContext context) {
    // Safety check on normalized values
    double barLength = min(typeData.b, 1.6);
    barLength = max(0.1, barLength);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal),
          child: typeData.a.getIcon(
            scale: SizeConfig.blockSizeHorizontal * 1.2,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: typeData.a.typeColor,
          ),
          width: SizeConfig.screenWidth * .52 * barLength,
          height: SizeConfig.blockSizeVertical * 1.7,
        ),
      ],
    );
  }
}
