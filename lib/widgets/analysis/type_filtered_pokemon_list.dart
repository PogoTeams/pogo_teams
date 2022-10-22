// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../game_objects/pokemon_typing.dart';
import '../../game_objects/pokemon.dart';
import '../../game_objects/cup.dart';
import '../nodes/pokemon_node.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/data/pogo_data.dart';
import '../../enums/pokemon_filters.dart';

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
        future: PogoData.getFilteredRankedPokemonList(
          cup,
          types,
          PokemonFilters.overall,
          limit: 50,
        ),
        builder: (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
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
