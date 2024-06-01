part of 'teams_bloc.dart';

sealed class TeamsEvent extends Equatable {
  const TeamsEvent();
}

class TeamsLoaded extends TeamsEvent {
  const TeamsLoaded({
    required this.userPokemonTeams,
  });

  final List<UserPokemonTeam> userPokemonTeams;

  @override
  List<Object?> get props => [userPokemonTeams];
}

class TeamDetailViewChanged extends TeamsEvent {
  const TeamDetailViewChanged({
    required this.teamDetailView,
    required this.selectedTeam,
    this.builderIndex = 0,
  });

  final TeamDetailView teamDetailView;
  final UserPokemonTeam selectedTeam;
  final int builderIndex;

  @override
  List<Object?> get props => [
        teamDetailView,
        selectedTeam,
        builderIndex,
      ];
}

class TeamBuilderIndexChanged extends TeamsEvent {
  const TeamBuilderIndexChanged({
    required this.builderIndex,
  });

  final int builderIndex;
  @override
  List<Object?> get props => [builderIndex];
}

class TagChanged extends TeamsEvent {
  const TagChanged({required this.tag});

  final Tag? tag;

  @override
  List<Object?> get props => [tag];
}

class TeamAdded extends TeamsEvent {
  @override
  List<Object?> get props => [];
}

class TeamChanged extends TeamsEvent {
  const TeamChanged({
    required this.userTeam,
  });

  final UserPokemonTeam userTeam;

  @override
  List<Object?> get props => [userTeam];
}

class CupChanged extends TeamsEvent {
  const CupChanged({
    required this.cup,
  });

  final Cup cup;

  @override
  List<Object?> get props => [cup];
}

class TeamSizeChanged extends TeamsEvent {
  const TeamSizeChanged({
    required this.size,
  });

  final int size;

  @override
  List<Object?> get props => [size];
}

class BattleOutcomeChanged extends TeamsEvent {
  const BattleOutcomeChanged({
    required this.battleOutcome,
  });

  final BattleOutcome battleOutcome;

  @override
  List<Object?> get props => [battleOutcome];
}

class TeamTagged extends TeamsEvent {
  const TeamTagged({
    required this.userTeam,
    required this.tag,
  });

  final UserPokemonTeam userTeam;
  final Tag tag;

  @override
  List<Object?> get props => [userTeam, tag];
}

class TeamAnalyzed extends TeamsEvent {
  const TeamAnalyzed({
    required this.userTeam,
  });

  final UserPokemonTeam userTeam;

  @override
  List<Object?> get props => [userTeam];
}

class OpponentTeamLogged extends TeamsEvent {
  const OpponentTeamLogged({
    required this.userTeam,
    required this.opponentTeam,
  });

  final UserPokemonTeam userTeam;
  final OpponentPokemonTeam opponentTeam;

  @override
  List<Object?> get props => [userTeam, opponentTeam];
}

class TeamCleared extends TeamsEvent {
  const TeamCleared({
    required this.userTeam,
  });

  final UserPokemonTeam userTeam;

  @override
  List<Object?> get props => [userTeam];
}
