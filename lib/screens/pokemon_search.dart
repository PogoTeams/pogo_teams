// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/pokemon/pokemon.dart';
import '../data/cup.dart';
import '../widgets/buttons/exit_button.dart';
import '../widgets/buttons/compact_pokemon_node_button.dart';
import '../widgets/buttons/filter_button.dart';
import '../data/pokemon/pokemon_team.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
A list of Pokemon are displayed here, which will filter based on text input.
Every Pokemon node displayed can be tapped, from which that Pokemon reference
will be returned via the Navigator.pop.
-------------------------------------------------------------------------------
*/

class PokemonSearch extends StatefulWidget {
  const PokemonSearch({
    Key? key,
    required this.team,
  }) : super(key: key);

  final PokemonTeam team;

  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  late final Cup cup;

  // Search bar text input controller
  final TextEditingController _searchController = TextEditingController();

  // List of ALL Pokemon
  List<Pokemon> pokemon = [];

  // A variable list of Pokemon based on search bar text input
  List<Pokemon> filteredPokemon = [];

  String _selectedCategory = 'overall';

  // Callback for the FilterButton
  // Sets the ranking list associated with rankingsCategory
  void _filterCategory(dynamic rankingsCategory) {
    _selectedCategory = rankingsCategory;

    // Dex is a special case where all Pokemon are in the list
    // Otherwise get the list from the ratings category
    if ('dex' == _selectedCategory) {
      pokemon = globals.gamemaster.pokemon;
    } else {
      pokemon = cup.getRankedPokemonList(_selectedCategory);
    }

    _filterPokemonList();
  }

  // Generate a filtered list of Pokemon based off of the search bar user input
  // Can filter by Pokemon name and types
  void _filterPokemonList() {
    // Get the lowercase user input
    final String input = _searchController.text.toLowerCase();

    setState(() {
      // Split any comma seperated list into individual search terms
      final List<String> terms = input.split(', ');
      final int termsLen = terms.length;

      // Callback to filter Pokemon by the search terms
      bool filterPokemon(Pokemon pokemon) {
        bool isMatch = false;

        for (int i = 0; i < termsLen && !isMatch; ++i) {
          isMatch = pokemon.speciesName.toLowerCase().startsWith(terms[i]) ||
              pokemon.typing.containsKey(terms[i]);
        }

        return isMatch;
      }

      // Filter by the search terms
      filteredPokemon = pokemon.where(filterPokemon).toList();
    });
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    // Get the selected cup and list of Pokemon based on the category
    cup = widget.team.cup;
    pokemon = cup.getRankedPokemonList(_selectedCategory);

    // Start listening to changes.
    _searchController.addListener(_filterPokemonList);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Display all Pokemon if there is no input
    if (filteredPokemon.isEmpty && _searchController.text.isEmpty) {
      filteredPokemon = pokemon;
    }

    // Block size from MediaQuery
    final double blockSize = SizeConfig.blockSizeHorizontal;
    final double verticalBlockSize = SizeConfig.blockSizeVertical;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User text input field
              SizedBox(
                width: SizeConfig.screenWidth * 0.9,
                child: TextField(
                  keyboardAppearance: Brightness.dark,
                  toolbarOptions: const ToolbarOptions(
                    copy: true,
                    cut: true,
                    paste: true,
                    selectAll: true,
                  ),
                  cursorColor: Colors.greenAccent,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent)),
                    labelText: 'Search for a Pokemon',
                    labelStyle: TextStyle(color: Colors.greenAccent),
                  ),
                  textAlign: TextAlign.center,
                  controller: _searchController,
                ),
              ),

              // Horizontal divider
              Divider(
                height: verticalBlockSize * 5.0,
                thickness: blockSize * 1.0,
                indent: blockSize * 5.0,
                endIndent: blockSize * 5.0,
              ),

              // The list of Pokemon by species name
              // rendered as a PokemonButton.
              Expanded(
                // Remove the upper silver padding that ListView contains by
                // default in a Scaffold.
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: filteredPokemon.length,
                    itemBuilder: (context, index) {
                      return CompactPokemonNodeButton(
                        pokemon: filteredPokemon[index],
                        onPressed: () {
                          Navigator.pop(
                            context,
                            Pokemon.from(filteredPokemon[index]),
                          );
                        },
                        onLongPress: () {},
                      );
                    },
                    physics: const BouncingScrollPhysics(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Exit to Team Builder button
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: blockSize * 25),
            width: blockSize * 80,
            child: ExitButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            width: blockSize * 20,
            child: FilterButton(
              onSelected: _filterCategory,
              selectedCategory: _selectedCategory,
            ),
          ),
        ],
      ),
    );
  }
}
