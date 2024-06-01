// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../model/pokemon.dart';
import '../../model/pokemon_team.dart';
import '../../model/cup.dart';
import '../../modules/pogo_repository.dart';
import '../../app/ui/sizing.dart';
import '../../widgets/pokemon_list.dart';
import '../../widgets/pogo_text_field.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/dropdowns/cup_dropdown.dart';
import '../../widgets/dropdowns/team_size_dropdown.dart';
import '../../widgets/dropdowns/win_loss_dropdown.dart';
import '../../widgets/buttons/rankings_category_button.dart';
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
    super.key,
    required this.team,
    required this.cup,
    required this.focusIndex,
    this.onTeamChanged,
  });

  final PokemonTeam team;
  final Cup cup;
  final int focusIndex;
  final Function(int)? onTeamChanged;

  @override
  State<TeamBuilder> createState() => _TeamBuilderState();
}

class _TeamBuilderState extends State<TeamBuilder> {
  late final PokemonTeam _team;
  late Cup _cup = widget.cup;

  // The current index of the team the user is editing
  int _builderIndex = 0;

  // Search bar text input controller
  final TextEditingController _searchController = TextEditingController();

  // List of ALL Pokemon
  List<CupPokemon> _pokemon = [];

  // A variable list of Pokemon based on search bar text input
  List<CupPokemon> _filteredPokemon = [];

  RankingsCategories _selectedCategory = RankingsCategories.overall;

  // Generate a filtered list of Pokemon based off of the text field input.
  // List can filter by Pokemon name (speciesName) and types.
  void _filterPokemonList() {
    // Get the lowercase user input
    final String input = _searchController.text.toLowerCase();

    setState(() {
      // Split any comma seperated list into individual search terms
      final List<String> terms = input.split(', ');

      // Callback to filter Pokemon by the search terms
      bool filterPokemon(CupPokemon pokemon) {
        bool isMatch = false;

        for (String term in terms) {
          isMatch = pokemon.getBase().name.toLowerCase().startsWith(term) ||
              pokemon.getBase().typing.containsTypeId(term) ||
              pokemon.getBase().form.contains(term) ||
              term == 'shadow' && pokemon.getBase().isShadow();
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
      team: _team,
      focusIndex: _builderIndex,
      emptyTransparent: true,
      footer: Padding(
        padding: const EdgeInsets.only(
          bottom: 12.0,
          left: 12.0,
          right: 12.0,
        ),
        child: _buildTeamNodeFooter(),
      ),
    );
  }

  Widget _buildTeamNodeFooter() {
    if (_team.runtimeType == OpponentPokemonTeam) {
      return WinLossDropdown(
        selectedOption: (_team as OpponentPokemonTeam).battleOutcome,
        onChanged: (battleOutcome) {
          if (battleOutcome == null) return;

          setState(() {
            (_team).battleOutcome = battleOutcome;
          });
        },
        width: Sizing.screenWidth(context),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dropdown for pvp cup selection
        Flexible(
          flex: 5,
          child: CupDropdown(
            cup: _cup,
            onCupChanged: _onCupChanged,
          ),
        ),

        Sizing.paneSpacer,

        // Dropdown to select team size
        Flexible(
          flex: 2,
          child: TeamSizeDropdown(
            size: _team.teamSize,
            onTeamSizeChanged: _onTeamSizeChanged,
          ),
        ),
      ],
    );
  }

  // The list of Pokemon based on categories and search input
  Widget _buildPokemonList() {
    return PokemonList(
      pokemon: _filteredPokemon,
      onPokemonSelected: (Pokemon pokemon) {
        UserPokemon userPokemon = UserPokemon.fromPokemon(pokemon);
        _team.setPokemonAt(_builderIndex, userPokemon);
        PogoRepository.putPokemonTeam(_team);
        _updateWorkingIndex(_builderIndex + 1);

        if (widget.onTeamChanged != null) {
          widget.onTeamChanged!(_builderIndex);
        } else {
          setState(() {});
        }
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return GradientButton(
      onPressed: () {
        _saveTeam();
        Navigator.pop(context, _team);
      },
      width: Sizing.screenWidth(context) * .85,
      height: Sizing.screenHeight(context) * .085,
      child: const Icon(
        Icons.clear,
        size: Sizing.icon2,
      ),
    );
  }

  void _saveTeam() {
    _team.setCupById(_cup.cupId);
    PogoRepository.putPokemonTeam(
      _team,
    );
    if (widget.onTeamChanged != null) {
      widget.onTeamChanged!(_builderIndex);
    } else {
      setState(() {});
    }
  }

  // Update the working index, will be set via a callback or
  // when a user selects a Pokemon for the team, moving the working index
  // in a round-robin fashion.
  void _updateWorkingIndex(int index) {
    setState(() {
      _builderIndex = (index == _team.teamSize ? 0 : index);
    });
  }

  // When the cup is changed, set the filter the new Pokemon rankings list
  void _onCupChanged(String? newCup) {
    if (newCup == null) return;

    setState(() {
      _cup = PogoRepository.getCupById(newCup);
      _filterCategory(_selectedCategory);
    });
    if (widget.onTeamChanged != null) widget.onTeamChanged!(_builderIndex);
  }

  void _onTeamSizeChanged(int? newSize) {
    if (newSize == null) return;

    if (_builderIndex > newSize - 1) {
      _builderIndex = newSize - 1;
    }

    _team.setTeamSize(newSize);
    PogoRepository.putPokemonTeam(_team);
    if (widget.onTeamChanged != null) {
      widget.onTeamChanged!(_builderIndex);
    } else {
      setState(() {});
    }
  }

  // Callback for the FilterButton
  // Sets the ranking list associated with rankingsCategory
  void _filterCategory(RankingsCategories rankingsCategory) async {
    _selectedCategory = rankingsCategory;

    _pokemon = _cup.getCupPokemonList(rankingsCategory);

    _filterPokemonList();
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    // Building a user team
    if (widget.team.runtimeType == UserPokemonTeam) {
      _team = widget.team as UserPokemonTeam;
    }
    // Building a log team
    else {
      _team = widget.team as OpponentPokemonTeam;
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
    final isExpanded = Sizing.isExpanded(context);
    //Display all Pokemon if there is no input
    if (_filteredPokemon.isEmpty && _searchController.text.isEmpty) {
      _filteredPokemon = _pokemon;
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: Sizing.horizontalWindowInsets(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isExpanded)
                Flexible(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        height: Sizing.screenHeight(context) * .5),
                    child: _buildTeamNode(),
                  ),
                ),
              if (isExpanded) Sizing.paneSpacer,
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    if (!isExpanded) _buildTeamNode(),

                    Sizing.listItemSpacer,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // User input text field
                        Flexible(
                          flex: 6,
                          child: PogoTextField(
                            controller: _searchController,
                            onClear: () => setState(() {
                              _searchController.clear();
                            }),
                          ),
                        ),

                        Sizing.paneSpacer,

                        // Filter by ranking category
                        Flexible(
                          flex: 1,
                          child: RankingsCategoryButton(
                            onSelected: _filterCategory,
                            selectedCategory: _selectedCategory,
                            dex: true,
                          ),
                        ),
                      ],
                    ),

                    // Spacer
                    SizedBox(
                      height: Sizing.screenHeight(context) * .01,
                    ),

                    _buildPokemonList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              flex: 1,
              child: _buildFloatingActionButton(),
            ),
            if (isExpanded)
              Flexible(
                flex: 1,
                child: Container(),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
