// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local Imports
import '../../model/pokemon_typing.dart';
import '../../model/pokemon.dart';
import '../../model/cup.dart';
import '../nodes/pokemon_node.dart';
import '../../app/ui/sizing.dart';
import '../../modules/pogo_repository.dart';
import '../../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A list of Pokemon that are filtered by a specified subset of types.
-------------------------------------------------------------------------------
*/

class TypeFilteredPokemonList extends StatelessWidget {
  const TypeFilteredPokemonList({
    super.key,
    required this.cup,
    required this.types,
  });

  final Cup cup;
  final List<PokemonType> types;

  @override
  Widget build(BuildContext context) {
    List<CupPokemon> pokemon = context.read<PogoRepository>().getCupPokemon(
          cup,
          types,
          RankingsCategories.overall,
          limit: 20,
        );
    return Column(
      children: pokemon
          .map(
            (pokemon) => Padding(
              padding: EdgeInsets.only(
                bottom: Sizing.screenWidth(context) * .02,
              ),
              child: PokemonNode.small(
                pokemon: pokemon,
                context: context,
              ),
            ),
          )
          .toList(),
    );
  }
}
