// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'coverage_graph.dart';
import 'coverage_grids.dart';
import '../../tools/pair.dart';
import '../../pogo_objects/pokemon_typing.dart';
import '../../modules/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A column of type coverage analysis widgets. Used in any team analysis.
-------------------------------------------------------------------------------
*/

class TypeCoverage extends StatelessWidget {
  const TypeCoverage({
    Key? key,
    required this.netEffectiveness,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.includedTypesKeys,
    required this.teamSize,
  }) : super(key: key);

  final List<Pair<PokemonType, double>> netEffectiveness;
  final List<Pair<PokemonType, double>> defenseThreats;
  final List<Pair<PokemonType, double>> offenseCoverage;
  final List<String> includedTypesKeys;
  final int teamSize;

  @override
  Widget build(BuildContext context) {
    // Graph row mapping
    return ListView(
      children: [
        CoverageGrids(
          defenseThreats: defenseThreats,
          offenseCoverage: offenseCoverage,
          includedTypesKeys: includedTypesKeys,
        ),

        // Spacer
        SizedBox(
          height: Sizing.blockSizeVertical * 2.5,
        ),

        CoverageGraph(
          netEffectiveness: netEffectiveness,
          teamSize: teamSize,
        ),
      ],
    );
  }
}
