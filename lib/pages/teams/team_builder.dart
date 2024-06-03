// Flutter
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pogo_teams/app/views/app_views.dart';
import 'package:pogo_teams/battle/battle_result.dart';
import 'package:pogo_teams/model/battle_pokemon.dart';
import 'package:pogo_teams/model/pokemon_typing.dart';
import 'package:pogo_teams/modules/pokemon_types.dart';
import 'package:pogo_teams/ranker/pokemon_ranker.dart';
import 'package:pogo_teams/ranker/ranking_data.dart';

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
        if (_selectedCategory == RankingsCategories.smart) {
          _filterCategory(_selectedCategory);
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

    _team.cup = _cup;
    PogoRepository.putPokemonTeam(_team);

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

    if (_team.getOrderedPokemonList().isNotEmpty &&
        _selectedCategory == RankingsCategories.smart) {
      _pokemon = await _getSmartCupPokemonList();
    } else {
      _pokemon = _cup.getCupPokemonList(rankingsCategory);
    }

    _filterPokemonList();
  }

  Future<List<CupPokemon>> _getSmartCupPokemonList() async {
    final Map<int, RankingData> teamRankingData = {};
    final List<CupPokemon> leadThreats = [];
    final List<CupPokemon> overallThreats = [];

    List<CupPokemon> opponents = PogoRepository.getCupPokemon(
      _team.cup,
      PokemonTypes.generateTypeList(
        _team.cup.includedTypeKeys(),
      ),
      RankingsCategories.overall,
      limit: 100,
    );

    List<BattleResult> losses = [];

    // Simulate battles against the top meta for this cup
    for (UserPokemon pokemon in _team.getOrderedPokemonList()) {
      BattlePokemon battlePokemon =
          await BattlePokemon.fromPokemonAsync(await pokemon.getBaseAsync())
            ..selectedBattleFastMove = await pokemon.getSelectedFastMoveAsync()
            ..selectedBattleChargeMoves =
                await pokemon.getSelectedChargeMovesAsync();

      battlePokemon.initializeStats(_team.cup.cp);

      int pokemonIndex = pokemon.teamIndex ?? -1;
      if (pokemonIndex != -1) {
        teamRankingData[pokemon.teamIndex ?? 0] = await PokemonRanker.rankApp(
          battlePokemon,
          _team.cup,
          opponents,
        );

        // Accumulate lead outcomes
        int len =
            min(10, teamRankingData[pokemonIndex]!.leadOutcomes!.losses.length);
        losses.addAll(teamRankingData[pokemonIndex]!
            .leadOutcomes!
            .losses
            .getRange(0, len));

        // Accumulate switch outcomes
        len = min(
            10, teamRankingData[pokemonIndex]!.switchOutcomes!.losses.length);
        losses.addAll(teamRankingData[pokemonIndex]!
            .switchOutcomes!
            .losses
            .getRange(0, len));

        // Accumulate closer outcomes
        len = min(
            10, teamRankingData[pokemonIndex]!.closerOutcomes!.losses.length);
        losses.addAll(teamRankingData[pokemonIndex]!
            .closerOutcomes!
            .losses
            .getRange(0, len));
      }
    }

    losses.sort((loss1, loss2) =>
        loss2.opponent.currentRating > loss1.opponent.currentRating ? -1 : 1);

    for (BattleResult loss in losses) {
      // Avoid adding duplicate Pokemon
      if (-1 ==
          overallThreats.indexWhere((threat) =>
              threat.getBase().pokemonId == loss.opponent.pokemonId)) {
        overallThreats.add(CupPokemon.fromBattlePokemon(
          loss.opponent,
          PogoRepository.getPokemonById(loss.opponent.pokemonId),
        ));
      }

      if (overallThreats.length == 20) break;
    }

    // If the user's team has a lead Pokemon
    if (teamRankingData.containsKey(0)) {
      List<BattleResult> leadLosses = teamRankingData[0]!.leadOutcomes!.losses;
      // Scale opponent's outcome rating to it's rating against the meta.
      /*
      for (BattleResult result in leadLosses) {
        int i = opponents.indexWhere((pokemon) =>
            pokemon.getBase().pokemonId == result.opponent.pokemonId);
        if (i == -1) {
          result.opponent.currentRating = 0;
        } else {
          result.opponent.currentRating *= opponents[i].ratings.lead;
        }
      }

      // Resort the losses after scaling
      leadLosses.sort((r1, r2) =>
          (r2.opponent.currentRating > r1.opponent.currentRating ? -1 : 1));
          */

      int len = min(leadLosses.length, 20);
      for (BattleResult result in leadLosses.getRange(0, len)) {
        leadThreats.add(CupPokemon.fromBattlePokemon(
          result.opponent,
          PogoRepository.getPokemonById(result.opponent.pokemonId),
        ));
      }
    }

    return overallThreats;
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(
          context,
          _team,
        ),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Team Builder',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          // Spacer
          SizedBox(
            width: Sizing.screenWidth(context) * .03,
          ),

          // Page icon
          const Icon(
            Icons.build_circle,
            size: Sizing.icon3,
          ),
        ],
      ),
    );
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
      appBar: isExpanded ? _buildAppBar() : null,
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
                  child: _buildTeamNode(),
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
                            smart: true,
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
      floatingActionButton: isExpanded ? null : _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
