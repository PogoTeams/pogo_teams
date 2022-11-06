// Flutter Imports
import 'package:flutter/material.dart';
import 'package:pogo_teams/modules/data/pogo_data.dart';

// Local Imports
import '../../modules/data/gamemaster.dart';
import '../../modules/ui/sizing.dart';
import '../../game_objects/pokemon.dart';
import '../../game_objects/cup.dart';
import '../../game_objects/pokemon_team.dart';
import '../../widgets/pokemon_list.dart';
import '../../widgets/buttons/exit_button.dart';
import '../../widgets/pogo_text_field.dart';
import '../../widgets/dropdowns/cup_dropdown.dart';
import '../../widgets/dropdowns/team_size_dropdown.dart';
import '../../widgets/dropdowns/win_loss_dropdown.dart';
import '../../widgets/buttons/filter_button.dart';
import '../../widgets/nodes/team_node.dart';
import '../../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A search and build page, where the team being edited is rendered as a grid
above a searchable / filterable list of Pokemon. The user can press on any
node in the grid to put focus on that node for adding a Pokemon. 
-------------------------------------------------------------------------------
*/

class TeamBuilder extends StatefulWidget {
  const TeamBuilder({
    Key? key,
    required this.team,
    required this.cup,
    required this.focusIndex,
  }) : super(key: key);

  final PokemonTeam team;
  final Cup cup;
  final int focusIndex;

  @override
  _TeamBuilderState createState() => _TeamBuilderState();
}

class _TeamBuilderState extends State<TeamBuilder> {
  late Cup _cup = widget.cup;
  late final PokemonTeam _builderTeam;

  // The current index of the team the user is editing
  int _builderIndex = 0;

  // Search bar text input controller
  final TextEditingController _searchController = TextEditingController();

  // List of ALL Pokemon
  List<Pokemon> _pokemon = [];

  // A variable list of Pokemon based on search bar text input
  List<Pokemon> _filteredPokemon = [];

  RankingsCategories _selectedCategory = RankingsCategories.overall;

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
          isMatch = pokemon.name.toLowerCase().startsWith(terms[i]) ||
              pokemon.typing.containsTypeId(terms[i]);
        }

        return isMatch;
      }

      // Filter by the search terms
      _filteredPokemon = _pokemon.where(filterPokemon).toList();
    });
  }

  // The current team being edited, in a grid view
  Widget _buildTeamNode() {
    return TeamNode(
      onPressed: _updateWorkingIndex,
      onEmptyPressed: _updateWorkingIndex,
      team: _builderTeam,
      cup: _cup,
      focusIndex: _builderIndex,
      emptyTransparent: true,
      footer: Padding(
        padding: EdgeInsets.only(
          bottom: Sizing.blockSizeVertical * 2.0,
        ),
        child: _buildTeamNodeFooter(),
      ),
    );
  }

  Widget _buildTeamNodeFooter() {
    if (_builderTeam.runtimeType == LogPokemonTeam) {
      return WinLossDropdown(
        selectedOption: (_builderTeam as LogPokemonTeam).winLossKey,
        onChanged: (winLossKey) {
          if (winLossKey == null) return;

          setState(() {
            (_builderTeam as LogPokemonTeam).setWinLossKey(winLossKey);
          });
        },
        width: Sizing.screenWidth,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dropdown for pvp cup selection
        CupDropdown(
          cup: _cup,
          onCupChanged: _onCupChanged,
          width: Sizing.screenWidth * .65,
        ),

        // Dropdown to select team size
        TeamSizeDropdown(
          size: _builderTeam.pokemonTeam.length,
          onTeamSizeChanged: _onTeamSizeChanged,
        ),
      ],
    );
  }

  // The list of Pokemon based on categories and search input
  Widget _buildPokemonList() {
    return PokemonList(
      pokemon: _filteredPokemon,
      onPokemonSelected: (pokemon) {
        setState(() {
          _builderTeam.setPokemon(_builderIndex, pokemon);
          _updateWorkingIndex(_builderIndex + 1);
        });
      },
    );
  }

  // Two floating action buttons at the footer of the scaffold
  // One to discard the changes, and another to confirm
  Widget _buildFloatingActionButtons() {
    return SizedBox(
      width: Sizing.screenWidth * .87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancel exit button
          ExitButton(
            key: UniqueKey(),
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: const Color.fromARGB(255, 239, 83, 80),
          ),

          // Confirm exit button
          ExitButton(
            key: UniqueKey(),
            onPressed: () {
              Navigator.pop(context, _builderTeam);
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
    setState(() {
      _builderIndex = (index == _builderTeam.pokemonTeam.length ? 0 : index);
    });
  }

  // When the cup is changed, set the filter the new Pokemon rankings list
  void _onCupChanged(String? newCup) {
    if (newCup == null) return;

    setState(() {
      (_builderTeam as UserPokemonTeam).setCup(newCup);
      _cup = (_builderTeam as UserPokemonTeam).cup;
      _filterCategory(_selectedCategory);
    });
  }

  void _onTeamSizeChanged(int? newSize) {
    if (newSize == null) return;

    setState(() {
      if (_builderIndex > newSize - 1) {
        _builderIndex = newSize - 1;
      }

      (_builderTeam as UserPokemonTeam).setTeamSize(newSize);
    });
  }

  // Callback for the FilterButton
  // Sets the ranking list associated with rankingsCategory
  void _filterCategory(RankingsCategories rankingsCategory) async {
    _selectedCategory = rankingsCategory;

    // Dex is a special case where all Pokemon are in the list
    // Otherwise get the list from the ratings category
    if (RankingsCategories.dex == _selectedCategory) {
      _pokemon = Gamemaster().pokemonList;
    } else {
      _pokemon = await PogoData.getRankedPokemonList(_cup, _selectedCategory);
    }

    _filterPokemonList();
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    // Building a user team
    if (widget.team.runtimeType == UserPokemonTeam) {
      _builderTeam =
          UserPokemonTeam.builderCopy(widget.team as UserPokemonTeam);
    }
    // Building a log team
    else {
      _builderTeam = LogPokemonTeam.builderCopy(widget.team as LogPokemonTeam);
    }

    // Set the starting index of the team edit
    _builderIndex = widget.focusIndex;

    _filterCategory(RankingsCategories.overall);

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
    if (_filteredPokemon.isEmpty && _searchController.text.isEmpty) {
      _filteredPokemon = _pokemon;
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: Sizing.blockSizeHorizontal * 2.0,
            right: Sizing.blockSizeHorizontal * 2.0,
          ),
          child: Column(
            children: [
              _buildTeamNode(),

              // Spacer
              SizedBox(
                height: Sizing.blockSizeVertical * 1.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // User input text field
                  PogoTextField(
                    controller: _searchController,
                    width: Sizing.screenWidth * .8,
                    onClear: () => setState(() {
                      _searchController.clear();
                    }),
                  ),

                  // Filter by ranking category
                  FilterButton(
                    onSelected: _filterCategory,
                    selectedCategory: _selectedCategory,
                    size: Sizing.blockSizeHorizontal * 12.0,
                    dex: true,
                  ),
                ],
              ),

              // Spacer
              SizedBox(
                height: Sizing.blockSizeVertical * 1.0,
              ),

              _buildPokemonList(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
