// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../tools/pair.dart';
import '../../pogo_data/pokemon_typing.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/ui/pogo_icons.dart';

/*
-------------------------------------------------------------------- @PogoTeams
2 grids, displaying the type icons that are top defense threats team, and a
teams offense coverage based on movesets.
-------------------------------------------------------------------------------
*/

class CoverageGrids extends StatelessWidget {
  const CoverageGrids({
    Key? key,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.includedTypesKeys,
  }) : super(key: key);

  final List<Pair<PokemonType, double>> defenseThreats;
  final List<Pair<PokemonType, double>> offenseCoverage;
  final List<String> includedTypesKeys;

  @override
  Widget build(BuildContext context) {
    // Row length for the coverage grid views
    int crossAxisCount = defenseThreats.length < 6 ? defenseThreats.length : 6;

    if (crossAxisCount < 3) crossAxisCount = 3;

    // List of top defensiveThreats
    return Column(
      children: [
        SizedBox(
          child: Container(
            padding: EdgeInsets.all(Sizing.blockSizeHorizontal * 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red[900]!, Colors.red[400]!],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DEFENSE THREATS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: Sizing.blockSizeHorizontal * .8,
                        fontSize: Sizing.h3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${defenseThreats.length} / ${includedTypesKeys.length}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: Sizing.blockSizeHorizontal * .8,
                        fontSize: Sizing.h3,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

                // Spacer
                SizedBox(
                  height: Sizing.blockSizeVertical * 2.5,
                ),

                // Threat type Icons
                GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: Sizing.blockSizeHorizontal * .1,
                  mainAxisSpacing: Sizing.blockSizeVertical * .5,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  children: defenseThreats
                      .map(
                          (pair) => PogoIcons.getPokemonTypeIcon(pair.a.typeId))
                      .toList(),
                ),
              ],
            ),
          ),
        ),

        // Spacer
        SizedBox(
          height: Sizing.blockSizeVertical * 2.5,
        ),

        // List of coverage
        SizedBox(
          child: Container(
            padding: EdgeInsets.all(Sizing.blockSizeHorizontal * 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green[900]!, Colors.green[400]!],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OFFENSE COVERAGE',
                      style: TextStyle(
                        letterSpacing: Sizing.blockSizeHorizontal * .8,
                        fontSize: Sizing.h3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${offenseCoverage.length} / ${includedTypesKeys.length}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: Sizing.blockSizeHorizontal * .8,
                        fontSize: Sizing.h3,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

                // Spacer
                SizedBox(
                  height: Sizing.blockSizeVertical * 2.5,
                ),

                // Coverage type Icons
                GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: Sizing.blockSizeHorizontal * .1,
                  mainAxisSpacing: Sizing.blockSizeVertical * .5,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  children: offenseCoverage
                      .map(
                          (pair) => PogoIcons.getPokemonTypeIcon(pair.a.typeId))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
