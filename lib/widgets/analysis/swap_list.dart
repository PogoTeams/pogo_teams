// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../pogo_objects/pokemon_team.dart';
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/pokemon_typing.dart';
import '../nodes/pokemon_node.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/data/pogo_repository.dart';
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
    Key? key,
    required this.onSwap,
    required this.onAdd,
    required this.team,
    required this.types,
  }) : super(key: key);

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
            width: Sizing.screenWidth * .35,
            pokemon: pokemon,
            label: 'Add To Team',
            icon: Icon(
              Icons.add,
              size: Sizing.blockSizeHorizontal * 5.0,
              color: Colors.white,
            ),
            onPressed: onAdd,
          ),
          PokemonActionButton(
            width: Sizing.screenWidth * .35,
            pokemon: pokemon,
            label: 'Team Swap',
            icon: Icon(
              Icons.swap_horiz_rounded,
              size: Sizing.blockSizeHorizontal * 5.0,
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
        size: Sizing.blockSizeHorizontal * 5.0,
        color: Colors.white,
      ),
      onPressed: onSwap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: PogoRepository.getCupPokemon(
          team.getCup(),
          types,
          RankingsCategories.overall,
          limit: 20,
        ),
        builder:
            (BuildContext context, AsyncSnapshot<List<CupPokemon>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  top: Sizing.blockSizeVertical * .5,
                  bottom: Sizing.blockSizeVertical * .5,
                ),
                child: PokemonNode.large(
                  pokemon: snapshot.data![index],
                  footer: _buildFooter(
                    context,
                    snapshot.data![index],
                  ),
                ),
              ),
              physics: const NeverScrollableScrollPhysics(),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
