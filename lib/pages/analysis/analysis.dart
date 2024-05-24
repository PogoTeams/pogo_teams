// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pogo_teams/pages/teams/bloc/teams_bloc.dart';

// Local Imports
import 'user_team_analysis.dart';
import '../../model/pokemon_team.dart';

/*
-------------------------------------------------------------------- @PogoTeams
An analysis page that will generate different results, given the provided
team(s). This widget is used to branch unique analysis pages for a :

- user team
- opponent team
- logged opponent teams
-------------------------------------------------------------------------------
*/

class Analysis extends StatelessWidget {
  const Analysis({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsBloc, TeamsState>(builder: (context, state) {
      if (state.selectedTeam == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.selectedTeam! is UserPokemonTeam) {
        return const UserTeamAnalysis();
      } else if (state.selectedTeam! is OpponentPokemonTeam) {
        return Container();
      }
      return Container();
    });
  }
}
