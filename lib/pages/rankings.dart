// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../app/ui/sizing.dart';
import '../model/pokemon.dart';
import '../model/cup.dart';
import '../widgets/pokemon_list.dart';
import '../widgets/pogo_text_field.dart';
import '../widgets/dropdowns/cup_dropdown.dart';
import '../widgets/buttons/rankings_category_button.dart';
import '../modules/pogo_repository.dart';
import '../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
This screen will display a list of rankings based on selected cup, and
category. These categories and ranking information are all currently used from
The PvPoke model.
-------------------------------------------------------------------------------
*/

class Rankings extends StatefulWidget {
  const Rankings({super.key});

  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<Rankings> {
  late Cup cup;

  // Search bar text input controller
  final TextEditingController _searchController = TextEditingController();

  List<CupPokemon> _pokemon = [];

  // A variable list of Pokemon based on search bar text input
  List<CupPokemon> _filteredPokemon = [];

  RankingsCategories _selectedCategory = RankingsCategories.overall;

  void _onCupChanged(String? newCupId) async {
    if (newCupId == null) return;

    cup = PogoRepository.getCupById(newCupId);

    setState(() {
      _filterCategory(_selectedCategory);
    });
  }

  // Callback for the FilterButton
  // Sets the ranking list associated with rankingsCategory
  void _filterCategory(RankingsCategories rankingsCategory) async {
    _selectedCategory = rankingsCategory;

    _pokemon = cup.getCupPokemonList(rankingsCategory);

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
      bool filterPokemon(CupPokemon pokemon) {
        bool isMatch = false;

        for (int i = 0; i < termsLen && !isMatch; ++i) {
          isMatch = pokemon.getBase().name.toLowerCase().startsWith(terms[i]) ||
              pokemon.getBase().typing.containsTypeId(terms[i]);
        }

        return isMatch;
      }

      // Filter by the search terms
      _filteredPokemon = _pokemon.where(filterPokemon).toList();
    });
  }

  Widget _buildDropdowns() {
    return Padding(
      padding: EdgeInsets.only(
        left: Sizing.screenWidth(context) * .01,
        right: Sizing.screenWidth(context) * .01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dropdown for pvp cup selection
          Flexible(
            flex: 4,
            child: CupDropdown(
              cup: cup,
              onCupChanged: _onCupChanged,
            ),
          ),

          // Category filter dropdown
          Flexible(
            flex: 1,
            child: RankingsCategoryButton(
              onSelected: _filterCategory,
              selectedCategory: _selectedCategory,
            ),
          ),
        ],
      ),
    );
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    cup = PogoRepository.getCupsSync().first;
    _filterCategory(_selectedCategory);

    // Start listening to changes.
    _searchController.addListener(_filterPokemonList);
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Display all Pokemon if there is no input
    if (_filteredPokemon.isEmpty && _searchController.text.isEmpty) {
      _filteredPokemon = _pokemon;
    }

    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.screenHeight(context) * .02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dropdowns for selecting a cup and a category
          _buildDropdowns(),

          // Spacer
          SizedBox(
            height: Sizing.screenHeight(context) * .02,
          ),

          // User text input
          PogoTextField(
            controller: _searchController,
            onClear: () => setState(() {
              _searchController.clear();
            }),
          ),

          // Spacer
          SizedBox(
            height: Sizing.screenHeight(context) * .02,
          ),

          // Build list
          PokemonList(
            pokemon: _filteredPokemon,
            onPokemonSelected: (_) {},
            dropdowns: false,
            rankingsCategory: _selectedCategory,
          ),
        ],
      ),
    );
  }
}
