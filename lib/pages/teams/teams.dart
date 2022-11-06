// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'battle_log.dart';
import 'team_edit.dart';
import 'team_builder.dart';
import '../analysis/analysis.dart';
import '../../widgets/nodes/team_node.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../modules/ui/sizing.dart';
import '../../game_objects/user_teams.dart';
import '../../game_objects/pokemon.dart';
import '../../game_objects/pokemon_team.dart';
import '../../modules/data/pogo_data.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A list view of the user's pvp teams is displayed. Each team is a TeamNode,
containing the following functionality :

- remove a team
- analyze a team
- edit a team log
- edit a team
-------------------------------------------------------------------------------
*/

class Teams extends StatefulWidget {
  const Teams({Key? key}) : super(key: key);

  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  late UserTeams _teams = UserTeams();

  void _loadTeams() async {
    _teams = await PogoData.getUserTeams();
    setState(() {});
  }

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
                height: Sizing.blockSizeVertical * 10.0,
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
    final double iconSize = Sizing.blockSizeHorizontal * 6.0;

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
                splashRadius: Sizing.blockSizeHorizontal * 5.0,
              ),

        // Analyze team
        IconButton(
          onPressed: () => _onAnalyzeTeam(teamIndex),
          icon: const Icon(Icons.analytics),
          tooltip: 'Analyze Team',
          iconSize: iconSize,
          splashRadius: Sizing.blockSizeHorizontal * 5.0,
        ),

        // Log team
        IconButton(
          onPressed: () => _onLogTeam(teamIndex),
          icon: const Icon(Icons.query_stats),
          tooltip: 'Log Team',
          iconSize: iconSize,
          splashRadius: Sizing.blockSizeHorizontal * 5.0,
        ),

        // Edit team
        IconButton(
          onPressed: () => _onEditTeam(teamIndex),
          icon: const Icon(Icons.build_circle),
          tooltip: 'Edit Team',
          iconSize: iconSize,
          splashRadius: Sizing.blockSizeHorizontal * 5.0,
        ),

        IconButton(
          onPressed: () => _onLockTeam(teamIndex),
          icon: Icon(lockIcon),
          tooltip: 'Unlock Team',
          iconSize: iconSize,
          splashRadius: Sizing.blockSizeHorizontal * 5.0,
        )
      ],
    );
  }

  // Remove the team at specified index
  void _onClearTeam(int teamIndex) {
    setState(() {
      final removedTeam = _teams.removeTeamAt(teamIndex);
      if (removedTeam.id != null) {
        PogoData.deleteUserPokemonTeam(removedTeam.id!);
      }
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
        _teams[teamIndex].fromBuilderCopy((newTeam as UserPokemonTeam));
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
  void _onLockTeam(int teamIndex) {
    setState(() {
      _teams[teamIndex].toggleLock();
    });
  }

  // Add a new empty team
  void _onAddTeam() async {
    UserPokemonTeam newTeam =
        await PogoData.createUserPokemonTeam(_teams.teamsCount);
    setState(() {
      _teams.addTeam(newTeam);
    });
  }

  // Navigate to the team build search page, with focus on the specified
  // nodeIndex
  void _onEmptyPressed(int teamIndex, int nodeIndex) async {
    final team = _teams[teamIndex];

    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<PokemonTeam>(builder: (BuildContext context) {
        return TeamBuilder(
          team: team,
          cup: team.cup,
          focusIndex: nodeIndex,
        );
      }),
    );

    if (newTeam != null) {
      setState(() {
        _teams[teamIndex].fromBuilderCopy(newTeam as UserPokemonTeam);
        PogoData.updateUserPokemonTeam(_teams[teamIndex], teamIndex);
      });
    }
  }

  // Ensure the widget is mounted before setState
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTeams();
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
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              width: Sizing.blockSizeHorizontal * 5.0,
            ),
            Icon(
              Icons.add,
              size: Sizing.blockSizeHorizontal * 7.0,
            ),
          ],
        ),
        width: Sizing.screenWidth * .85,
        height: Sizing.blockSizeVertical * 8.5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
