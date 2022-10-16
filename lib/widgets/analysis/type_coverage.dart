// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'coverage_graph.dart';
import 'coverage_grids.dart';
import '../../tools/pair.dart';
import '../../game_objects/pokemon_typing.dart';
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
  }) : super(key: key);

  final List<Pair<PokemonType, double>> netEffectiveness;
  final List<Pair<PokemonType, double>> defenseThreats;
  final List<Pair<PokemonType, double>> offenseCoverage;
  final List<String> includedTypesKeys;

  @override
  Widget build(BuildContext context) {
    // Graph row mapping
    return Column(
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

        CoverageGraph(netEffectiveness: netEffectiveness),
      ],
    );
  }
}
