// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/pokemon/pokemon.dart';
import '../widgets/exit_button.dart';
import '../widgets/pokemon_button.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
A list of Pokemon are displayed here, which will filter based on text input.
Every Pokemon node displayed can be tapped, from which that Pokemon reference
will be returned via the Navigator.pop.
-------------------------------------------------------------------------------
*/

class PokemonSearch extends StatefulWidget {
  const PokemonSearch({Key? key}) : super(key: key);

  @override
  _PokemonSearchState createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  // Search bar text input controller
  final TextEditingController searchController = TextEditingController();

  // List of ALL Pokemon
  final List<Pokemon> pokemon = globals.gamemaster.pokemon;

  // A variable list of Pokemon based on search bar text input
  List<Pokemon> filteredPokemon = [];

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    searchController.addListener(_filterPokemonList);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    searchController.dispose();
    super.dispose();
  }

  // Generate a filtered list of Pokemon based off of the search bar user input
  void _filterPokemonList() {
    // Get the lowercase user input
    final String input = searchController.text.toLowerCase();

    setState(() {
      // Build a list of Pokemon button widgets based off of the input
      filteredPokemon = pokemon
          .where((pkm) => pkm.speciesName.toLowerCase().contains(input))
          .toList();
    });
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
      body: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 7,
          right: SizeConfig.screenWidth * .025,
          left: SizeConfig.screenWidth * .025,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User text input field
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search for a Pokemon',
              ),
              textAlign: TextAlign.center,
              controller: searchController,
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
                    return PokemonButton(
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
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
