// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../tools/pair.dart';
import '../../pogo_objects/pokemon_typing.dart';
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
    int crossAxisCount = 9;

    // List of top defensiveThreats
    return Column(
      children: [
        SizedBox(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 183, 28, 28),
                  Color.fromARGB(255, 239, 83, 80),
                ],
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
                      'Defense Threats',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6?.apply(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    Text(
                      '${defenseThreats.length} / ${includedTypesKeys.length}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  // Threat type Icons
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: Sizing.blockSizeHorizontal * .1,
                    mainAxisSpacing: Sizing.blockSizeVertical * .5,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    children: defenseThreats
                        .map((pair) =>
                            PogoIcons.getPokemonTypeIcon(pair.a.typeId))
                        .toList(),
                  ),
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
            padding: const EdgeInsets.all(12.0),
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
                      'Offense Coverage',
                      style: Theme.of(context).textTheme.headline6?.apply(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    Text(
                      '${offenseCoverage.length} / ${includedTypesKeys.length}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),

                // Coverage type Icons
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisSpacing: Sizing.blockSizeHorizontal * .1,
                    mainAxisSpacing: Sizing.blockSizeVertical * .5,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    children: offenseCoverage
                        .map((pair) =>
                            PogoIcons.getPokemonTypeIcon(pair.a.typeId))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
