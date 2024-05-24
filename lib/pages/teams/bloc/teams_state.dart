part of 'teams_bloc.dart';

enum TeamDetailView {
  none(),
  builder(),
  tag(),
  analysis(),
  battleLogs();

  Widget view() {
    switch (this) {
      case none:
        return Container();
      case builder:
        return const TeamBuilder();
      case tag:
        return const TagTeam();
      case analysis:
        return const Analysis();
      case battleLogs:
        return const BattleLog();
    }
  }
}

class TeamsState extends Equatable {
  const TeamsState({
    required this.pokemonTeams,
    this.selectedTeam,
    this.selectedTag,
    this.builderIndex = 0,
    this.teamDetailView = TeamDetailView.none,
    this.analysisAsyncState = AsyncState.init,
    this.defenseThreats,
    this.offenseCoverage,
    this.netEffectiveness,
    this.teamRankingData,
    this.leadThreats,
    this.overallThreats,
  });

  final List<PokemonTeam> pokemonTeams;
  final PokemonTeam? selectedTeam;
  final Tag? selectedTag;
  final int builderIndex;
  final TeamDetailView teamDetailView;

  final AsyncState analysisAsyncState;
  final List<Pair<PokemonType, double>>? defenseThreats;
  final List<Pair<PokemonType, double>>? offenseCoverage;
  final List<Pair<PokemonType, double>>? netEffectiveness;
  final Map<int, RankingData>? teamRankingData;
  final List<CupPokemon>? leadThreats;
  final List<CupPokemon>? overallThreats;

  @override
  List<Object?> get props => [
        pokemonTeams,
        selectedTeam,
        selectedTag,
        builderIndex,
        teamDetailView,
        analysisAsyncState,
        defenseThreats,
        offenseCoverage,
        netEffectiveness,
        teamRankingData,
        leadThreats,
        overallThreats,
      ];

  TeamsState copyWith({
    List<PokemonTeam>? pokemonTeams,
    PokemonTeam? selectedTeam,
    Tag? selectedTag,
    int? builderIndex,
    TeamDetailView? teamDetailView,
    AsyncState? analysisAsyncState,
    List<Pair<PokemonType, double>>? defenseThreats,
    List<Pair<PokemonType, double>>? offenseCoverage,
    List<Pair<PokemonType, double>>? netEffectiveness,
    Map<int, RankingData>? teamRankingData,
    List<CupPokemon>? leadThreats,
    List<CupPokemon>? overallThreats,
  }) =>
      TeamsState(
        pokemonTeams: pokemonTeams ?? this.pokemonTeams,
        selectedTeam: selectedTeam ?? this.selectedTeam,
        selectedTag: selectedTag ?? this.selectedTag,
        builderIndex: builderIndex ?? this.builderIndex,
        teamDetailView: teamDetailView ?? this.teamDetailView,
        analysisAsyncState: analysisAsyncState ?? this.analysisAsyncState,
        defenseThreats: defenseThreats ?? this.defenseThreats,
        offenseCoverage: offenseCoverage ?? this.offenseCoverage,
        netEffectiveness: netEffectiveness ?? this.netEffectiveness,
        teamRankingData: teamRankingData ?? this.teamRankingData,
        leadThreats: leadThreats ?? this.leadThreats,
        overallThreats: overallThreats ?? this.overallThreats,
      );
}
