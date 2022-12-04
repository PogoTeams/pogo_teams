// Flutter
import 'dart:ui';

import 'package:flutter/material.dart';

// Local Imports
import 'battle_log.dart';
import 'team_edit.dart';
import 'team_builder.dart';
import '../analysis/analysis.dart';
import '../../widgets/nodes/team_node.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/buttons/tag_filter_button.dart';
import '../../widgets/overlays/team_tag_overlay.dart';
import '../../modules/ui/sizing.dart';
import '../../pogo_objects/pokemon_team.dart';
import '../../pogo_objects/tag.dart';
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
  late List<UserPokemonTeam> _teams;
  Tag? _selectedTag;

  // Build the list of TeamNodes, with the necessary callbacks
  Widget _buildTeamsList(BuildContext context) {
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
                pokemonTeam: _teams[index].getOrderedPokemonListFilled(),
                cup: _teams[index].getCup(),
                tag: _teams[index].tag.value,
                onTagPressed: () => _onTagTeam(index),
                buildHeader: true,
                winRate: _teams[index].getWinRate(),
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
          pokemonTeam: _teams[index].getOrderedPokemonListFilled(),
          cup: _teams[index].getCup(),
          tag: _teams[index].tag.value,
          onTagPressed: () => _onTagTeam(index),
          buildHeader: true,
          winRate: _teams[index].getWinRate(),
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
        if (!_teams[teamIndex].locked)
          IconButton(
            onPressed: () => _onClearTeam(teamIndex),
            icon: const Icon(Icons.clear),
            tooltip: 'Remove Team',
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

        // Tag team
        IconButton(
          onPressed: () => _onTagTeam(teamIndex),
          icon: const Icon(Icons.tag),
          tooltip: 'Tag Team',
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

        IconButton(
          onPressed: () => _onLockTeam(teamIndex),
          icon: Icon(lockIcon),
          tooltip: 'Toggle Team Lock',
          iconSize: iconSize,
          splashRadius: Sizing.blockSizeHorizontal * 5.0,
        )
      ],
    );
  }

  // Remove the team at specified index
  void _onClearTeam(int teamIndex) {
    setState(() {
      PogoData.deleteUserPokemonTeamSync(_teams[teamIndex].id);
    });
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzeTeam(int teamIndex) async {
    // If the team is empty, no action will be taken
    if (_teams[teamIndex].isEmpty()) return;

    await Navigator.push(
      context,
      MaterialPageRoute<bool>(builder: (BuildContext context) {
        return Analysis(team: _teams[teamIndex]);
      }),
    );

    setState(() {});
  }

  void _onLogTeam(int teamIndex) async {
    await Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => BattleLog(
          team: _teams[teamIndex],
        ),
      ),
    );

    setState(() {});
  }

  void _onTagTeam(teamIndex) async {
    final selectedTag = await showDialog<Tag>(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            insetPadding: EdgeInsets.only(
              left: Sizing.blockSizeHorizontal * 2.0,
              right: Sizing.blockSizeHorizontal * 2.0,
            ),
            backgroundColor: Colors.transparent,
            child: TeamTagOverlay(
              team: _teams[teamIndex],
              winRate: _teams[teamIndex].getWinRate(),
            ),
          ),
        );
      },
    );

    if (selectedTag != null) {
      setState(() {
        _teams[teamIndex].setTag(selectedTag);
        PogoData.updatePokemonTeamSync(_teams[teamIndex]);
      });
    }
  }

  // Edit the team at specified index
  void _onEditTeam(int teamIndex) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TeamEdit(team: _teams[teamIndex]),
      ),
    );

    setState(() {});
  }

  // On locking a team, the clear option is removed
  void _onLockTeam(int teamIndex) {
    setState(() {
      _teams[teamIndex].toggleLock();
      PogoData.updatePokemonTeamSync(_teams[teamIndex]);
    });
  }

  // Add a new empty team
  void _onAddTeam() async {
    setState(() {
      UserPokemonTeam newTeam = UserPokemonTeam()
        ..dateCreated = DateTime.now().toUtc()
        ..cup.value = PogoData.getCupsSync().first;
      PogoData.updatePokemonTeamSync(newTeam);
    });
  }

  // Navigate to the team build search page, with focus on the specified
  // nodeIndex
  void _onEmptyPressed(int teamIndex, int nodeIndex) async {
    final team = _teams[teamIndex];

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return TeamBuilder(
          team: team,
          cup: team.getCup(),
          focusIndex: nodeIndex,
        );
      }),
    );

    setState(() {});
  }

  void _onTagChanged(Tag? tag) {
    setState(() {
      _selectedTag = tag;
    });
  }

  // Ensure the widget is mounted before setState
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    _teams = PogoData.getUserTeamsSync(tag: _selectedTag);

    return Scaffold(
      body: _buildTeamsList(context),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GradientButton(
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
            width: Sizing.screenWidth * .6,
            height: Sizing.blockSizeVertical * 8.5,
          ),
          TagFilterButton(
            tag: _selectedTag,
            onTagChanged: _onTagChanged,
            width: Sizing.blockSizeHorizontal * .85,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
