// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../data/pokemon/pokemon_team.dart';
import '../data/pokemon/pokemon.dart';
import '../widgets/nodes/pokemon_nodes.dart';
import '../widgets/buttons/exit_button.dart';
import '../configs/size_config.dart';
import '../widgets/analysis_visuals/team_coverage.dart';

/*
-------------------------------------------------------------------------------
Based on the PokemonTeam provided, various analysis will be displayed to the
user. The user will also be able to make adjustments to the team, and see
realtime analysis updates.
-------------------------------------------------------------------------------
*/

class TeamAnalysis extends StatelessWidget {
  const TeamAnalysis({
    Key? key,
    required this.team,
  }) : super(key: key);

  final PokemonTeam team;

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;
    final List<Pokemon> pokemonTeam = team.getPokemonTeam();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeHorizontal * 3.0,
            left: SizeConfig.blockSizeHorizontal * 3.0,
            right: SizeConfig.blockSizeHorizontal * 3.0,
          ),
          children: [
            // Selected cup
            Container(
              alignment: Alignment.center,
              width: SizeConfig.screenWidth * .95,
              height: SizeConfig.blockSizeVertical * 4.5,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: SizeConfig.blockSizeHorizontal * .4,
                ),
                borderRadius: BorderRadius.circular(100.0),
                color: team.cup.cupColor,
              ),
              child: Text(team.cup.title),
            ),

            // Spacer
            SizedBox(
              height: blockSize * 3.5,
            ),

            // List of the selected Pokemon team and their selected moves
            SizedBox(
              width: SizeConfig.screenWidth * .95,
              child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: pokemonTeam.map((pokemon) {
                    return Padding(
                        padding: EdgeInsets.only(bottom: blockSize * 2.0),
                        child: CompactPokemonNode(pokemon: pokemon));
                  }).toList()),
            ),

            // Spacer
            SizedBox(
              height: blockSize * 1.5,
            ),

            TeamCoverage(team: team),
          ],
        ),
      ),
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
