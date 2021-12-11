// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo_teams/pages/analysis/analysis.dart';

// Package Imports
import 'package:provider/provider.dart';

// Local Imports
import 'team_builder_search.dart';
import '../../../widgets/nodes/team_node.dart';
import '../../../widgets/buttons/gradient_button.dart';
import '../../../widgets/nodes/win_loss_node.dart';
import '../../../configs/size_config.dart';
import '../../../data/teams_provider.dart';
import '../../../data/pokemon/pokemon_team.dart';

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class BattleLog extends StatefulWidget {
  const BattleLog({
    Key? key,
    required this.teamIndex,
  }) : super(key: key);

  final int teamIndex;

  @override
  _BattleLogState createState() => _BattleLogState();
}

class _BattleLogState extends State<BattleLog> {
  late final UserPokemonTeam _team =
      Provider.of<TeamsProvider>(context, listen: false)
          .builderTeams[widget.teamIndex];

  // Build the app bar with the current page title, and icon
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Battle Log',
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
            Icons.query_stats,
            size: SizeConfig.blockSizeHorizontal * 6.0,
          ),
        ],
      ),
    );
  }

  Widget _buildScaffoldBody() {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 1.0,
        left: SizeConfig.blockSizeHorizontal * 2.0,
        right: SizeConfig.blockSizeHorizontal * 2.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTeamNode(),
          Text(
            '- Opponent Teams -',
            style: TextStyle(
              fontSize: SizeConfig.h1,
              fontWeight: FontWeight.bold,
              letterSpacing: SizeConfig.blockSizeHorizontal * .7,
            ),
          ),

          // Spacer
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.0,
          ),
          _buildLogsList(),
        ],
      ),
    );
  }

  // The user's team
  Widget _buildTeamNode() {
    return TeamNode(
      onPressed: (_) {},
      onEmptyPressed: (_) {},
      team: _team,
      cup: _team.cup,
      buildHeader: true,
      emptyTransparent: true,
      collapsible: true,
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeHorizontal * 2.0,
        left: SizeConfig.blockSizeHorizontal * 3.0,
        right: SizeConfig.blockSizeHorizontal * 3.0,
      ),
    );
  }

  // Build the list of TeamNodes, with the necessary callbacks
  Widget _buildLogsList() {
    // Provider retrieve
    final List<LogPokemonTeam> _logs = _team.logs;

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          if (index == _logs.length - 1) {
            return Column(
              children: [
                TeamNode(
                  onEmptyPressed: (nodeIndex) =>
                      _onEmptyPressed(index, nodeIndex),
                  onPressed: (_) {},
                  team: _logs[index],
                  cup: _team.cup,
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
            team: _logs[index],
            cup: _team.cup,
            footer: _buildTeamNodeFooter(index),
          );
        },
        physics: const BouncingScrollPhysics(),
      ),
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
      child: _buildFooterButtons(teamIndex),
    );
  }

  // The icon buttons at the footer of each TeamNode
  Widget _buildFooterButtons(int teamIndex) {
    // Size of the footer icons
    final double iconSize = SizeConfig.blockSizeHorizontal * 6.0;

    // Provider retrieve
    final _log = _team.logs[teamIndex];
    final IconData lockIcon = _log.locked ? Icons.lock : Icons.lock_open;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remove team option if the team is unlocked
        _log.locked
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

        // Edit team
        IconButton(
          onPressed: () => _onEditTeam(teamIndex),
          icon: const Icon(Icons.build_circle),
          tooltip: 'Edit Team',
          iconSize: iconSize,
          splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
        ),

        // Lock team
        IconButton(
          onPressed: () => _onLockPressed(teamIndex),
          icon: Icon(lockIcon),
          tooltip: 'Unlock Team',
          iconSize: iconSize,
          splashRadius: SizeConfig.blockSizeHorizontal * 5.0,
        ),

        // Win, tie, loss indicator
        WinLossNode(winLossKey: _log.winLossKey),
      ],
    );
  }

  // Build a log buttton, and if there are existing logs, also an analyze
  // button which will apply to all logged opponent teams.
  Widget _buildFloatingActionButtons() {
    // If logs are empty, then only give the option to add
    if (_team.logs.isEmpty) {
      return GradientButton(
        onPressed: _onAddTeam,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Log Opponent Team',
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
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Analyze button
        GradientButton(
          onPressed: _onAnalyzeLogs,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Analyze',
                style: TextStyle(
                  fontSize: SizeConfig.h2,
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 4.0,
              ),
              Icon(
                Icons.analytics,
                size: SizeConfig.blockSizeHorizontal * 7.0,
              ),
            ],
          ),
          width: SizeConfig.screenWidth * .42,
          height: SizeConfig.blockSizeVertical * 8.5,
        ),

        // Log button
        GradientButton(
          onPressed: _onAddTeam,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Log',
                style: TextStyle(
                  fontSize: SizeConfig.h2,
                ),
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 4.0,
              ),
              Icon(
                Icons.add,
                size: SizeConfig.blockSizeHorizontal * 7.0,
              ),
            ],
          ),
          width: SizeConfig.screenWidth * .42,
          height: SizeConfig.blockSizeVertical * 8.5,
        ),
      ],
    );
  }

  // Remove the team at specified index
  void _onClearTeam(int teamIndex) {
    setState(() {
      _team.removeLogAt(teamIndex);
    });
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzeTeam(int teamIndex) {
    final _log = _team.logs[teamIndex];

    // If the team is empty, no action will be taken
    if (_log.isEmpty()) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return Analysis(
          team: _team,
          opponentTeam: _log,
        );
      }),
    );
  }

  // Edit the team at specified index
  void _onEditTeam(int teamIndex) async {
    PokemonTeam _log = _team.logs[teamIndex];

    final _newLog = await Navigator.push(
      context,
      MaterialPageRoute<PokemonTeam>(builder: (BuildContext context) {
        return TeamBuilderSearch(
          team: _log,
          cup: _team.cup,
          focusIndex: 0,
        );
      }),
    );

    if (_newLog != null) {
      setState(() {
        _log = _newLog;
      });
    }
  }

  // Add a new empty team
  void _onAddTeam() async {
    _team.addLog();

    final _newLog = await Navigator.push(
      context,
      MaterialPageRoute<LogPokemonTeam>(builder: (BuildContext context) {
        return TeamBuilderSearch(
          team: _team.logs.last,
          cup: _team.cup,
          focusIndex: 0,
        );
      }),
    );

    setState(() {
      if (_newLog != null) {
        _team.logs.last = _newLog;
      } else {
        _team.logs.removeLast();
      }
    });
  }

  // Wrapper for _onEditTeam
  void _onEmptyPressed(int teamIndex, int nodeIndex) async {
    PokemonTeam _log = _team.logs[teamIndex];

    final _newLog = await Navigator.push(
      context,
      MaterialPageRoute<PokemonTeam>(builder: (BuildContext context) {
        return TeamBuilderSearch(
          team: _log,
          cup: _team.cup,
          focusIndex: nodeIndex,
        );
      }),
    );

    if (_newLog != null) {
      setState(() {
        _log = _newLog;
      });
    }
  }

  void _onLockPressed(int teamIndex) {
    setState(() {
      _team.logs[teamIndex].toggleLock();
    });
  }

  // Navigate to an analysis of all logged opponent teams
  void _onAnalyzeLogs() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return Analysis(
          team: _team,
          opponentTeams: _team.logs,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildScaffoldBody(),

      // Log opponent team FAB
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
