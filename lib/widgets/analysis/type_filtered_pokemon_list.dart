// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../pogo_objects/pokemon_typing.dart';
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/cup.dart';
import '../nodes/pokemon_node.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/data/pogo_data.dart';
import '../../enums/rankings_categories.dart';

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
    return FutureBuilder(
        future: PogoData.getFilteredCupPokemonList(
          cup,
          types,
          RankingsCategories.overall,
          limit: 50,
        ),
        builder:
            (BuildContext context, AsyncSnapshot<List<CupPokemon>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: snapshot.data!
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
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
