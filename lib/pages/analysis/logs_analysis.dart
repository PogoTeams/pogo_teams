// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../widgets/analysis/type_coverage.dart';
import '../../widgets/pokemon_list.dart';
import '../../pogo_data/pokemon.dart';
import '../../pogo_data/pokemon_team.dart';
import '../../pogo_data/pokemon_typing.dart';
import '../../modules/data/gamemaster.dart';
import '../../modules/ui/sizing.dart';
import '../../tools/pair.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A net analysis of all logged opponent teams. This page follows the same pattern
as OpponentTeamAnalysis.
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
  final List<Pair<PokemonType, double>> defenseThreats;
  final List<Pair<PokemonType, double>> offenseCoverage;
  final List<Pair<PokemonType, double>> netEffectiveness;

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Logged Opponents Net Analysis',
            style: TextStyle(
              fontSize: Sizing.h2,
              fontStyle: FontStyle.italic,
            ),
          ),

          // Spacer
          SizedBox(
            width: Sizing.blockSizeHorizontal * 3.0,
          ),

          // Page icon
          Icon(
            Icons.analytics,
            size: Sizing.h2 * 1.5,
          ),
        ],
      ),
    );
  }

  // Build a list of counters to the logged opponent teams
  Widget _buildCountersList(List<Pair<PokemonType, double>> defenseThreats) {
    final counterTypes = defenseThreats.map((typeData) => typeData.a).toList();

    List<Pokemon> counters = Gamemaster.getFilteredRankedPokemonList(
      team.cup,
      counterTypes,
      'overall',
      limit: 50,
    );

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
          top: Sizing.blockSizeVertical * 2.0,
          left: Sizing.blockSizeHorizontal * 2.0,
          right: Sizing.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            // PokemonType coverage widgets
            TypeCoverage(
              netEffectiveness: netEffectiveness,
              defenseThreats: defenseThreats,
              offenseCoverage: offenseCoverage,
              includedTypesKeys: team.cup.includedTypeKeys,
            ),

            // Spacer
            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

            Text('Top Counters',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Sizing.h1,
                  fontWeight: FontWeight.bold,
                  letterSpacing: Sizing.blockSizeHorizontal * .7,
                )),

            Divider(
              height: Sizing.blockSizeVertical * 5.0,
              thickness: Sizing.blockSizeVertical * .5,
              indent: Sizing.blockSizeHorizontal * 2.0,
              endIndent: Sizing.blockSizeHorizontal * 2.0,
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
