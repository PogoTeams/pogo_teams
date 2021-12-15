// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Local Imports
import '../../widgets/analysis/type_coverage.dart';
import '../../widgets/pokemon_list.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/typing.dart';
import '../../configs/size_config.dart';
import '../../tools/pair.dart';

/*
-------------------------------------------------------------------------------
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
            'Opponent Team Analysis',
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

  // Build the list of either 3 or 6 PokemonNodes that make up this team
  Widget _buildPokemonNodes(List<Pokemon> pokemonTeam) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        pokemonTeam.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * .5,
            bottom: SizeConfig.blockSizeVertical * .5,
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
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 1.0,
            ),

            // Opponent team
            _buildPokemonNodes(pokemonTeam),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),

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
