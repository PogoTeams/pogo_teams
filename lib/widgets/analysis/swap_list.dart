// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Local Imports
import '../../data/pokemon/typing.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/cup.dart';
import '../nodes/pokemon_node.dart';
import '../../configs/size_config.dart';
import '../buttons/pokemon_action_button.dart';
import '../../pages/team_swap.dart';

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
    required this.onTeamChanged,
  }) : super(key: key);

  final PokemonTeam team;
  final List<Type> types;
  final Function(List<Pokemon>) onTeamChanged;

  // Either 1 or 2 footer buttons will display for a Pokemon's node.
  // If there is free space in the Pokemon team, render add and swap buttons.
  // Otherwise only render the swap button.
  Widget _buildFooter(BuildContext context, Pokemon pokemon) {
    // Callback for action buttons
    void _onTeamChanged(Pokemon pokemon) async {
      List<Pokemon>? newTeam = await Navigator.push(
        context,
        MaterialPageRoute<List<Pokemon>>(
          builder: (BuildContext context) {
            return TeamSwap(
              team: team,
              swap: pokemon,
            );
          },
        ),
      );

      if (newTeam != null) {
        onTeamChanged(newTeam);
      }
    }

    if (team.hasSpace()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PokemonActionButton(
            width: SizeConfig.screenWidth * .35,
            pokemon: pokemon,
            label: 'Add To Team',
            icon: Icon(
              Icons.add,
              size: SizeConfig.blockSizeHorizontal * 5.0,
              color: Colors.white,
            ),
            onPressed: (pokemon) {
              team.addPokemon(pokemon);
              onTeamChanged(team.getPokemonTeam());
            },
          ),
          PokemonActionButton(
            width: SizeConfig.screenWidth * .35,
            pokemon: pokemon,
            label: 'Team Swap',
            icon: Icon(
              Icons.swap_horiz_rounded,
              size: SizeConfig.blockSizeHorizontal * 5.0,
              color: Colors.white,
            ),
            onPressed: _onTeamChanged,
          ),
        ],
      );
    }

    return PokemonActionButton(
      pokemon: pokemon,
      label: 'Team Swap',
      icon: Icon(
        Icons.swap_horiz_rounded,
        size: SizeConfig.blockSizeHorizontal * 5.0,
        color: Colors.white,
      ),
      onPressed: _onTeamChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Pokemon> counters =
        team.cup.getFilteredRankedPokemonList(types, 'overall', limit: 20);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: counters.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * .5,
          bottom: SizeConfig.blockSizeVertical * .5,
        ),
        child: PokemonNode.large(
          pokemon: counters[index],
          footer: _buildFooter(context, counters[index]),
        ),
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

class LogSwapList extends StatelessWidget {
  const LogSwapList({
    Key? key,
    required this.cup,
    required this.types,
    required this.onTeamChanged,
  }) : super(key: key);

  final Cup cup;
  final List<Type> types;
  final Function(List<Pokemon>) onTeamChanged;

  @override
  Widget build(BuildContext context) {
    List<Pokemon> counters =
        cup.getFilteredRankedPokemonList(types, 'overall', limit: 20);

    return Column(
      children: counters
          .map(
            (pokemon) => Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.blockSizeHorizontal * 2.0,
              ),
              child: PokemonNode.small(
                pokemon: pokemon,
              ),
            ),
          )
          .toList(),
    );
  }
}
