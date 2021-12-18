// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'team_edit.dart';
import 'team_builder_search.dart';
import '../analysis/analysis.dart';
import 'battle_log.dart';
import '../../widgets/nodes/team_node.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../configs/size_config.dart';
import '../../data/builder_teams.dart';
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

class TeamsBuilder extends StatefulWidget {
  const TeamsBuilder({Key? key, required this.teams}) : super(key: key);

  final UserTeams teams;
  @override
  _TeamsBuilderState createState() => _TeamsBuilderState();
}

class _TeamsBuilderState extends State<TeamsBuilder> {
  late final UserTeams _teams = widget.teams;

  // Build the list of TeamNodes, with the necessary callbacks
  Widget _buildTeamsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _teams.teamsCount,
      itemBuilder: (context, index) {
        if (index == _teams.teamsCount - 1) {
          return Column(
            children: [
              TeamNode(
                onEmptyPressed: (nodeIndex) =>
                    _onEmptyPressed(index, nodeIndex),
                onPressed: (_) {},
                team: _teams[index],
                cup: _teams[index].cup,
                buildHeader: true,
                footer: _buildTeamNodeFooter(index),
              ),

              // Spacer to give last node in the list more scroll room
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
          cup: _teams[index].cup,
          buildHeader: true,
          footer: _buildTeamNodeFooter(index),
        );
      },
      physics: const BouncingScrollPhysics(),
    );
  }

  // The icon buttons at the footer of each TeamNode
  Widget _buildTeamNodeFooter(int teamIndex) {
    // Size of the footer icons
    final double iconSize = SizeConfig.blockSizeHorizontal * 6.0;

    final IconData lockIcon =
        _teams[teamIndex].locked ? Icons.lock : Icons.lock_open;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remove team option if the team is unlocked
        _teams[teamIndex].locked
            ? Container()
            : IconButton(
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
          icon: const Icon(Icons.build_circle),
          tooltip: 'Edit Team',
          iconSize: iconSize,
          splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
        ),

        IconButton(
          onPressed: () => _onLockPressed(teamIndex),
          icon: Icon(lockIcon),
          tooltip: 'Unlock Team',
          iconSize: iconSize,
          splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
        )
      ],
    );
  }

  // Remove the team at specified index
  void _onClearTeam(int teamIndex) {
    setState(() {
      _teams.removeTeamAt(teamIndex);
    });
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzeTeam(int teamIndex) async {
    // If the team is empty, no action will be taken
    if (_teams[teamIndex].isEmpty()) return;

    final newPokemonTeam = await Navigator.push(
      context,
      MaterialPageRoute<List<Pokemon?>>(builder: (BuildContext context) {
        return Analysis(team: _teams[teamIndex]);
      }),
    );

    if (newPokemonTeam != null) {
      setState(() {
        _teams[teamIndex].setPokemonTeam(newPokemonTeam);
      });
    }
  }

  void _onLogTeam(int teamIndex) async {
    final team = _teams[teamIndex];

    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<PokemonTeam>(
        builder: (BuildContext context) => BattleLog(
          team: team,
        ),
      ),
    );

    if (newTeam != null) {
      setState(() {
        _teams[teamIndex] = (newTeam as UserPokemonTeam);
      });
    }
  }

  // Edit the team at specified index
  void _onEditTeam(int teamIndex) async {
    final team = _teams[teamIndex];

    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<PokemonTeam>(
        builder: (BuildContext context) => TeamEdit(team: team),
      ),
    );

    if (newTeam != null) {
      setState(() {
        _teams[teamIndex].fromBuilderCopy((newTeam as UserPokemonTeam));
      });
    }
  }

  // On locking a team, the clear option is removed
  void _onLockPressed(int teamIndex) {
    setState(() {
      _teams[teamIndex].toggleLock();
    });
  }

  // Add a new empty team
  void _onAddTeam() {
    setState(() {
      _teams.addTeam();
    });
  }

  // Navigate to the team build search page, with focus on the specified
  // nodeIndex
  void _onEmptyPressed(int teamIndex, int nodeIndex) async {
    final team = _teams[teamIndex];

    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<PokemonTeam>(builder: (BuildContext context) {
        return TeamBuilderSearch(
          team: team,
          cup: team.cup,
          focusIndex: nodeIndex,
        );
      }),
    );

    if (newTeam != null) {
      setState(() {
        _teams[teamIndex] = (newTeam as UserPokemonTeam);
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
