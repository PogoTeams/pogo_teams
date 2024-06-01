// Flutter
import 'package:flutter/material.dart';
import 'package:pogo_teams/pages/analysis/analysis.dart';

// Packages

// Local Imports
import 'team_builder.dart';
import '../../model/pokemon_team.dart';
import '../../../widgets/nodes/team_node.dart';
import '../../../widgets/buttons/gradient_button.dart';
import '../../../widgets/nodes/win_loss_node.dart';
import '../../modules/pogo_repository.dart';
import '../../app/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The battle log page for a single user team. From here, the user can add or
"log" opponent teams that they've encountered with their team. They can then
perform an analysis on any individual opponent team or a net analysis of all
logged opponenents associated with their team.
-------------------------------------------------------------------------------
*/

class BattleLog extends StatefulWidget {
  const BattleLog({
    super.key,
    required this.team,
  });

  final UserPokemonTeam team;

  @override
  State<BattleLog> createState() => _BattleLogState();
}

class _BattleLogState extends State<BattleLog> {
  late UserPokemonTeam _team = widget.team;

  // Build the app bar with the current page title, and icon
  AppBar _buildAppBar() {
    return AppBar(
      // Upon navigating back, return the updated team ref
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Battle Log',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          // Spacer
          SizedBox(
            width: Sizing.screenWidth(context) * .03,
          ),

          // Page icon
          const Icon(
            Icons.query_stats,
            size: Sizing.icon3,
          ),
        ],
      ),
    );
  }

  Widget _buildScaffoldBody() {
    return Padding(
      padding: Sizing.horizontalWindowInsets(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // The user's team
          _buildTeamNode(),

          // Spacer
          SizedBox(
            height: Sizing.screenHeight(context) * .02,
          ),

          Text(
            '- Opponent Teams -',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          // Spacer
          SizedBox(
            height: Sizing.screenHeight(context) * .02,
          ),

          // Logged opponent teams
          _buildOpponentsList(),
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
      emptyTransparent: true,
      collapsible: true,
      header: UserTeamNodeHeader(
        team: _team,
        onTagTeam: (_) {},
      ),
    );
  }

  // Build the list of TeamNodes, with the necessary callbacks
  Widget _buildOpponentsList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _team.getOpponents().length,
        itemBuilder: (context, index) {
          if (index == _team.getOpponents().length - 1) {
            return Column(
              children: [
                TeamNode(
                  onEmptyPressed: (nodeIndex) =>
                      _onEmptyPressed(index, nodeIndex),
                  onPressed: (_) {},
                  team: _team.getOpponents().elementAt(index),
                  footer: _buildTeamNodeFooter(index),
                ),
                SizedBox(
                  height: Sizing.screenHeight(context) * .10,
                ),
              ],
            );
          }

          return TeamNode(
            onEmptyPressed: (nodeIndex) => _onEmptyPressed(index, nodeIndex),
            onPressed: (_) {},
            team: _team.getOpponents().elementAt(index),
            footer: _buildTeamNodeFooter(index),
          );
        },
        physics: const BouncingScrollPhysics(),
      ),
    );
  }

  // The icon buttons at the footer of each TeamNode
  Widget _buildTeamNodeFooter(int teamIndex) {
    // Size of the footer icons
    final double iconSize = Sizing.screenWidth(context) * .06;

    // Provider retrieve
    final opponent = _team.getOpponents().elementAt(teamIndex);
    final IconData lockIcon = opponent.locked ? Icons.lock : Icons.lock_open;

    return Padding(
      padding: const EdgeInsets.only(
        right: 12.0,
        bottom: 12.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Remove team option if the team is unlocked
                opponent.locked
                    ? Container()
                    : IconButton(
                        onPressed: () => _onClearTeam(teamIndex),
                        icon: const Icon(Icons.clear),
                        tooltip: 'Remove Team',
                        iconSize: iconSize,
                        splashRadius: Sizing.screenWidth(context) * .05,
                      ),

                // Analyze team
                IconButton(
                  onPressed: () => _onAnalyzeLogTeam(teamIndex),
                  icon: const Icon(Icons.analytics),
                  tooltip: 'Analyze Team',
                  iconSize: iconSize,
                  splashRadius: Sizing.screenWidth(context) * .05,
                ),

                // Edit team
                IconButton(
                  onPressed: () => _onEditLogTeam(teamIndex),
                  icon: const Icon(Icons.build_circle),
                  tooltip: 'Edit Team',
                  iconSize: iconSize,
                  splashRadius: Sizing.screenWidth(context) * .05,
                ),

                // Lock team
                IconButton(
                  onPressed: () => _onLockPressed(teamIndex),
                  icon: Icon(lockIcon),
                  tooltip: 'Unlock Team',
                  iconSize: iconSize,
                  splashRadius: Sizing.screenWidth(context) * .05,
                ),
              ],
            ),
          ),

          // Win, tie, loss indicator
          WinLossNode(outcome: opponent.battleOutcome),
        ],
      ),
    );
  }

  // Build a log buttton, and if there are existing logs, also an analyze
  // button which will apply to all logged opponent teams.
  Widget _buildFloatingActionButtons() {
    // If logs are empty, then only give the option to add
    if (_team.getOpponents().isEmpty) {
      return GradientButton(
        onPressed: _onAddTeam,
        width: Sizing.screenWidth(context) * .85,
        height: Sizing.screenHeight(context) * .085,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Log Opponent Team  ',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Icon(
              Icons.add,
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Analyze button
        GradientButton(
          onPressed: _onAnalyzeLogs,
          width: Sizing.screenWidth(context) * .44,
          height: Sizing.screenHeight(context) * .085,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Analyze  ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Icon(
                Icons.analytics,
              ),
            ],
          ),
        ),

        // Log button
        GradientButton(
          onPressed: _onAddTeam,
          width: Sizing.screenWidth(context) * .44,
          height: Sizing.screenHeight(context) * .085,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Log  ',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Icon(
                Icons.add,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Remove the team at specified index
  void _onClearTeam(int teamIndex) {
    setState(() {
      PogoRepository.deleteOpponentPokemonTeam(
          _team.getOpponents().elementAt(teamIndex).id);
    });
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzeLogTeam(int teamIndex) {
    final opponent = _team.getOpponents().elementAt(teamIndex);

    // If the team is empty, no action will be taken
    if (opponent.isEmpty()) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return Analysis(
          team: _team,
          opponentTeam: opponent,
        );
      }),
    );
  }

  // Edit the team at specified index
  void _onEditLogTeam(int teamIndex) async {
    final opponent = _team.getOpponents().elementAt(teamIndex);

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return TeamBuilder(
          team: opponent,
          cup: opponent.getCup(),
          focusIndex: 0,
        );
      }),
    );

    setState(() {});
  }

  // Add a new empty team
  void _onAddTeam() async {
    OpponentPokemonTeam? opponent = OpponentPokemonTeam()
      ..dateCreated = DateTime.now().toUtc()
      ..cup = _team.getCup()
      ..tag = _team.getTag();
    PogoRepository.putPokemonTeam(opponent);

    opponent = await Navigator.push(
      context,
      MaterialPageRoute<OpponentPokemonTeam>(builder: (BuildContext context) {
        return TeamBuilder(
          team: opponent!,
          cup: _team.getCup(),
          focusIndex: 0,
        );
      }),
    );

    setState(() {
      if (opponent != null) {
        _team.opponents.add(opponent);
        PogoRepository.putPokemonTeam(_team);
      }
    });
  }

  // Wrapper for _onEditLogTeam
  void _onEmptyPressed(int teamIndex, int nodeIndex) async {
    PokemonTeam opponent = _team.getOpponents().elementAt(teamIndex);

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return TeamBuilder(
          team: opponent,
          cup: opponent.getCup(),
          focusIndex: nodeIndex,
        );
      }),
    );

    setState(() {});
  }

  void _onLockPressed(int teamIndex) {
    setState(() {
      final opponent = _team.getOpponents().elementAt(teamIndex);
      opponent.toggleLock();
      PogoRepository.putPokemonTeam(opponent);
    });
  }

  // Navigate to an analysis of all logged opponent teams
  void _onAnalyzeLogs() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return Analysis(
          team: _team,
          opponentTeams: _team.getOpponents().toList(),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _team = PogoRepository.getUserTeam(widget.team.id);
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildScaffoldBody(),

      // Log / Analyze opponent teams FABs
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
