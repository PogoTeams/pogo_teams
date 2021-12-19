// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../data/pokemon/typing.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/pokemon.dart';
import '../nodes/pokemon_node.dart';
import '../../configs/size_config.dart';
import '../buttons/pokemon_action_button.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Generate a list of the top 20 Pokemon that have one of the specified types.
Each Pokemon will be displayed as a node with a footer widget, which allowing
the user to swap this Pokemon with another in their team.
-------------------------------------------------------------------------------
*/

class SwapList extends StatelessWidget {
  const SwapList({
    Key? key,
    required this.onSwap,
    required this.onAdd,
    required this.team,
    required this.types,
  }) : super(key: key);

  final Function(Pokemon) onSwap;
  final Function(Pokemon) onAdd;
  final UserPokemonTeam team;
  final List<Type> types;

  // Either 1 or 2 footer buttons will display for a Pokemon's node.
  // If there is free space in the Pokemon team, render add and swap buttons.
  // Otherwise only render the swap button.
  Widget _buildFooter(BuildContext context, Pokemon pokemon) {
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
            onPressed: onAdd,
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
            onPressed: onSwap,
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
      onPressed: onSwap,
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
