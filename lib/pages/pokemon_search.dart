import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo_teams/widgets/node_decoration.dart';
import '../configs/size_config.dart';
import '../data/pokemon.dart';
import '../widgets/exit_button.dart';
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
            // rendered as a PokemonBarButton.
            Expanded(
              // Remove the upper silver padding that ListView contains by
              // default in a Scaffold.
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  itemCount: filteredPokemon.length,
                  itemBuilder: (context, index) {
                    return PokemonBarButton(
                      pokemon: filteredPokemon[index],
                      onPressed: () {
                        Navigator.pop(context, filteredPokemon[index]);
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

// A simple button displaying a Pokemon's species name
// The current filtered search list will render this widget for each Pokemon
class PokemonBarButton extends StatelessWidget {
  const PokemonBarButton({
    Key? key,
    required this.pokemon,
    required this.onPressed,
    required this.onLongPress,
  }) : super(key: key);

  final Pokemon pokemon;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // Callbacks
      onPressed: onPressed,
      onLongPress: onLongPress,

      // Pokemon name
      child: Container(
        width: double.infinity,
        height: SizeConfig.blockSizeVertical * 4.5,
        decoration: buildDecoration(pokemon),
        child: Center(
          child: Text(
            pokemon.speciesName,
            style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal * 4.3,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
    /*
    return Container(
      decoration: buildDecoration(
        pokemon,
        /*
        borderRadius: 0.0,
        border: Border.all(
          color: Colors.white,
          width: SizeConfig.blockSizeHorizontal * .8,
        ),
        */
      ),
      child: TextButton(
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
      ),
    );
    */
  }
}
