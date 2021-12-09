// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:provider/provider.dart';

// Local Imports
import 'team_edit.dart';
import 'team_builder_search.dart';
import '../../widgets/team_analysis.dart';
import '../../widgets/nodes/team_node.dart';
import '../../configs/size_config.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/pokemon.dart';

/*
-------------------------------------------------------------------------------
A list view of the user's pvp teams is displayed. Each team is a TeamNode,
containing the following functionality :

- remove a team
- edit a team
-------------------------------------------------------------------------------
*/

class TeamBuilder extends StatefulWidget {
  const TeamBuilder({Key? key}) : super(key: key);

  @override
  _TeamBuilderState createState() => _TeamBuilderState();
}

class _TeamBuilderState extends State<TeamBuilder> {
  // Build the list of TeamNodes, with the necessary callbacks
  Widget _buildTeamsList(BuildContext context) {
    // Provider retrieve
    final _teams =
        Provider.of<PokemonTeams>(context, listen: false).pokemonTeams;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _teams.length,
      itemBuilder: (context, index) => (TeamNode(
        onEmptyPressed: (nodeIndex) => _onEmptyPressed(index, nodeIndex),
        onPressed: (_) {},
        teamIndex: index,
        footer: _buildTeamNodeFooter(index),
      )),
      physics: const BouncingScrollPhysics(),
    );
  }

  // Build a row of icon buttons at the bottom of the TeamNode
  Widget _buildTeamNodeFooter(int teamIndex) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 2.0,
        right: SizeConfig.blockSizeHorizontal * 2.0,
        bottom: SizeConfig.blockSizeVertical * 1.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _buildFooterButtons(teamIndex),
      ),
    );
  }

  // The icon buttons at the footer of each TeamNode
  List<Widget> _buildFooterButtons(int teamIndex) {
    // Size of the footer icons
    final double iconSize = SizeConfig.blockSizeHorizontal * 6.0;

    // Icon spacing
    final EdgeInsets padding = EdgeInsets.only(
      left: SizeConfig.blockSizeHorizontal * 1.0,
      right: SizeConfig.blockSizeHorizontal * 12.0,
    );

    return [
      // Remove team
      IconButton(
        onPressed: () => _onClearTeam(teamIndex),
        icon: const Icon(Icons.clear),
        tooltip: 'Remove Team',
        iconSize: iconSize,
        splashRadius: SizeConfig.blockSizeHorizontal * 6.0,
        padding: padding,
      ),

      // Analyze team
      IconButton(
        onPressed: () => _onAnalyzeTeam(teamIndex),
        icon: const Icon(Icons.analytics),
        tooltip: 'Analyze Team',
        iconSize: iconSize,
        splashRadius: SizeConfig.blockSizeHorizontal * 6.0,
        padding: padding,
      ),

      // Log team
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.query_stats),
        tooltip: 'Log Team',
        iconSize: iconSize,
        splashRadius: SizeConfig.blockSizeHorizontal * 6.0,
        padding: padding,
      ),

      // Edit team
      IconButton(
        onPressed: () => _onEditTeam(teamIndex),
        icon: const Icon(Icons.change_circle),
        tooltip: 'Edit Team',
        iconSize: iconSize,
        splashRadius: SizeConfig.blockSizeHorizontal * 6.0,
        padding: padding,
      ),
    ];
  }

  // Remove the team at specified index
  void _onClearTeam(int teamIndex) {
    setState(() {
      Provider.of<PokemonTeams>(context, listen: false).removeTeamAt(teamIndex);
    });
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzeTeam(int teamIndex) async {
    final _team = Provider.of<PokemonTeams>(context, listen: false)
        .pokemonTeams[teamIndex];

    // If the team is empty, no action will be taken
    if (_team.isEmpty()) return;

    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<List<Pokemon?>>(builder: (BuildContext context) {
        return TeamAnalysis(team: _team);
      }),
    );

    if (newTeam != null) {
      setState(() {
        _team.setTeam(newTeam);
      });
    }
  }

  // Edit the team at specified index
  void _onEditTeam(int teamIndex) {
    Navigator.push(
      context,
      MaterialPageRoute<Pokemon>(
        builder: (BuildContext context) => TeamEdit(
          teamIndex: teamIndex,
        ),
      ),
    );
  }

  // Add a new empty team
  void _onAddTeam() {
    setState(() {
      Provider.of<PokemonTeams>(context, listen: false).addTeam();
    });
  }

  // Wrapper for _onEditTeam
  void _onEmptyPressed(int teamIndex, int nodeIndex) async {
    //_onEditTeam(teamIndex);
    final _team = Provider.of<PokemonTeams>(context, listen: false)
        .pokemonTeams[teamIndex];

    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return TeamBuilderSearch(
          team: _team,
          teamIndex: teamIndex,
          focusIndex: nodeIndex,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTeamsList(context),

      // Add team FAB
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTeam,
        child: Icon(
          Icons.add,
          size: SizeConfig.blockSizeHorizontal * 9.0,
        ),
        tooltip: 'Add a Team',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
