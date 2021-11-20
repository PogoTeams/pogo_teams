// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Local Imports
import '../../data/pokemon/typing.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/pokemon.dart';
import '../nodes/pokemon_nodes.dart';
import '../../configs/size_config.dart';
import '../buttons/team_swap_button.dart';
import '../../screens/team_swap.dart';

/*
-------------------------------------------------------------------------------
Generate a list of the top 20 Pokemon that have one of the specified types.
Each Pokemon will be displayed as a node with a footer widget, which allowing
the user to swap this Pokemon with another in their team.
-------------------------------------------------------------------------------
*/

class SwapList extends StatelessWidget {
  const SwapList({
    Key? key,
    required this.team,
    required this.types,
    required this.onTeamSwap,
  }) : super(key: key);

  final PokemonTeam team;
  final List<Type> types;
  final Function(Pokemon) onTeamSwap;

  @override
  Widget build(BuildContext context) {
    List<Pokemon> counters =
        team.cup.getFilteredRankedPokemonList(types, 'overall', limit: 20);

    return Column(
      children: counters
          .map(
            (pokemon) => Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.blockSizeHorizontal * 2.0,
              ),
              child: FooterPokemonNode(
                pokemon: pokemon,
                footerChild: TeamSwapButton(
                  pokemon: pokemon,
                  onTeamSwap: (pokemon) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return TeamSwap(
                            team: team,
                            swap: pokemon,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
