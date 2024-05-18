// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../widgets/pokemon_list.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../model/pokemon.dart';
import '../../model/pokemon_typing.dart';
import '../../model/pokemon_team.dart';
import '../../modules/pogo_repository.dart';
import '../../app/ui/sizing.dart';
import '../../utils/pair.dart';
import '../../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
An analysis page for a single opponent team. Changes can be made to the user's
team as well, via the swap feature.
-------------------------------------------------------------------------------
*/

class OpponentTeamAnalysis extends StatelessWidget {
  const OpponentTeamAnalysis({
    super.key,
    required this.team,
    required this.pokemonTeam,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.netEffectiveness,
  });

  final UserPokemonTeam team;
  final List<UserPokemon> pokemonTeam;
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

  // Build the list of either 3 or 6 PokemonNodes that make up this team
  Widget _buildPokemonNodes(
    List<UserPokemon> pokemonTeam,
    BuildContext context,
  ) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        pokemonTeam.length,
        (index) => Padding(
          padding: const EdgeInsets.only(
            top: Sizing.listItemVerticalSpacing * .5,
            bottom: Sizing.listItemVerticalSpacing * .5,
          ),
          child: PokemonNode.small(
            pokemon: pokemonTeam[index],
            context: context,
            dropdowns: false,
            lead: ((pokemonTeam[index].teamIndex ?? -1) == 0),
          ),
        ),
      ),
    );
  }

  // Build a list of counters to the logged opponent teams
  Future<Widget> _buildCountersList(
      List<Pair<PokemonType, double>> defenseThreats) async {
    final counterTypes = defenseThreats.map((typeData) => typeData.a).toList();

    List<CupPokemon> counters = PogoRepository.getCupPokemon(
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
        padding: Sizing.horizontalWindowInsets(context),
        child: ListView(
          children: [
            // Spacer
            SizedBox(
              height: Sizing.screenHeight(context) * .01,
            ),

            // Opponent team
            _buildPokemonNodes(pokemonTeam, context),

            // Spacer
            SizedBox(
              height: Sizing.screenHeight(context) * .02,
            ),

            // Spacer
            SizedBox(
              height: Sizing.screenHeight(context) * .02,
            ),

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
