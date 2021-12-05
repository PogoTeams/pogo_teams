// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../data/pokemon/pokemon.dart';
import '../widgets/buttons/compact_pokemon_node_button.dart';

/*
-------------------------------------------------------------------------------
A list of Pokemon Buttons that also have dropdowns for each of their moves in
a given moveset. On tapping one of the buttons, a callback will be invoked,
passing the Pokemon in question back to the calling routine.
-------------------------------------------------------------------------------
*/

class PokemonList extends StatelessWidget {
  const PokemonList({
    Key? key,
    required this.pokemon,
    required this.onPokemonSelected,
  }) : super(key: key);

  final List<Pokemon> pokemon;
  final Function(Pokemon) onPokemonSelected;

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
            return CompactPokemonNodeButton(
              pokemon: pokemon[index],
              onPressed: () {
                onPokemonSelected(pokemon[index]);
              },
              onLongPress: () {},
            );
          },
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}