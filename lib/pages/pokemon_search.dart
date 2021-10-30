import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import '../configs/size_config.dart';
import '../data/pogo_data.dart';
import '../buttons/exit_button.dart';
import '../data/globals.dart' as globals;

class PokemonSearch extends StatefulWidget {
  const PokemonSearch({Key? key, required this.title}) : super(key: key);

  final String title;

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
          mainAxisAlignment: MainAxisAlignment.start,
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
            // rendered as a PokemonBarButton.
            Expanded(
              child: ListView.builder(
                itemCount: filteredPokemon.length,
                itemBuilder: (context, index) {
                  return PokemonBarButton(
                      onPressed: () {
                        Navigator.pop(context, filteredPokemon[index]);
                      },
                      onLongPress: () {},
                      pokemon: filteredPokemon[index]);
                },
                physics: const BouncingScrollPhysics(),
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

// A simple button displaying a Pokemon's species name
// The current filtered search list will render this widget for each Pokemon
class PokemonBarButton extends StatelessWidget {
  const PokemonBarButton({
    Key? key,
    required this.onPressed,
    required this.onLongPress,
    required this.pokemon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            return pokemon.typeColor;
          },
        ),
      ),

      // Callbacks
      onPressed: onPressed,
      onLongPress: onLongPress,

      // Pokemon name
      child: Text(
        pokemon.speciesName,
        style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 4.3,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
