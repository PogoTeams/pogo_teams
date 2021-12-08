// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo_teams/screens/battle_log.dart';
import 'package:pogo_teams/screens/team_builder_search.dart';

// Package Import
import 'package:provider/provider.dart';

// Local Imports
import '../../widgets/nodes/pokemon_node.dart';
import '../../widgets/traits_icons.dart';
import '../../widgets/nodes/square_pokemon_node.dart';
import '../../widgets/dropdowns/cup_dropdown.dart';
import '../../widgets/dropdowns/team_size_dropdown.dart';
import '../../widgets/team_analysis.dart';
import '../../widgets/buttons/analyze_button.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/pokemon.dart';
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
A full page view of a user's Pokemon team. When there is at least 1 Pokemon on
the team, an Analysis button will appear, where the user can view a complete
analysis of their team. The following operations are currently supported for
each Pokemon node on the team :

- Remove Pokemon
- Swap Pokemon
-------------------------------------------------------------------------------
*/

class TeamEdit extends StatefulWidget {
  const TeamEdit({
    Key? key,
    required this.teamIndex,
  }) : super(key: key);

  final int teamIndex;

  @override
  _TeamEditState createState() => _TeamEditState();
}

class _TeamEditState extends State<TeamEdit>
    with AutomaticKeepAliveClientMixin {
  // Used to manually notify parent listeners that use this team
  late PokemonTeams _provider;

  // The team at to edit
  late PokemonTeam _team;

  final _scrollController = ScrollController();

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Team Edit',
            style: TextStyle(
              fontSize: SizeConfig.h2,
              fontStyle: FontStyle.italic,
            ),
          ),

          // Spacer
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 3.0,
          ),

          // Page icon
          Icon(
            Icons.change_circle,
            size: SizeConfig.blockSizeHorizontal * 6.0,
          ),
        ],
      ),
    );
  }

  // SETTER CALLBACKS
  void _onCupChanged(String? newCup) {
    if (newCup == null) return;

    setState(() {
      _team.setCup(newCup);
      _provider.notify();
    });
  }

  void _onTeamSizeChanged(int? newSize) {
    if (newSize == null) return;

    setState(() {
      _team.setTeamSize(newSize);
      _provider.notify();
    });
  }

  void _onPokemonChanged(int index, Pokemon? newPokemon) {
    setState(() {
      _team.setPokemon(index, newPokemon);
      _provider.notify();
    });
  }

  void _onTeamChanged(List<Pokemon> newPokemonTeam) {
    setState(() {
      _team.setTeam(newPokemonTeam);

      // Scroll to the top of the page
      _scrollController.animateTo(
        0.0,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );

      _provider.notify();
    });
  }

  _searchMode(int nodeIndex) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return TeamBuilderSearch(
          team: _team,
          teamIndex: widget.teamIndex,
          focusIndex: nodeIndex,
        );
      }),
    );
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzePressed() async {
    // If the team is empty, no action will be taken
    if (_team.isEmpty()) return;

    setState(() {
      _scrollController.animateTo(
        SizeConfig.screenHeight * (_team.team.length == 3 ? .78 : 1.42),
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  // Build a row of icon buttons at the bottom of a Pokemon's Node
  // If the Pokemon in question is null, this footer is also null
  Widget? _buildNodeFooter(Pokemon? pokemon, int nodeIndex) {
    if (pokemon == null) return null;

    // Size of the footer icons
    final double iconSize = SizeConfig.blockSizeHorizontal * 6.2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _onPokemonChanged(nodeIndex, null),
          icon: const Icon(Icons.clear),
          tooltip: 'remove this pokemon from your team',
          iconSize: iconSize,
        ),
        IconButton(
          onPressed: () => _searchMode(nodeIndex),
          icon: const Icon(Icons.swap_horiz),
          tooltip: 'search for a different pokemon',
          iconSize: iconSize,
        ),
      ],
    );
  }

  // Keeps page state upon swiping away in PageView
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Provider retrieval
    _provider = Provider.of<PokemonTeams>(context);
    _team = _provider.pokemonTeams[widget.teamIndex];

    final pokemonTeam = _team.team;
    final cup = _team.cup;

    // The list of either 3 or 6 PokemonNodes that make up this team
    List<Widget> teamNodes = List.generate(
      pokemonTeam.length,
      (index) => Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 1.1,
          bottom: SizeConfig.blockSizeVertical * 1.1,
        ),
        child: PokemonNode.large(
          pokemon: pokemonTeam[index],
          cup: _team.cup,
          nodeIndex: index,
          onEmptyPressed: () => _searchMode(index),
          footer: _buildNodeFooter(pokemonTeam[index], index),
        ),
      ),
    );

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 2.0,
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          controller: _scrollController,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dropdown for pvp cup selection
                CupDropdown(
                  cup: cup,
                  onCupChanged: _onCupChanged,
                  width: SizeConfig.screenWidth * .7,
                ),

                // Dropdown to select team size
                TeamSizeDropdown(
                  size: pokemonTeam.length,
                  onTeamSizeChanged: _onTeamSizeChanged,
                ),
              ],
            ),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 1.0,
            ),

            // The list of team nodes
            ListView(
              shrinkWrap: true,
              children: teamNodes,
              physics: const NeverScrollableScrollPhysics(),
            ),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 1.5,
            ),

            AnalyzeButton(
              key: UniqueKey(),
              isEmpty: _team.isEmpty(),
              onPressed: _onAnalyzePressed,
            ),

            // The team analysis content
            TeamAnalysis(
              key: UniqueKey(),
              team: _team,
              onTeamChanged: _onTeamChanged,
            ),
          ],
        ),
      ),
    );
  }
}
