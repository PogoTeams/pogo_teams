// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'coverage_graph.dart';
import 'coverage_grids.dart';
import '../../utils/pair.dart';
import '../../model/pokemon_typing.dart';
import '../../app/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A column of type coverage analysis widgets. Used in any team analysis.
-------------------------------------------------------------------------------
*/

class TypeCoverage extends StatelessWidget {
  const TypeCoverage({
    super.key,
    required this.netEffectiveness,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.includedTypesKeys,
    required this.teamSize,
  });

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
          height: Sizing.screenHeight(context) * .025,
        ),

        CoverageGraph(
          netEffectiveness: netEffectiveness,
          teamSize: teamSize,
        ),
      ],
    );
  }
}
