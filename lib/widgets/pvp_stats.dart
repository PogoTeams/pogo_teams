// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';
/*
-------------------------------------------------------------------- @PogoTeams
A display of a Pokemon's max CP and perfect IVs, given the cup in question.
-------------------------------------------------------------------------------
*/

class PvpStats extends StatelessWidget {
  const PvpStats({
    Key? key,
    required this.perfectStats,
  }) : super(key: key);

  final List<num> perfectStats;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'CP ' + perfectStats[4].toString(),
          style: TextStyle(
            letterSpacing: SizeConfig.blockSizeHorizontal * .7,
            fontSize: SizeConfig.p,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          perfectStats[1].toString() +
              ' | ' +
              perfectStats[2].toString() +
              ' | ' +
              perfectStats[3].toString(),
          style: TextStyle(
            letterSpacing: SizeConfig.blockSizeHorizontal * .7,
            fontSize: SizeConfig.h3,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
