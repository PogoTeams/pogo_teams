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
import '../widgets/pogo_text_field.dart';
import '../widgets/dropdowns/cup_dropdown.dart';
import '../widgets/buttons/compact_pokemon_node_button.dart';
import '../widgets/buttons/filter_button.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
This screen will display a list of rankings based on selected cup, and
category. These categories and ranking information are all currently used from
The PvPoke model.
-------------------------------------------------------------------------------
*/

class Rankings extends StatefulWidget {
  const Rankings({
    Key? key,
  }) : super(key: key);

  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<Rankings>
    with SingleTickerProviderStateMixin {
  late Cup cup;

  // Search bar text input controller
  final TextEditingController _searchController = TextEditingController();

  // List of ALL Pokemon
  List<Pokemon> pokemon = [];

  // A variable list of Pokemon based on search bar text input
  List<Pokemon> filteredPokemon = [];

  String _selectedCategory = 'overall';

  // Fade in animation on page startup
  late final AnimationController _animController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _animController,
    curve: Curves.easeIn,
  );

  void _onCupChanged(String? newCup) {
    if (newCup == null) return;

    setState(() {
      cup = globals.gamemaster.cups.firstWhere((cup) => cup.title == newCup);
      _filterCategory(_selectedCategory);
    });
  }

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
      appBar: AppBar(
        title: _buildScaffoldTitle(),
      ),
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Rankings',
          style: TextStyle(
            fontSize: SizeConfig.h2,
            fontStyle: FontStyle.italic,
          ),
        ),

        // Spacer
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 3.0,
        ),

        Icon(
          Icons.bar_chart,
          size: SizeConfig.blockSizeHorizontal * 6.0,
        ),
      ],
    );
  }

  Widget _buildScaffoldBody() {
    // Begin fade in animation
    _animController.forward();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 2.0,
        ),
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDropdowns(),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2.0,
              ),
              PogoTextField(controller: _searchController),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2.0,
              ),
              _buildPokemonList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdowns() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Dropdown for pvp cup selection
        CupDropdown(
          cup: cup,
          onCupChanged: _onCupChanged,
          width: SizeConfig.screenWidth * .7,
        ),

        FilterButton(
          onSelected: _filterCategory,
          selectedCategory: _selectedCategory,
          size: SizeConfig.blockSizeHorizontal * 11.0,
        ),
      ],
    );
  }

  // The list of Pokemon based on categories and search input
  Widget _buildPokemonList() {
    return Expanded(
      // Remove the upper silver padding that ListView contains by
      // default in a Scaffold.
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeLeft: true,
        removeRight: true,

        // Build list
        child: ListView.builder(
          itemCount: filteredPokemon.length,
          itemBuilder: (context, index) {
            return CompactPokemonNodeButton(
              pokemon: filteredPokemon[index],
              onPressed: () {},
              onLongPress: () {},
            );
          },
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    cup = globals.gamemaster.cups[0];
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
