// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pogo_teams/modules/pogo_repository.dart';
import 'package:pogo_teams/widgets/buttons/rankings_category_button.dart';
import 'package:pogo_teams/widgets/pogo_text_field.dart';
import 'package:pogo_teams/widgets/pokemon_list/bloc/pokemon_list_bloc.dart';

// Local Imports
import '../../model/pokemon.dart';
import '../../model/pokemon_base.dart';
import '../nodes/pokemon_node.dart';
import '../../app/ui/sizing.dart';

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
    required this.dropdowns,
    this.showRatings = false,
  });

  final bool dropdowns;
  final bool showRatings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PokemonListBloc>(
      create: (context) =>
          PokemonListBloc(pogoRepository: context.read<PogoRepository>())
            ..add(
              PokemonListLoaded(),
            ),
      child: _PokemonListView(
        dropdowns: dropdowns,
        showRatings: showRatings,
      ),
    );
  }
}

class _PokemonListView extends StatelessWidget {
  const _PokemonListView({
    required this.dropdowns,
    required this.showRatings,
  });

  final bool dropdowns;
  final bool showRatings;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonListBloc, PokemonListState>(
      builder: (context, state) {
        if (state.filteredPokemon == null) return Container();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // User input text field
                Flexible(
                  flex: 6,
                  child: PogoTextField(
                    onChanged: (searchText) {
                      if (searchText != null) {
                        context.read<PokemonListBloc>().add(
                              SearchTextChanged(
                                searchText: searchText,
                              ),
                            );
                      }
                    },
                    controller: TextEditingController(
                      text: state.searchText,
                    )..selection = TextSelection.collapsed(
                        offset: state.searchText.length,
                      ),
                    onClear: () => context.read<PokemonListBloc>().add(
                          const SearchTextChanged(
                            searchText: '',
                          ),
                        ),
                  ),
                ),

                Sizing.paneSpacer,

                // Filter by ranking category
                Flexible(
                  flex: 1,
                  child: RankingsCategoryButton(
                    onSelected: (rankingsCategory) =>
                        context.read<PokemonListBloc>().add(
                              RankingsCategoryChanged(
                                rankingsCategory: rankingsCategory,
                              ),
                            ),
                    selectedCategory: state.rankingsCategory,
                    dex: true,
                  ),
                ),
              ],
            ),

            // Spacer
            SizedBox(
              height: Sizing.screenHeight(context) * .01,
            ),

            Expanded(
              // Remove the upper silver padding that ListView contains by
              // default in a Scaffold.
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeLeft: true,
                removeRight: true,

                // List building
                child: ListView.builder(
                    itemCount: state.filteredPokemon?.length,
                    itemBuilder: (context, index) {
                      return MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        onLongPress: () {},
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: Sizing.screenHeight(context) * .005,
                            bottom: Sizing.screenHeight(context) * .005,
                          ),
                          child: PokemonNode.small(
                            pokemon: state.filteredPokemon![index],
                            context: context,
                            dropdowns: dropdowns,
                            rating: showRatings ? null : '#${index + 1}',
                          ),
                        ),
                      );
                    },
                    physics: const BouncingScrollPhysics()),
              ),
            ),
          ],
        );
      },
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
              padding: EdgeInsets.only(
                bottom: Sizing.screenWidth(context) * .02,
              ),
              child: PokemonNode.small(
                pokemon: pokemon,
                context: context,
                dropdowns: dropdowns,
              ),
            ),
          )
          .toList(),
    );
  }
}
