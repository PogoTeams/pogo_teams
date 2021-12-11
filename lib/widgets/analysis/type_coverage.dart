// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'coverage_graph.dart';
import 'coverage_grids.dart';
import '../../tools/pair.dart';
import '../../data/pokemon/typing.dart';
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
A column of type coverage analysis widgets. Used in team analysis.
-------------------------------------------------------------------------------
*/

class TypeCoverage extends StatelessWidget {
  const TypeCoverage({
    Key? key,
    required this.netEffectiveness,
    required this.defenseThreats,
    required this.offenseCoverage,
  }) : super(key: key);

  final List<Pair<Type, double>> netEffectiveness;
  final List<Pair<Type, double>> defenseThreats;
  final List<Pair<Type, double>> offenseCoverage;

  @override
  Widget build(BuildContext context) {
    // Graph row mapping
    return Column(
      children: [
        CoverageGrids(
          defenseThreats: defenseThreats,
          offenseCoverage: offenseCoverage,
        ),

        // Spacer
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2.5,
        ),

        CoverageGraph(
          netEffectiveness: netEffectiveness,
        ),
      ],
    );
  }
}
