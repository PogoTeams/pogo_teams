// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../data/pokemon/pokemon.dart';
import 'nodes/pokemon_node.dart';
import '../configs/size_config.dart';

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
    this.dropdowns = true,
    this.rating = false,
  }) : super(key: key);

  final List<Pokemon> pokemon;
  final Function(Pokemon) onPokemonSelected;
  final bool dropdowns;
  final bool rating;

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
                  padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * .5,
                    bottom: SizeConfig.blockSizeVertical * .5,
                  ),
                  child: PokemonNode.small(
                    pokemon: pokemon[index],
                    dropdowns: dropdowns,
                    rating: rating,
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
    Key? key,
    required this.pokemon,
    required this.onPokemonSelected,
    this.dropdowns = true,
  }) : super(key: key);

  final List<Pokemon> pokemon;
  final Function(Pokemon) onPokemonSelected;
  final bool dropdowns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: pokemon
          .map(
            (pokemon) => Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.blockSizeHorizontal * 2.0,
              ),
              child: PokemonNode.small(
                pokemon: pokemon,
                dropdowns: dropdowns,
              ),
            ),
          )
          .toList(),
    );
  }
}
