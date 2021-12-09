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
import '../widgets/pokemon_list.dart';
import '../widgets/buttons/exit_button.dart';
import '../widgets/pogo_text_field.dart';
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

  // Generate a filtered list of Pokemon based off of the text field input.
  // List can filter by Pokemon name (speciesName) and types.
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

  // Build the scaffold for this page
  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PogoTextField(controller: _searchController),

              // Horizontal divider
              Divider(
                height: SizeConfig.blockSizeVertical * 5.0,
                thickness: SizeConfig.blockSizeHorizontal * 1.0,
                indent: SizeConfig.blockSizeHorizontal * 5.0,
                endIndent: SizeConfig.blockSizeHorizontal * 5.0,
              ),

              // The list of Pokemon based on categories and search input
              PokemonList(
                pokemon: filteredPokemon,
                onPokemonSelected: (pokemon) {
                  Navigator.pop(
                    context,
                    Pokemon.from(pokemon),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // Exit to Team Builder button
      floatingActionButton: _buildFloatingActionButtons(context),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 25),
          width: SizeConfig.blockSizeHorizontal * 80,
          child: ExitButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 20,
          child: FilterButton(
            onSelected: _filterCategory,
            selectedCategory: _selectedCategory,
          ),
        ),
      ],
    );
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

    return _buildScaffold(context);
  }
}
