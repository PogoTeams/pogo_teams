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
2 grids, displaying the type icons that are top defense threats team, and a
teams offense coverage based on movesets.
-------------------------------------------------------------------------------
*/

class CoverageGrids extends StatelessWidget {
  const CoverageGrids({
    Key? key,
    required this.defenseThreats,
    required this.offenseCoverage,
  }) : super(key: key);

  final List<Pair<Type, double>> defenseThreats;
  final List<Pair<Type, double>> offenseCoverage;

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;
    final double verticalBlockSize = SizeConfig.blockSizeVertical;
    // Row length for the coverage grid views
    int crossAxisCount = defenseThreats.length < 8 ? defenseThreats.length : 8;

    if (crossAxisCount < 3) crossAxisCount = 3;

    // List of top defensiveThreats
    return Column(
      children: [
        SizedBox(
          width: SizeConfig.screenWidth * .95,
          child: Container(
            padding: EdgeInsets.all(blockSize * 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(blockSize * 0.9),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red[900]!, Colors.red[200]!],
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
                        letterSpacing: SizeConfig.blockSizeHorizontal * .8,
                        fontSize: SizeConfig.h3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${defenseThreats.length} / 18',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: SizeConfig.blockSizeHorizontal * .8,
                        fontSize: SizeConfig.h3,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

                // Spacer
                SizedBox(
                  height: verticalBlockSize * 2.5,
                ),

                // Threat type Icons
                GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: SizeConfig.blockSizeHorizontal * .1,
                  mainAxisSpacing: SizeConfig.blockSizeVertical * 1.2,
                  childAspectRatio: blockSize * .5,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  children: defenseThreats
                      .map(
                        (pair) => pair.a.getIcon(
                          scale: SizeConfig.blockSizeHorizontal * 1.0,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),

        // Spacer
        SizedBox(
          height: verticalBlockSize * 2.5,
        ),

        // List of coverage
        SizedBox(
          width: SizeConfig.screenWidth * .95,
          child: Container(
            padding: EdgeInsets.all(blockSize * 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(blockSize * 0.9),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green[900]!, Colors.green[200]!],
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
                        letterSpacing: SizeConfig.blockSizeHorizontal * .8,
                        fontSize: SizeConfig.h3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${offenseCoverage.length} / 18',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: SizeConfig.blockSizeHorizontal * .8,
                        fontSize: SizeConfig.h3,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

                // Spacer
                SizedBox(
                  height: verticalBlockSize * 2.5,
                ),

                // Coverage type Icons
                GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: SizeConfig.blockSizeHorizontal * .1,
                  mainAxisSpacing: SizeConfig.blockSizeVertical * 1.2,
                  childAspectRatio: blockSize * .5,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  children: offenseCoverage
                      .map(
                        (pair) => pair.a.getIcon(
                          scale: SizeConfig.blockSizeHorizontal * 1.0,
                        ),
                      )
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
