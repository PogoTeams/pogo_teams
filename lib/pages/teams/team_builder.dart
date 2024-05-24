// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pogo_teams/app/pogo_scaffold/bloc/pogo_scaffold_bloc.dart';
import 'package:pogo_teams/pages/teams/bloc/teams_bloc.dart';
import 'package:pogo_teams/widgets/pokemon_list/bloc/pokemon_list_bloc.dart';

// Local Imports
import '../../model/pokemon.dart';
import '../../model/pokemon_team.dart';
import '../../model/cup.dart';
import '../../modules/pogo_repository.dart';
import '../../app/ui/sizing.dart';
import '../../widgets/pokemon_list/pokemon_list.dart';
import '../../widgets/pogo_text_field.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/dropdowns/cup_dropdown.dart';
import '../../widgets/dropdowns/team_size_dropdown.dart';
import '../../widgets/dropdowns/win_loss_dropdown.dart';
import '../../widgets/buttons/rankings_category_button.dart';
import '../../widgets/nodes/team_node.dart';
import '../../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A search and build page, where the team being edited is rendered as a grid
above a searchable / filterable list of Pokemon. The user can press on any
node in the grid to put focus on that node for adding a Pokemon. 
-------------------------------------------------------------------------------
*/

class TeamBuilder extends StatelessWidget {
  const TeamBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = Sizing.isExpanded(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: Sizing.horizontalWindowInsets(context),
          child: BlocBuilder<TeamsBloc, TeamsState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isExpanded) _TeamNode(),
                  Sizing.listItemSpacer,
                  const Expanded(
                    child: PokemonList(dropdowns: true),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: isExpanded
          ? null
          : GradientButton(
              onPressed: () {
                Navigator.pop(context);
              },
              width: Sizing.screenWidth(context) * .85,
              height: Sizing.screenHeight(context) * .085,
              child: const Icon(
                Icons.clear,
                size: Sizing.icon2,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _TeamNode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsBloc, TeamsState>(
      builder: (context, state) {
        return TeamNode(
          focusIndex: state.builderIndex,
          onEmptyPressed: (nodeIndex) => context.read<TeamsBloc>().add(
                TeamBuilderIndexChanged(
                  builderIndex: nodeIndex,
                ),
              ),
          onPressed: (nodeIndex) => context.read<TeamsBloc>().add(
                TeamBuilderIndexChanged(
                  builderIndex: nodeIndex,
                ),
              ),
          team: state.selectedTeam!,
          header: state.selectedTeam!.runtimeType == UserPokemonTeam
              ? UserTeamNodeHeader(
                  team: state.selectedTeam! as UserPokemonTeam,
                  onTagTeam: (_) {}, //_onTagTeam,
                )
              : null,
          footer: state.selectedTeam!.runtimeType == OpponentPokemonTeam
              ? WinLossDropdown(
                  selectedOption:
                      (state.selectedTeam as OpponentPokemonTeam).battleOutcome,
                  onChanged: (battleOutcome) {
                    if (battleOutcome != null) {
                      context.read<TeamsBloc>().add(
                            BattleOutcomeChanged(
                              battleOutcome: battleOutcome,
                            ),
                          );
                    }
                  },
                  width: Sizing.screenWidth(context),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dropdown for pvp cup selection
                    Flexible(
                      flex: 5,
                      child: CupDropdown(
                        cup: state.selectedTeam!.cup,
                        onCupChanged: (cup) {
                          if (cup != null) {
                            context.read<TeamsBloc>().add(
                                  CupChanged(
                                    cup: cup,
                                  ),
                                );
                          }
                        },
                      ),
                    ),

                    Sizing.paneSpacer,

                    // Dropdown to select team size
                    Flexible(
                      flex: 2,
                      child: TeamSizeDropdown(
                        size: state.selectedTeam!.teamSize,
                        onTeamSizeChanged: (size) {
                          if (size != null) {
                            context.read<TeamsBloc>().add(
                                  TeamSizeChanged(
                                    size: size,
                                  ),
                                );
                          }
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
