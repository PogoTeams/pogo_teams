// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local Imports
import '../../model/pokemon_team.dart';
import '../../model/pokemon.dart';
import '../../model/pokemon_typing.dart';
import '../nodes/pokemon_node.dart';
import '../../app/ui/sizing.dart';
import '../../modules/pogo_repository.dart';
import '../buttons/pokemon_action_button.dart';
import '../../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Generate a list of the top 20 Pokemon that have one of the specified types.
Each Pokemon will be displayed as a node with a footer widget, which allowing
the user to swap this Pokemon with another in their team.
-------------------------------------------------------------------------------
*/

class SwapList extends StatelessWidget {
  const SwapList({
    super.key,
    required this.onSwap,
    required this.onAdd,
    required this.team,
    required this.types,
  });

  final Function(Pokemon) onSwap;
  final Function(Pokemon) onAdd;
  final UserPokemonTeam team;
  final List<PokemonType> types;

  // Either 1 or 2 footer buttons will display for a Pokemon's node.
  // If there is free space in the Pokemon team, render add and swap buttons.
  // Otherwise only render the swap button.
  Widget _buildFooter(BuildContext context, CupPokemon pokemon) {
    if (team.hasSpace()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PokemonActionButton(
            width: Sizing.screenWidth(context) * .35,
            pokemon: pokemon,
            label: 'Add To Team',
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: onAdd,
          ),
          PokemonActionButton(
            width: Sizing.screenWidth(context) * .35,
            pokemon: pokemon,
            label: 'Team Swap',
            icon: const Icon(
              Icons.swap_horiz_rounded,
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
      icon: const Icon(
        Icons.swap_horiz_rounded,
        color: Colors.white,
      ),
      onPressed: onSwap,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CupPokemon> pokemon = context.read<PogoRepository>().getCupPokemon(
          team.cup,
          types,
          RankingsCategories.overall,
          limit: 20,
        );
    return ListView.builder(
      shrinkWrap: true,
      itemCount: pokemon.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(
          top: Sizing.screenHeight(context) * .005,
          bottom: Sizing.screenHeight(context) * .005,
        ),
        child: PokemonNode.large(
          pokemon: pokemon[index],
          context: context,
          footer: _buildFooter(
            context,
            pokemon[index],
          ),
        ),
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
