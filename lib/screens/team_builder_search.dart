// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:provider/provider.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/pokemon/pokemon.dart';
import '../widgets/pokemon_list.dart';
import '../data/pokemon/pokemon_team.dart';
import '../widgets/buttons/exit_button.dart';
import '../widgets/pogo_text_field.dart';
import '../widgets/nodes/team_node.dart';

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class TeamBuilderSearch extends StatefulWidget {
  const TeamBuilderSearch({
    Key? key,
    required this.team,
    required this.teamIndex,
    required this.focusIndex,
  }) : super(key: key);

  final PokemonTeam team;
  final int teamIndex;
  final int focusIndex;

  @override
  _TeamBuilderSearchState createState() => _TeamBuilderSearchState();
}

class _TeamBuilderSearchState extends State<TeamBuilderSearch> {
  late final List<Pokemon?> _oldTeam;

  // The current index of the team the user is editing
  int _workingIndex = 0;

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
              TeamNode(
                onClear: (_) {},
                onEdit: (_) {},
                teamIndex: widget.teamIndex,
                onEmptyPressed: () {},
              ),

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
                    widget.team.setPokemon(_workingIndex, pokemon);
                    _updateWorkingIndex(_workingIndex + 1);
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Two floating action buttons at the footer of the scaffold
  // One to discard the changes, and another to confirm
  Widget _buildFloatingActionButtons() {
    return SizedBox(
      width: SizeConfig.screenWidth * .87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancel exit button
          ExitButton(
            key: UniqueKey(),
            onPressed: () {
              // Restore old team
              widget.team.setTeam(_oldTeam);
              Navigator.pop(context);
            },
            backgroundColor: Colors.red[400]!,
          ),

          // Confirm exit button
          ExitButton(
            key: UniqueKey(),
            onPressed: () {
              Provider.of<PokemonTeams>(context, listen: false).notify();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }

  // Update the working index, will be set via a callback or
  // when a user selects a Pokemon for the team, moving the working index
  // in a round-robin fashion.
  void _updateWorkingIndex(int index) {
    _workingIndex = (index == widget.team.team.length ? 0 : index);
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    _oldTeam = List.from(widget.team.team);

    // Get the selected cup and list of Pokemon based on the category
    pokemon = widget.team.cup.getRankedPokemonList('overall');

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
