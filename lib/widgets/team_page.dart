// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../screens/team_info.dart';
import 'nodes/pokemon_nodes.dart';
import 'nodes/empty_node.dart';
import 'dropdowns/cup_dropdown.dart';
import 'dropdowns/team_size_dropdown.dart';
import '../widgets/team_analysis.dart';
import '../widgets/buttons/footer_buttons.dart';
import '../data/pokemon/pokemon_team.dart';
import '../data/pokemon/pokemon.dart';
import '../configs/size_config.dart';
import '../screens/pokemon_search.dart';

/*
-------------------------------------------------------------------------------
A single page that contains all elements to build a Pokemon team. There is the
Cup dropdown, team size dropdown, and team containers (1 for every Pokemon).
The analysis content will dynamically render below the given team whenever a
change is made, this will reflect the type coverages, counters, alternates, etc
-------------------------------------------------------------------------------
*/

class TeamPage extends StatefulWidget {
  const TeamPage({
    Key? key,
    required this.team,
  }) : super(key: key);

  // This team page's Pokemon team
  final PokemonTeam team;

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  // SETTER CALLBACKS
  void _onCupChanged(String? newCup) {
    if (newCup == null) return;

    setState(() {
      widget.team.setCup(newCup);
    });
  }

  void _onTeamSizeChanged(int? newSize) {
    if (newSize == null) return;

    setState(() {
      widget.team.setTeamSize(newSize);
    });
  }

  void _onPokemonChanged(int index, Pokemon? newPokemon) {
    setState(() {
      widget.team.setPokemon(index, newPokemon);
    });
  }

  void _teamSwapMode(Pokemon newPokemon) {
    //print(newPokemon.speciesName);
    setState(() {
      // Scroll to the top of the page
      _scrollController.animateTo(
        0.0,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    });
  }

  // Scroll to the analyze portion of the screen
  // This is 1 vertical screen length below the team builder
  void _onAnalyzePressed() async {
    // If the team is empty, no action will be taken
    if (widget.team.isEmpty()) return;

    setState(() {
      _scrollController.animateTo(
        SizeConfig.screenHeight,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    });
  }

  // Push the TeamInfo screen onto the navigator stack
  void _onTeamInfoPressed() {
    // If the team is empty, no action will be taken
    if (widget.team.isEmpty()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return TeamInfo(pokemonTeam: widget.team.getPokemonTeam());
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  // Keeps page state upon swiping away in PageView
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final pokemonTeam = widget.team.team;
    final cup = widget.team.cup;

    List<Widget> teamContainers = List.generate(
      pokemonTeam.length,
      (index) => Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 1.5,
          bottom: SizeConfig.blockSizeVertical * 1.5,
        ),
        child: TeamContainer(
          key: UniqueKey(),
          nodeIndex: index,
          team: widget.team,
          onNodeChanged: _onPokemonChanged,
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
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
              ),

              // Dropdown to select team size
              TeamSizeDropdown(
                size: widget.team.team.length,
                onTeamSizeChanged: _onTeamSizeChanged,
              ),
            ],
          ),

          // Spacer
          SizedBox(
            height: SizeConfig.blockSizeVertical * 1.5,
          ),

          // The list of team nodes
          ListView(
            shrinkWrap: true,
            children: teamContainers,
            physics: const NeverScrollableScrollPhysics(),
          ),

          // Spacer
          SizedBox(
            height: SizeConfig.blockSizeVertical * 1.5,
          ),
          FooterButtons(
            onAnalyzePressed: _onAnalyzePressed,
            onTeamInfoPressed: _onTeamInfoPressed,
          ),

          // The team analysis content
          TeamAnalysis(
            key: UniqueKey(),
            team: widget.team,
            onTeamSwap: _teamSwapMode,
          ),
        ],
      ),
    );
  }
}

// A TeamContainer is either an EmptyNode or PokemonNode
// An EmptyNode can be tapped by the user to add a Pokemon to it
// After a Pokemon is added it is a PokemonNode
class TeamContainer extends StatefulWidget {
  const TeamContainer({
    Key? key,
    required this.nodeIndex,
    required this.team,
    required this.onNodeChanged,
  }) : super(key: key);

  final int nodeIndex;
  final PokemonTeam team;
  final Function(int index, Pokemon?) onNodeChanged;

  @override
  _TeamContainerState createState() => _TeamContainerState();
}

class _TeamContainerState extends State<TeamContainer> {
  // Open a new app page that allows the user to search for a given Pokemon
  // If a Pokemon is selected in that page, the Pokemon reference will be kept
  // The node will then populate all data related to that Pokemon
  _searchMode() async {
    final newPokemon = await Navigator.push(
      context,
      MaterialPageRoute<Pokemon>(builder: (BuildContext context) {
        return PokemonSearch(
          team: widget.team,
        );
      }),
    );

    // If a pokemon was returned from the search page, update the node
    // Should only be null when the user exits the search page using the app bar
    if (newPokemon != null) {
      widget.onNodeChanged(widget.nodeIndex, newPokemon);
    }
  }

  // Revert a PokemonNode back to an EmptyNode
  _clearNode() {
    widget.onNodeChanged(widget.nodeIndex, null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * .95,
      height: SizeConfig.screenHeight * .205,

      // If the Pokemon ref is null, build an empty node
      // Otherwise build a Pokemon node with cooresponding data
      child: (widget.team.isNull(widget.nodeIndex)
          ? EmptyNode(
              onPressed: _searchMode,
            )
          : PokemonNode(
              nodeIndex: widget.nodeIndex,
              pokemon: widget.team.getPokemon(widget.nodeIndex),
              cup: widget.team.cup,
              searchMode: _searchMode,
              clear: _clearNode,
              onNodeChanged: widget.onNodeChanged,
            )),
    );
  }
}
