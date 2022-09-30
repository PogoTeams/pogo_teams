// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import '../../pogo_data/pokemon_typing.dart';
import '../../pogo_data/pokemon.dart';
import '../../pogo_data/cup.dart';
import '../nodes/pokemon_node.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/data/gamemaster.dart';

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
  final List<PokemonType> types;

  @override
  Widget build(BuildContext context) {
    List<Pokemon> counters = Gamemaster.getFilteredRankedPokemonList(
      cup,
      types,
      'overall',
      limit: 50,
    );

    return Column(
      children: counters
          .map(
            (pokemon) => Padding(
              padding: EdgeInsets.only(
                bottom: Sizing.blockSizeHorizontal * 2.0,
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
