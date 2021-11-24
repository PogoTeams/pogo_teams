// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'nodes/team_node.dart';
import 'dropdowns/cup_dropdown.dart';
import 'dropdowns/team_size_dropdown.dart';
import '../widgets/team_analysis.dart';
import 'buttons/analyze_button.dart';
import '../data/pokemon/pokemon_team.dart';
import '../data/pokemon/pokemon.dart';
import '../configs/size_config.dart';

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

  void _onTeamChanged(List<Pokemon> newPokemonTeam) {
    setState(() {
      widget.team.setTeam(newPokemonTeam);

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
        SizeConfig.screenHeight * .8,
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

  // Keeps page state upon swiping away in PageView
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final pokemonTeam = widget.team.team;
    final cup = widget.team.cup;

    List<Widget> teamNodes = List.generate(
      pokemonTeam.length,
      (index) => Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 1.5,
          bottom: SizeConfig.blockSizeVertical * 1.5,
        ),
        child: TeamNode(
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
            onAnalyzePressed: _onAnalyzePressed,
          ),

          // The team analysis content
          TeamAnalysis(
            key: UniqueKey(),
            team: widget.team,
            onTeamChanged: _onTeamChanged,
          ),
        ],
      ),
    );
  }
}
