part of 'teams_bloc.dart';

enum TeamDetailView {
  none(),
  builder(view: TeamBuilder()),
  tag(view: TagTeam()),
  analysis(view: Analysis()),
  battleLogs(view: BattleLog());

  const TeamDetailView({
    this.view,
  });

  final Widget? view;
}

class TeamsState extends Equatable {
  const TeamsState({
    required this.pokemonTeams,
    this.selectedTeam,
    this.selectedTag,
    this.builderIndex = 0,
    this.teamDetailView = TeamDetailView.none,
  });

  final List<PokemonTeam> pokemonTeams;
  final PokemonTeam? selectedTeam;
  final Tag? selectedTag;
  final int builderIndex;
  final TeamDetailView teamDetailView;

  @override
  List<Object?> get props => [
        pokemonTeams,
        selectedTeam,
        selectedTag,
        builderIndex,
        teamDetailView,
      ];

  TeamsState copyWith({
    List<PokemonTeam>? pokemonTeams,
    PokemonTeam? selectedTeam,
    Tag? selectedTag,
    int? builderIndex,
    TeamDetailView? teamDetailView,
  }) =>
      TeamsState(
        pokemonTeams: pokemonTeams ?? this.pokemonTeams,
        selectedTeam: selectedTeam ?? this.selectedTeam,
        selectedTag: selectedTag ?? this.selectedTag,
        builderIndex: builderIndex ?? this.builderIndex,
        teamDetailView: teamDetailView ?? this.teamDetailView,
      );
}
