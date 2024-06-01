// Dart
import 'dart:ui';

// Packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local
import '../../pages/teams/battle_log.dart';
import '../../pages/teams/team_edit.dart';
import '../../pages/teams/team_builder.dart';
import '../../pages/teams/tag_team.dart';
import '../../pages/analysis/analysis.dart';
import '../../widgets/nodes/team_node.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/buttons/tag_filter_button.dart';
import '../ui/sizing.dart';
import '../../model/pokemon_team.dart';
import '../../model/tag.dart';
import '../../modules/pogo_repository.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A list view of all the user created teams. The user can create, edit, and
delete teams from here.
-------------------------------------------------------------------------------
*/

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
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
          return Padding(
            padding:
                EdgeInsets.only(bottom: Sizing.screenHeight(context) * .11),
            child: _buildTeamNode(_teams[index]),
          );
        }

        return _buildTeamNode(_teams[index]);
      },
      physics: const BouncingScrollPhysics(),
    );
  }

  Widget _buildTeamNode(UserPokemonTeam team) {
    return TeamNode(
      onEmptyPressed: (nodeIndex) => _onEmptyPressed(team, nodeIndex),
      onPressed: (_) => _onEditTeam(context, team),
      team: team,
      header: UserTeamNodeHeader(
        team: team,
        onTagTeam: _onTagTeam,
      ),
      footer: UserTeamNodeFooter(
        team: team,
        onClear: _onClearTeam,
        onBuild: _onBuildTeam,
        onTag: _onTagTeam,
        onLog: _onLogTeam,
        onLock: _onLockTeam,
        onAnalyze: _onAnalyzeTeam,
      ),
    );
  }

  // Remove the team at specified index
  void _onClearTeam(UserPokemonTeam team) {
    setState(() {
      context.read<PogoRepository>().deleteUserPokemonTeam(team);
    });
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzeTeam(UserPokemonTeam team) async {
    // If the team is empty, no action will be taken
    if (team.isEmpty()) return;

    await Navigator.push(
      context,
      MaterialPageRoute<bool>(builder: (BuildContext context) {
        return Analysis(team: team);
      }),
    );

    setState(() {});
  }

  void _onLogTeam(UserPokemonTeam team) async {
    await Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => BattleLog(
          team: team,
        ),
      ),
    );

    setState(() {});
  }

  void _onTagTeam(UserPokemonTeam team) async {
    final selectedTag = await showDialog<Tag>(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            insetPadding: EdgeInsets.only(
              left: Sizing.screenWidth(context) * .02,
              right: Sizing.screenWidth(context) * .02,
            ),
            backgroundColor: Colors.transparent,
            child: TagTeam(
              team: team,
            ),
          ),
        );
      },
    );

    if (selectedTag != null) {
      setState(() {
        team.setTag(selectedTag);
        context.read<PogoRepository>().putPokemonTeam(team);
      });
    }
  }

  // Edit the team at specified index
  void _onBuildTeam(UserPokemonTeam team) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TeamBuilder(
          team: team,
          cup: team.getCup(),
          focusIndex: 0,
        ),
      ),
    );

    setState(() {});
  }

  void _onEditTeam(BuildContext context, UserPokemonTeam team) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            child: TeamEdit(
              team: team,
            ),
          ),
        );
      },
    );

    setState(() {});
  }

  // On locking a team, the clear option is removed
  void _onLockTeam(UserPokemonTeam team) {
    setState(() {
      team.toggleLock();
      context.read<PogoRepository>().putPokemonTeam(team);
    });
  }

  // Add a new empty team
  void _onAddTeam() async {
    UserPokemonTeam newTeam =
        UserPokemonTeam(cup: context.read<PogoRepository>().getCups().first)
          ..dateCreated = DateTime.now().toUtc();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TeamBuilder(
          team: newTeam,
          cup: newTeam.getCup(),
          focusIndex: 0,
        ),
      ),
    );
    setState(() {});
  }

  // Navigate to the team build search page, with focus on the specified
  // nodeIndex
  void _onEmptyPressed(UserPokemonTeam team, int nodeIndex) async {
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
    final isExpanded = Sizing.isExpanded(context);
    _teams = context.read<PogoRepository>().getUserTeams(tag: _selectedTag);

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: Scaffold(
              body: _buildTeamsList(context),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: GradientButton(
                      onPressed: _onAddTeam,
                      width: double.infinity,
                      height: Sizing.fabLargeHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add Team  ',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Icon(
                            Icons.add,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Sizing.paneSpacer,
                  TagFilterButton(
                    tag: _selectedTag,
                    onTagChanged: _onTagChanged,
                    width: Sizing.fabLargeHeight,
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            ),
          ),
          if (isExpanded)
            // TODO: Detail View
            Flexible(flex: 1, child: Container()),
        ],
      ),
    );
  }
}
