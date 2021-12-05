// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/pokemon/pokemon.dart';
import '../data/cup.dart';
import '../widgets/pokemon_search_list.dart';
import '../widgets/buttons/exit_button.dart';
import '../widgets/pogo_text_field.dart';
import '../widgets/teams_list.dart';
import '../widgets/buttons/filter_button.dart';
import '../data/pokemon/pokemon_team.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class TeamBuilderSearch extends StatefulWidget {
  const TeamBuilderSearch({
    Key? key,
    required this.cup,
    this.team,
  }) : super(key: key);

  final Cup cup;
  final List<Pokemon?>? team;

  @override
  _TeamBuilderSearchState createState() => _TeamBuilderSearchState();
}

class _TeamBuilderSearchState extends State<TeamBuilderSearch> {
  // The current index of the team the user is editing
  int _workingIndex = 0;
  late final List<Pokemon?> _team;

  // Search bar text input controller
  final TextEditingController _searchController = TextEditingController();

  // List of ALL Pokemon
  List<Pokemon> pokemon = [];

  // A variable list of Pokemon based on search bar text input
  List<Pokemon> filteredPokemon = [];

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
              TeamBuilderList(team: _team),

              // Spacer
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2.0,
              ),

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
                  setState(() {
                    _team[_workingIndex] = pokemon;
                    _updateWorkingIndex(_workingIndex + 1);
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: SizeConfig.screenWidth * .87,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel exit button
            ExitButton(
              key: UniqueKey(),
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.red[400]!,
            ),

            // Confirm exit button
            ExitButton(
              key: UniqueKey(),
              onPressed: () {
                Navigator.pop(context, _team);
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Update the working index, will be set via a callback or
  // when a user selects a Pokemon for the team, moving the working index
  // in a round-robin fashion.
  void _updateWorkingIndex(int index) {
    _workingIndex = (index == 3 ? 0 : index);
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    if (widget.team == null) {
      _team = List.generate(3, (index) => null);
    } else {
      _team = widget.team!;
    }

    // Get the selected cup and list of Pokemon based on the category
    pokemon = widget.cup.getRankedPokemonList('overall');

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

class TeamBuilderList extends StatefulWidget {
  const TeamBuilderList({
    Key? key,
    required this.team,
  }) : super(key: key);

  final List<Pokemon?> team;

  @override
  _TeamBuilderListState createState() => _TeamBuilderListState();
}

class _TeamBuilderListState extends State<TeamBuilderList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.team
          .map((pokemon) => SquareTeamNode(pokemon: pokemon))
          .toList(),
    );
  }
}
