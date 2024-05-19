// Dart
import 'dart:ui';

// Packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pogo_teams/pages/teams/bloc/teams_bloc.dart';

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

class Teams extends StatelessWidget {
  const Teams({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamsBloc(
        pogoRepository: context.read<PogoRepository>(),
        opponentTeams: false,
      ),
      child: _TeamsView(),
    );
  }
}

class _TeamsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isExpanded = Sizing.isExpanded(context);
    return BlocConsumer<TeamsBloc, TeamsState>(
      listenWhen: (previous, current) =>
          !isExpanded && previous.teamDetailView != current.teamDetailView,
      listener: (context, state) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => state.teamDetailView.view!,
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 1,
                child: Scaffold(
                  body: _TeamsListView(),
                  floatingActionButton: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: GradientButton(
                          onPressed: () =>
                              context.read<TeamsBloc>().add(TeamAdded()),
                          width: double.infinity,
                          height: Sizing.fabLargeHeight,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  'Add Team  ',
                                ),
                              ),
                              Icon(
                                Icons.add,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Sizing.paneSpacer,
                      TagFilterButton(
                        tag: state.selectedTag,
                        onTagChanged: (tag) =>
                            context.read<TeamsBloc>().add(TagChanged(tag: tag)),
                        width: Sizing.fabLargeHeight,
                      ),
                    ],
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                ),
              ),
              if (isExpanded && state.teamDetailView.view != null)
                Flexible(
                  flex: 1,
                  child: state.teamDetailView.view!,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TeamsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsBloc, TeamsState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.pokemonTeams.length,
          itemBuilder: (context, index) {
            final team = state.pokemonTeams[index] as UserPokemonTeam;
            return Padding(
              padding: index == state.pokemonTeams.length - 1
                  ? EdgeInsets.only(bottom: Sizing.screenHeight(context) * .11)
                  : EdgeInsets.zero,
              child: TeamNode(
                onEmptyPressed: (nodeIndex) => context.read<TeamsBloc>().add(
                      TeamDetailViewChanged(
                        teamDetailView: TeamDetailView.builder,
                        selectedTeam: team,
                        builderIndex: nodeIndex,
                      ),
                    ),
                onPressed: (nodeIndex) => context.read<TeamsBloc>().add(
                      TeamDetailViewChanged(
                        teamDetailView: TeamDetailView.builder,
                        selectedTeam: team,
                        builderIndex: nodeIndex,
                      ),
                    ),
                team: team,
                header: UserTeamNodeHeader(
                  team: team,
                  onTagTeam: (_) {}, //_onTagTeam,
                ),
                footer: UserTeamNodeFooter(
                  team: team,
                  onClear: (_) => context.read<TeamsBloc>().add(TeamCleared(
                        userTeam: team,
                      )),
                  onBuild: (_) => context.read<TeamsBloc>().add(
                        TeamDetailViewChanged(
                          teamDetailView: TeamDetailView.builder,
                          selectedTeam: team,
                        ),
                      ),
                  onTag: (_) => context.read<TeamsBloc>().add(
                        TeamDetailViewChanged(
                          teamDetailView: TeamDetailView.tag,
                          selectedTeam: team,
                        ),
                      ),
                  onLog: (_) => context.read<TeamsBloc>().add(
                        TeamDetailViewChanged(
                          teamDetailView: TeamDetailView.battleLogs,
                          selectedTeam: team,
                        ),
                      ),
                  onAnalyze: (_) => context.read<TeamsBloc>().add(
                        TeamDetailViewChanged(
                          teamDetailView: TeamDetailView.analysis,
                          selectedTeam: team,
                        ),
                      ),
                  onLock: (_) {}, //_onLockTeam,
                ),
              ),
            );
          },
          physics: const BouncingScrollPhysics(),
        );
      },
    );
  }
}
