// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../widgets/analysis/type_coverage.dart';
import '../../widgets/pokemon_list.dart';
import '../../model/pokemon.dart';
import '../../model/pokemon_team.dart';
import '../../model/pokemon_typing.dart';
import '../../modules/pogo_repository.dart';
import '../../app/ui/sizing.dart';
import '../../utils/pair.dart';
import '../../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A net analysis of all logged opponent teams. This page follows the same pattern
as OpponentTeamAnalysis.
-------------------------------------------------------------------------------
*/

class LogsAnalysis extends StatelessWidget {
  const LogsAnalysis({
    super.key,
    required this.team,
    required this.opponents,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.netEffectiveness,
  });

  final UserPokemonTeam team;
  final List<OpponentPokemonTeam> opponents;
  final List<Pair<PokemonType, double>> defenseThreats;
  final List<Pair<PokemonType, double>> offenseCoverage;
  final List<Pair<PokemonType, double>> netEffectiveness;

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Logged Opponents Net Analysis',
            style: Theme.of(context).textTheme.titleLarge?.apply(
                  fontStyle: FontStyle.italic,
                ),
          ),

          // Spacer
          SizedBox(
            width: Sizing.screenWidth(context) * .3,
          ),

          // Page icon
          const Icon(
            Icons.analytics,
            size: Sizing.icon3,
          ),
        ],
      ),
    );
  }

  // Build a list of counters to the logged opponent teams
  Future<Widget> _buildCountersList(
    List<Pair<PokemonType, double>> defenseThreats,
  ) async {
    final counterTypes = defenseThreats.map((typeData) => typeData.a).toList();

    List<CupPokemon> counters = await PogoRepository.getCupPokemon(
      team.getCup(),
      counterTypes,
      RankingsCategories.overall,
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
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.only(
          top: Sizing.screenHeight(context) * .2,
          left: Sizing.screenWidth(context) * .2,
          right: Sizing.screenWidth(context) * .2,
        ),
        child: ListView(
          children: [
            // PokemonType coverage widgets
            TypeCoverage(
              netEffectiveness: netEffectiveness,
              defenseThreats: defenseThreats,
              offenseCoverage: offenseCoverage,
              includedTypesKeys: team.getCup().includedTypeKeys(),
              teamSize: team.teamSize,
            ),

            // Spacer
            SizedBox(
              height: Sizing.screenHeight(context) * .2,
            ),

            Text(
              'Top Counters',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            Divider(
              height: Sizing.screenHeight(context) * .5,
              thickness: Sizing.screenHeight(context) * .05,
              indent: Sizing.screenWidth(context) * .2,
              endIndent: Sizing.screenWidth(context) * .2,
              color: Colors.white,
            ),

            // A list of top counters to the logged opponent teams
            FutureBuilder(
              future: _buildCountersList(defenseThreats),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
