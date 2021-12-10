// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:provider/provider.dart';

// Local Imports
import 'team_edit.dart';
import 'team_builder_search.dart';
import '../team_analysis.dart';
import '../team_battle_log.dart';
import '../../widgets/nodes/team_node.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../configs/size_config.dart';
import '../../data/teams_provider.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/pokemon_team.dart';

/*
-------------------------------------------------------------------------------
A list view of the user's pvp teams is displayed. Each team is a TeamNode,
containing the following functionality :

- remove a team
- analyze a team
- edit a team log
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
        Provider.of<TeamsProvider>(context, listen: true).builderTeams;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _teams.length,
      itemBuilder: (context, index) {
        if (index == _teams.length - 1) {
          return Column(
            children: [
              TeamNode(
                onEmptyPressed: (nodeIndex) =>
                    _onEmptyPressed(index, nodeIndex),
                onPressed: (_) {},
                team: _teams[index],
                buildHeader: true,
                footer: _buildTeamNodeFooter(index),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 10.0,
              ),
            ],
          );
        }

        return TeamNode(
          onEmptyPressed: (nodeIndex) => _onEmptyPressed(index, nodeIndex),
          onPressed: (_) {},
          team: _teams[index],
          buildHeader: true,
          footer: _buildTeamNodeFooter(index),
        );
      },
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildFooterButtons(teamIndex),
      ),
    );
  }

  // The icon buttons at the footer of each TeamNode
  List<Widget> _buildFooterButtons(int teamIndex) {
    // Size of the footer icons
    final double iconSize = SizeConfig.blockSizeHorizontal * 6.0;

    // Provider retrieve
    final _team = Provider.of<TeamsProvider>(context, listen: true)
        .builderTeams[teamIndex];

    if (_team.locked) {
      return [
        // Analyze team
        IconButton(
          onPressed: () => _onAnalyzeTeam(teamIndex),
          icon: const Icon(Icons.analytics),
          tooltip: 'Analyze Team',
          iconSize: iconSize,
          splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
        ),

        // Log team
        IconButton(
          onPressed: () => _onLogTeam(teamIndex),
          icon: const Icon(Icons.query_stats),
          tooltip: 'Log Team',
          iconSize: iconSize,
          splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
        ),

        // Edit team
        IconButton(
          onPressed: () => _onEditTeam(teamIndex),
          icon: const Icon(Icons.change_circle),
          tooltip: 'Edit Team',
          iconSize: iconSize,
          splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
        ),

        IconButton(
          onPressed: () => _onLockPressed(teamIndex),
          icon: const Icon(Icons.lock),
          tooltip: 'Unlock Team',
          iconSize: iconSize,
          splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
        ),
      ];
    }

    return [
      // Remove team
      IconButton(
        onPressed: () => _onClearTeam(teamIndex),
        icon: const Icon(Icons.clear),
        tooltip: 'Remove Team',
        iconSize: iconSize,
        splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
      ),

      // Analyze team
      IconButton(
        onPressed: () => _onAnalyzeTeam(teamIndex),
        icon: const Icon(Icons.analytics),
        tooltip: 'Analyze Team',
        iconSize: iconSize,
        splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
      ),

      // Log team
      IconButton(
        onPressed: () => _onLogTeam(teamIndex),
        icon: const Icon(Icons.query_stats),
        tooltip: 'Log Team',
        iconSize: iconSize,
        splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
      ),

      // Edit team
      IconButton(
        onPressed: () => _onEditTeam(teamIndex),
        icon: const Icon(Icons.change_circle),
        tooltip: 'Edit Team',
        iconSize: iconSize,
        splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
      ),

      IconButton(
        onPressed: () => _onLockPressed(teamIndex),
        icon: const Icon(Icons.lock_open),
        tooltip: 'Lock Team',
        iconSize: iconSize,
        splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
      ),
    ];
  }

  // Remove the team at specified index
  void _onClearTeam(int teamIndex) {
    setState(() {
      Provider.of<TeamsProvider>(context, listen: false)
          .removeTeamAt(teamIndex);
    });
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzeTeam(int teamIndex) async {
    final _team = Provider.of<TeamsProvider>(context, listen: false)
        .builderTeams[teamIndex];

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

  void _onLogTeam(int teamIndex) {
    Navigator.push(
      context,
      MaterialPageRoute<Pokemon>(
        builder: (BuildContext context) => TeamBattleLog(
          teamIndex: teamIndex,
        ),
      ),
    );
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

  void _onLockPressed(int teamIndex) {
    setState(() {
      Provider.of<TeamsProvider>(context, listen: false)
          .builderTeams[teamIndex]
          .toggleLock();
    });
  }

  // Add a new empty team
  void _onAddTeam() {
    Provider.of<TeamsProvider>(context, listen: false).addTeam();
  }

  // Navigate to the team build search page, with focus on the specified
  // nodeIndex
  void _onEmptyPressed(int teamIndex, int nodeIndex) async {
    PokemonTeam _team = Provider.of<TeamsProvider>(context, listen: false)
        .builderTeams[teamIndex];

    final _newTeam = await Navigator.push(
      context,
      MaterialPageRoute<PokemonTeam>(builder: (BuildContext context) {
        return TeamBuilderSearch(
          team: _team,
          focusIndex: nodeIndex,
        );
      }),
    );

    if (_newTeam != null) {
      setState(() {
        _team = _newTeam;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTeamsList(context),

      // Add team FAB
      floatingActionButton: GradientButton(
        onPressed: _onAddTeam,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add Team',
              style: TextStyle(
                fontSize: SizeConfig.h2,
              ),
            ),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 5.0,
            ),
            Icon(
              Icons.add,
              size: SizeConfig.blockSizeHorizontal * 7.0,
            ),
          ],
        ),
        width: SizeConfig.screenWidth * .85,
        height: SizeConfig.blockSizeVertical * 8.5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
