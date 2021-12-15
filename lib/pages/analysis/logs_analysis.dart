// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Local Imports
import '../../widgets/analysis/type_coverage.dart';
import '../../widgets/pokemon_list.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/typing.dart';
import '../../configs/size_config.dart';
import '../../tools/pair.dart';

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class LogsAnalysis extends StatelessWidget {
  const LogsAnalysis({
    Key? key,
    required this.team,
    required this.logs,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.netEffectiveness,
  }) : super(key: key);

  final UserPokemonTeam team;
  final List<PokemonTeam> logs;
  final List<Pair<Type, double>> defenseThreats;
  final List<Pair<Type, double>> offenseCoverage;
  final List<Pair<Type, double>> netEffectiveness;

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Logged Opponents Net Analysis',
            style: TextStyle(
              fontSize: SizeConfig.h2,
              fontStyle: FontStyle.italic,
            ),
          ),

          // Spacer
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 3.0,
          ),

          // Page icon
          Icon(
            Icons.analytics,
            size: SizeConfig.blockSizeHorizontal * 6.0,
          ),
        ],
      ),
    );
  }

  // Build a list of counters to the logged opponent teams
  Widget _buildCountersList(List<Pair<Type, double>> defenseThreats) {
    final counterTypes = defenseThreats.map((typeData) => typeData.a).toList();

    List<Pokemon> counters = team.cup
        .getFilteredRankedPokemonList(counterTypes, 'overall', limit: 50);

    return PokemonColumn(
      pokemon: counters,
      onPokemonSelected: (_) {},
      dropdowns: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 2.0,
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            // Type coverage widgets
            TypeCoverage(
              netEffectiveness: netEffectiveness,
              defenseThreats: defenseThreats,
              offenseCoverage: offenseCoverage,
              includedTypesKeys: team.cup.includedTypesKeys,
            ),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),

            Text('Top Counters',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.h1,
                  fontWeight: FontWeight.bold,
                  letterSpacing: SizeConfig.blockSizeHorizontal * .7,
                )),

            Divider(
              height: SizeConfig.blockSizeVertical * 5.0,
              thickness: SizeConfig.blockSizeVertical * .5,
              indent: SizeConfig.blockSizeHorizontal * 2.0,
              endIndent: SizeConfig.blockSizeHorizontal * 2.0,
              color: Colors.white,
            ),

            // A list of top counters to the logged opponent teams
            _buildCountersList(defenseThreats),
          ],
        ),
      ),
    );
  }
}
