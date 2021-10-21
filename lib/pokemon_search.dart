import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'pogo_data.dart';
import 'globals.dart' as globals;

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

  // List of ALL Moves
  final List<Move> moves = globals.gamemaster.moves;

  // A variable list of Pokemon based on search bar text input
  List<Pokemon> filteredPokemon = [];

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    searchController.addListener(_filterPokemonList);
  }

  /*
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }
  */

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search for a Pokemon',
              ),
              textAlign: TextAlign.center,
              controller: searchController,
            ),
            const Divider(
              height: 20,
              thickness: 3.0,
              indent: 20,
              endIndent: 20,
            ),
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
    );
  }
}

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
      onPressed: onPressed,
      onLongPress: onLongPress,
      child: RichText(
          text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: pokemon.speciesName,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
    );
  }
}
