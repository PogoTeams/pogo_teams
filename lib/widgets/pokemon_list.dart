// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../model/pokemon.dart';
import '../model/pokemon_base.dart';
import 'nodes/pokemon_node.dart';
import '../app/ui/sizing.dart';
import '../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A list of Pokemon Buttons that also have dropdowns for each of their moves in
a given moveset. On tapping one of the buttons, a callback will be invoked,
passing the Pokemon in question back to the calling routine.
-------------------------------------------------------------------------------
*/

class PokemonList extends StatelessWidget {
  const PokemonList({
    super.key,
    required this.pokemon,
    required this.onPokemonSelected,
    this.dropdowns = true,
    this.rankingsCategory,
  });

  final List<CupPokemon> pokemon;
  final Function(CupPokemon) onPokemonSelected;
  final bool dropdowns;
  final RankingsCategories? rankingsCategory;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Remove the upper silver padding that ListView contains by
      // default in a Scaffold.
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeLeft: true,
        removeRight: true,

        // List building
        child: ListView.builder(
            itemCount: pokemon.length,
            itemBuilder: (context, index) {
              return MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  onPokemonSelected(pokemon[index]);
                },
                onLongPress: () {},
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: Sizing.listItemVerticalSpacing,
                  ),
                  child: PokemonNode.small(
                    context: context,
                    pokemon: pokemon[index],
                    dropdowns: dropdowns,
                    rating: rankingsCategory == null ? null : '#${index + 1}',
                  ),
                ),
              );
            },
            physics: const BouncingScrollPhysics()),
      ),
    );
  }
}

class PokemonColumn extends StatelessWidget {
  const PokemonColumn({
    super.key,
    required this.pokemon,
    required this.onPokemonSelected,
    this.dropdowns = true,
  });

  final List<CupPokemon> pokemon;
  final Function(PokemonBase) onPokemonSelected;
  final bool dropdowns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: pokemon
          .map(
            (pokemon) => Padding(
              padding:
                  EdgeInsets.only(bottom: Sizing.screenWidth(context) * .2),
              child: PokemonNode.small(
                context: context,
                pokemon: pokemon,
                dropdowns: dropdowns,
              ),
            ),
          )
          .toList(),
    );
  }
}
