// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local Imports
import '../../widgets/pokemon_list/pokemon_list.dart';
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
      title: const Align(
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.analytics,
          size: Sizing.icon3,
        ),
      ),
    );
  }

  // Build a list of counters to the logged opponent teams
  Future<Widget> _buildCountersList(
    BuildContext context,
    List<Pair<PokemonType, double>> defenseThreats,
  ) async {
    final counterTypes = defenseThreats.map((typeData) => typeData.a).toList();

    List<CupPokemon> counters = context.read<PogoRepository>().getCupPokemon(
          team.cup,
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
        padding: Sizing.horizontalWindowInsets(context).copyWith(),
        child: ListView(
          children: [
            Text(
              'Top Counters',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            Divider(
              height: Sizing.screenHeight(context) * .05,
              thickness: Sizing.borderWidth,
              indent: Sizing.screenWidth(context) * .02,
              endIndent: Sizing.screenWidth(context) * .02,
              color: Colors.white,
            ),

            // A list of top counters to the logged opponent teams
            FutureBuilder(
              future: _buildCountersList(context, defenseThreats),
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
