// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../widgets/analysis/type_coverage.dart';
import '../../widgets/pokemon_list.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../game_objects/pokemon.dart';
import '../../game_objects/pokemon_typing.dart';
import '../../game_objects/pokemon_team.dart';
import '../../modules/data/pogo_data.dart';
import '../../modules/ui/sizing.dart';
import '../../tools/pair.dart';

/*
-------------------------------------------------------------------- @PogoTeams
An analysis page for a single opponent team. Changes can be made to the user's
team as well, via the swap feature.
-------------------------------------------------------------------------------
*/

class OpponentTeamAnalysis extends StatelessWidget {
  const OpponentTeamAnalysis({
    Key? key,
    required this.team,
    required this.pokemonTeam,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.netEffectiveness,
  }) : super(key: key);

  final UserPokemonTeam team;
  final List<Pokemon> pokemonTeam;
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
            'Opponent Team Analysis',
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

  // Build the list of either 3 or 6 PokemonNodes that make up this team
  Widget _buildPokemonNodes(List<Pokemon> pokemonTeam) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        pokemonTeam.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            top: Sizing.blockSizeVertical * .5,
            bottom: Sizing.blockSizeVertical * .5,
          ),
          child: PokemonNode.small(
            pokemon: pokemonTeam[index],
            dropdowns: false,
          ),
        ),
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  // Build a list of counters to the logged opponent teams
  Future<Widget> _buildCountersList(
      List<Pair<PokemonType, double>> defenseThreats) async {
    final counterTypes = defenseThreats.map((typeData) => typeData.a).toList();

    List<Pokemon> counters = await PogoData.getFilteredRankedPokemonList(
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
          left: Sizing.blockSizeHorizontal * 2.0,
          right: Sizing.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            // Spacer
            SizedBox(
              height: Sizing.blockSizeVertical * 1.0,
            ),

            // Opponent team
            _buildPokemonNodes(pokemonTeam),

            // Spacer
            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

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
            //_buildCountersList(defenseThreats),
          ],
        ),
      ),
    );
  }
}
