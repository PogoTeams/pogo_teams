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
import '../widgets/pokemon_team.dart';

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
    required this.role,
  }) : super(key: key);

  final PokemonTeam team;
  final String role;

  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  // The current team info to filter helpful suggestions
  late final List<Pokemon> pokemonTeam;
  late final Cup cup;

  // Search bar text input controller
  final TextEditingController _searchController = TextEditingController();

  // List of ALL Pokemon
  List<Pokemon> pokemon = [];

  // A variable list of Pokemon based on search bar text input
  List<Pokemon> filteredPokemon = [];

  String _selectedCategory = 'overall';

  // The default ranking list will depend on :
  //    - The selected node's role
  //    - The current type weaknesses of the team
  // The most balanced picks will be brought to the top for the user
  void _setDefaultRankingsList(String role) {
    switch (role) {
      case 'lead':
        _selectedCategory = 'leads';
        break;

      case 'mid':
        _selectedCategory = 'overall';
        break;

      case 'closer':
        _selectedCategory = 'closers';
        break;

      default:
        _selectedCategory = 'overall';
        break;
    }

    pokemon = cup.getRankedPokemonList(_selectedCategory);
  }

  // Callback for the FilterButton
  // Sets the ranking list associated with rankingsCategory
  void _filterCategory(dynamic rankingsCategory) {
    _selectedCategory = rankingsCategory;
    pokemon = cup.getRankedPokemonList(_selectedCategory);

    _filterPokemonList();
  }

  // Generate a filtered list of Pokemon based off of the search bar user input
  void _filterPokemonList() {
    // Get the lowercase user input
    final String input = _searchController.text.toLowerCase();

    setState(() {
      // Split any comma seperated list into individual search terms
      final List<String> terms = input.split(', ');

      // Callback to filter Pokemon by the search terms
      bool filterPokemon(Pokemon pokemon) {
        return pokemon.speciesName.toLowerCase().contains(input) ||
            pokemon.typing.containsKey(terms);
      }

      // Filter by the search terms
      filteredPokemon = pokemon.where(filterPokemon).toList();
    });
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    // Get the Pokemon team and cup
    pokemonTeam = widget.team.getPokemonTeam();
    cup = widget.team.cup;

    _setDefaultRankingsList(widget.role);

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
    if (filteredPokemon.isEmpty) {
      filteredPokemon = pokemon;
    }

    // Block size from MediaQuery
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User text input field
            SizedBox(
              width: SizeConfig.screenWidth * 0.9,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search for a Pokemon',
                ),
                textAlign: TextAlign.center,
                controller: _searchController,
              ),
            ),

            // Horizontal divider
            Divider(
              height: blockSize * 5.0,
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
      //floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
