// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import '../../data/pokemon/typing.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/cup.dart';
import '../nodes/pokemon_node.dart';
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A list of Pokemon that are filtered by a specified subset of types.
-------------------------------------------------------------------------------
*/

class TypeFilteredPokemonList extends StatelessWidget {
  const TypeFilteredPokemonList({
    Key? key,
    required this.cup,
    required this.types,
  }) : super(key: key);

  final Cup cup;
  final List<Type> types;

  @override
  Widget build(BuildContext context) {
    List<Pokemon> counters =
        cup.getFilteredRankedPokemonList(types, 'overall', limit: 50);

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
