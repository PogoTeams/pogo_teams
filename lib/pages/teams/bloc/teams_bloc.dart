import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pogo_teams/battle/battle_result.dart';
import 'package:pogo_teams/enums/battle_outcome.dart';
import 'package:pogo_teams/enums/rankings_categories.dart';
import 'package:pogo_teams/model/battle_pokemon.dart';
import 'package:pogo_teams/model/cup.dart';
import 'package:pogo_teams/model/pokemon.dart';
import 'package:pogo_teams/model/pokemon_team.dart';
import 'package:pogo_teams/model/pokemon_typing.dart';
import 'package:pogo_teams/model/tag.dart';
import 'package:pogo_teams/modules/pogo_repository.dart';
import 'package:pogo_teams/modules/pokemon_types.dart';
import 'package:pogo_teams/pages/analysis/analysis.dart';
import 'package:pogo_teams/pages/analysis/user_team_analysis.dart';
import 'package:pogo_teams/pages/teams/battle_log.dart';
import 'package:pogo_teams/pages/teams/tag_team.dart';
import 'package:pogo_teams/pages/teams/team_builder.dart';
import 'package:pogo_teams/ranker/pokemon_ranker.dart';
import 'package:pogo_teams/ranker/ranking_data.dart';
import 'package:pogo_teams/utils/async_state.dart';
import 'package:pogo_teams/utils/pair.dart';

part 'teams_event.dart';
part 'teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  TeamsBloc({
    required this.pogoRepository,
    required this.opponentTeams,
    PokemonTeam? selectedTeam,
  }) : super(
          TeamsState(
            pokemonTeams: [],
            selectedTeam: selectedTeam,
          ),
        ) {
    on<TeamsRequested>(_onTeamsLoaded);
    on<TeamDetailViewChanged>(_onTeamDetailViewChanged);
    on<TeamBuilderIndexChanged>(_onTeamBuilderIndexChanged);
    on<CupChanged>(_onCupChanged);
    on<TeamChanged>(_onTeamChanged);
    on<TeamSizeChanged>(_onTeamSizeChanged);
    on<BattleOutcomeChanged>(_onBattleOutcomeChanged);
    on<TagChanged>(_onTagChanged);
    on<TeamAdded>(_onTeamAdded);
    on<PokemonAddedToTeam>(_onPokemonAddedToTeam);
    on<TeamCleared>(_onTeamCleared);
    on<TeamTagged>(_onTeamTagged);
    on<TeamAnalyzed>(_onTeamAnalyzed);
    on<OpponentTeamLogged>(_onOpponentTeamLogged);
  }

  final PogoRepository pogoRepository;
  final bool opponentTeams;

  Future _onTeamsLoaded(TeamsRequested event, Emitter<TeamsState> emit) async {
    emit(
      state.copyWith(
        pokemonTeams: getTeams(),
      ),
    );
  }

  Future _onTeamDetailViewChanged(
      TeamDetailViewChanged event, Emitter<TeamsState> emit) async {
    if (event.teamDetailView == TeamDetailView.analysis) {
      add(TeamAnalyzed(team: event.selectedTeam));
    }

    emit(
      state.copyWith(
        teamDetailView: event.teamDetailView,
        selectedTeam: event.selectedTeam,
        builderIndex: event.builderIndex,
      ),
    );
  }

  void _onTeamBuilderIndexChanged(
      TeamBuilderIndexChanged event, Emitter<TeamsState> emit) {
    emit(
      state.copyWith(
        builderIndex: event.builderIndex,
      ),
    );
  }

  void _onCupChanged(CupChanged event, Emitter<TeamsState> emit) async {
    if (state.selectedTeam == null) return;

    state.selectedTeam!.setCup(event.cup);
    pogoRepository.putPokemonTeam(state.selectedTeam!);

    emit(
      state.copyWith(
        pokemonTeams: getTeams(),
      ),
    );
  }

  void _onTeamChanged(TeamChanged event, Emitter<TeamsState> emit) {
    if (state.selectedTeam == null) return;
    pogoRepository.putPokemonTeam(event.team!);

    emit(
      state.copyWith(
        pokemonTeams: getTeams(),
      ),
    );
  }

  void _onTeamSizeChanged(TeamSizeChanged event, Emitter<TeamsState> emit) {
    if (state.selectedTeam == null) return;
    state.selectedTeam!.setTeamSize(event.size);
    pogoRepository.putPokemonTeam(state.selectedTeam!);

    emit(
      state.copyWith(
        pokemonTeams: getTeams(),
      ),
    );
  }

  void _onBattleOutcomeChanged(
      BattleOutcomeChanged event, Emitter<TeamsState> emit) {
    if (state.selectedTeam == null ||
        state.selectedTeam!.runtimeType != OpponentPokemonTeam) return;
    (state.selectedTeam! as OpponentPokemonTeam).battleOutcome =
        event.battleOutcome;

    pogoRepository.putPokemonTeam(state.selectedTeam!);
    emit(
      state.copyWith(
        pokemonTeams: getTeams(),
      ),
    );
  }

  Future _onTagChanged(TagChanged event, Emitter<TeamsState> emit) async {
    emit(
      state.copyWith(
        pokemonTeams: pogoRepository.getUserTeams(tag: event.tag),
        selectedTag: event.tag,
      ),
    );
  }

  // Add a new empty team
  void _onTeamAdded(TeamAdded event, Emitter<TeamsState> emit) async {
    UserPokemonTeam newTeam =
        UserPokemonTeam(cup: pogoRepository.getCups().first)
          ..dateCreated = DateTime.now().toUtc();

    pogoRepository.putPokemonTeam(newTeam);

    emit(
      state.copyWith(
        pokemonTeams: pogoRepository.getUserTeams(),
        selectedTag: null,
        selectedTeam: newTeam,
        builderIndex: 0,
        teamDetailView: TeamDetailView.builder,
      ),
    );
  }

  Future _onPokemonAddedToTeam(
      PokemonAddedToTeam event, Emitter<TeamsState> emit) async {
    if (state.selectedTeam == null) return;
    state.selectedTeam!.setPokemonAt(
      state.builderIndex,
      UserPokemon.fromPokemon(event.pokemon),
    );

    pogoRepository.putPokemonTeam(state.selectedTeam!);

    emit(
      state.copyWith(
        builderIndex: state.builderIndex == state.selectedTeam!.teamSize - 1
            ? 0
            : state.builderIndex + 1,
        pokemonTeams: getTeams(),
      ),
    );
  }

  Future _onTeamTagged(TeamTagged event, Emitter<TeamsState> emit) async {
    event.userTeam.setTag(event.tag);
    pogoRepository.putPokemonTeam(event.userTeam);
    emit(
      state.copyWith(
        pokemonTeams: getTeams(),
      ),
    );
  }

  // Scroll to the analysis portion of the screen
  void _onTeamAnalyzed(TeamAnalyzed event, Emitter<TeamsState> emit) async {
    // If the team is empty, no action will be taken
    if (event.team.isEmpty()) return;

    emit(state.copyWith(
      analysisAsyncState: AsyncState.init,
    ));

    final List<Pair<PokemonType, double>> defenseThreats = [];
    final List<Pair<PokemonType, double>> offenseCoverage = [];
    final List<Pair<PokemonType, double>> netEffectiveness = [];
    final Map<int, RankingData> teamRankingData = {};
    final List<CupPokemon> leadThreats = [];
    final List<CupPokemon> overallThreats = [];

    _calculateSingleCoverage(
      event.team,
      defenseThreats,
      offenseCoverage,
      netEffectiveness,
    );

    _generateTeamRankings(
      event.team,
      teamRankingData,
      leadThreats,
      overallThreats,
    );

    emit(state.copyWith(
      analysisAsyncState: AsyncState.success(),
      defenseThreats: defenseThreats,
      offenseCoverage: offenseCoverage,
      netEffectiveness: netEffectiveness,
      teamRankingData: teamRankingData,
      leadThreats: leadThreats,
      overallThreats: overallThreats,
    ));
  }

  void _onOpponentTeamLogged(
      OpponentTeamLogged event, Emitter<TeamsState> emit) async {
    (event.pokemonTeam as UserPokemonTeam).opponents.add(event.opponentTeam);
    pogoRepository.putPokemonTeam(event.pokemonTeam);
    emit(
      state.copyWith(
        pokemonTeams: getTeams(),
      ),
    );
  }

  // Remove the team at specified index
  Future _onTeamCleared(TeamCleared event, Emitter<TeamsState> emit) async {
    if (event.pokemonTeam is UserPokemonTeam) {
      pogoRepository
          .deleteUserPokemonTeam(event.pokemonTeam as UserPokemonTeam);
    } else {
      pogoRepository
          .deleteOpponentPokemonTeam(event.pokemonTeam as OpponentPokemonTeam);
    }
    emit(
      state.copyWith(
        pokemonTeams: getTeams(),
      ),
    );
  }

  List<PokemonTeam> getTeams() {
    if (opponentTeams) {
      return pogoRepository.getOpponentTeams(tag: state.selectedTag);
    }

    return pogoRepository.getUserTeams(tag: state.selectedTag);
  }

  void _calculateSingleCoverage(
    PokemonTeam team,
    List<Pair<PokemonType, double>> defenseThreats,
    List<Pair<PokemonType, double>> offenseCoverage,
    List<Pair<PokemonType, double>> netEffectiveness,
  ) {
    final List<UserPokemon> pokemonTeam = team.getNonNullPokemonList();
    final List<double> effectiveness = team.getTeamTypeffectiveness();
    final List<String> includedTypesKeys = team.cup.includedTypeKeys();

    // Get coverage lists
    final defense =
        PokemonTypes.getDefenseCoverage(effectiveness, includedTypesKeys);

    final offense =
        PokemonTypes.getOffenseCoverage(pokemonTeam, includedTypesKeys);

    // Get an overall effectiveness for the bar graph display
    netEffectiveness.addAll(
      PokemonTypes.getMovesWeightedEffectiveness(
        defense,
        offense,
        includedTypesKeys,
      ),
    );

    if (team.teamSize > 3) {
      int teamLengthFactor = team.teamSize ~/ 3;
      if (teamLengthFactor > 0) {
        for (var pair in netEffectiveness) {
          pair.b / teamLengthFactor;
        }
      }
    }

    // Sort the coveraages from high to low
    defense.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());
    offense.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());

    // If the team technically has no vulnerabilities, bump up a few
    // This is possible in certain type excluding cups
    if (defense.first.b <= pokemonTeam.length) {
      defense.first.b += pokemonTeam.length;

      int n = includedTypesKeys.length ~/ 3;
      for (int i = 1; i < n; ++i) {
        defense[i].b += pokemonTeam.length;
      }
    }

    // Filter to the key values
    defenseThreats.addAll(defense.where((pair) => pair.b > pokemonTeam.length));

    offenseCoverage
        .addAll(offense.where((pair) => pair.b > pokemonTeam.length));

    // Remove any threats that are covered offensively
    for (var offCoverage in offenseCoverage) {
      int i =
          defenseThreats.indexWhere((pair) => pair.a.isSameType(offCoverage.a));

      if (i != -1 && i < defenseThreats.length) {
        defenseThreats.removeAt(i);
      }
    }

    // Scale effectiveness to non-effectiveness
    // TBH, this is convoluted, but hey it works...
    // The big complication is the net coverage of all logged opponents also
    // uses this abstraction.
    final double teamLength = pokemonTeam.length * PokemonTypes.notEffective;
    void scaleEffectiveness(typeData) => typeData.b *= teamLength;
    netEffectiveness.forEach(scaleEffectiveness);
  }

  // For the logged opponent teams, calculate the net coverage
  void _calculateNetCoverage(
    List<PokemonTeam> teams,
    List<String> includedTypesKeys,
  ) {
    // The count of individually logged Pokemon in all the logs
    double loggedPokemonCount = 0;

    // Generate the coverage lists, gien the included typing for a given cup
    var defenseThreats =
        PokemonTypes.generateTypeValuePairedList(includedTypesKeys);
    var offenseCoverage =
        PokemonTypes.generateTypeValuePairedList(includedTypesKeys);
    var netEffectiveness =
        PokemonTypes.generateTypeValuePairedList(includedTypesKeys);

    // Foreach callback
    // Get the effectiveness of a single log, and accumulate it to the coverage
    void accumulateLog(PokemonTeam team) {
      final List<UserPokemon> pokemonTeam = team.getNonNullPokemonList();
      loggedPokemonCount += pokemonTeam.length;

      // Get coverage lists
      final defense = PokemonTypes.getDefenseCoverage(
          team.getTeamTypeffectiveness(), includedTypesKeys);
      final offense =
          PokemonTypes.getOffenseCoverage(pokemonTeam, includedTypesKeys);

      List<Pair<PokemonType, double>> logEffectiveness =
          PokemonTypes.getMovesWeightedEffectiveness(
        defense,
        offense,
        includedTypesKeys,
      );

      for (int i = 0; i < logEffectiveness.length; ++i) {
        defenseThreats[i].b += defense[i].b;
        offenseCoverage[i].b += offense[i].b;
        netEffectiveness[i].b += logEffectiveness[i].b;
      }
    }

    teams.forEach(accumulateLog);

    // Filter to the key values
    defenseThreats = defenseThreats
        .where((typeData) => typeData.b > loggedPokemonCount)
        .toList();

    offenseCoverage =
        offenseCoverage.where((pair) => pair.b > loggedPokemonCount).toList();

    // Sort with highest effectiveness values first
    defenseThreats.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());
    offenseCoverage.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());

    if (defenseThreats.first.b <= loggedPokemonCount) {
      defenseThreats.first.b += loggedPokemonCount;

      int n = defenseThreats.length ~/ 3;
      for (int i = 1; i < n; ++i) {
        defenseThreats[i].b += loggedPokemonCount;
      }
    }

    // Scale effectiveness to the total logged Pokemon
    loggedPokemonCount /= state.selectedTeam!.getNonNullPokemonList().length;
    void scaleEffectiveness(typeData) => typeData.b /= loggedPokemonCount;
    netEffectiveness.forEach(scaleEffectiveness);
  }

  Future _generateTeamRankings(
    PokemonTeam team,
    Map<int, RankingData> teamRankingData,
    List<CupPokemon> leadThreats,
    List<CupPokemon> overallThreats,
  ) async {
    List<CupPokemon> opponents = pogoRepository.getCupPokemon(
      state.selectedTeam!.cup,
      PokemonTypes.typeList,
      RankingsCategories.overall,
      limit: 100,
    );

    List<BattleResult> losses = [];

    // Simulate battles against the top meta for this cup
    for (UserPokemon pokemon in team.getNonNullPokemonList()) {
      BattlePokemon battlePokemon =
          await BattlePokemon.fromPokemonAsync(await pokemon.getBaseAsync())
            ..selectedBattleFastMove = await pokemon.getSelectedFastMoveAsync()
            ..selectedBattleChargeMoves =
                await pokemon.getSelectedChargeMovesAsync();

      battlePokemon.initializeStats(team.cup.cp);

      int pokemonIndex = pokemon.teamIndex ?? -1;
      if (pokemonIndex != -1) {
        teamRankingData[pokemon.teamIndex ?? 0] = await PokemonRanker.rankApp(
          battlePokemon,
          team.cup,
          opponents,
        );

        // Accumulate lead outcomes
        int len =
            min(10, teamRankingData[pokemonIndex]!.leadOutcomes!.losses.length);
        losses.addAll(teamRankingData[pokemonIndex]!
            .leadOutcomes!
            .losses
            .getRange(0, len));

        // Accumulate switch outcomes
        len = min(
            10, teamRankingData[pokemonIndex]!.switchOutcomes!.losses.length);
        losses.addAll(teamRankingData[pokemonIndex]!
            .switchOutcomes!
            .losses
            .getRange(0, len));

        // Accumulate closer outcomes
        len = min(
            10, teamRankingData[pokemonIndex]!.closerOutcomes!.losses.length);
        losses.addAll(teamRankingData[pokemonIndex]!
            .closerOutcomes!
            .losses
            .getRange(0, len));
      }
    }

    losses.sort((loss1, loss2) =>
        loss2.opponent.currentRating > loss1.opponent.currentRating ? -1 : 1);

    for (BattleResult loss in losses) {
      // Avoid adding duplicate Pokemon
      if (-1 ==
          overallThreats.indexWhere((threat) =>
              threat.getBase().pokemonId == loss.opponent.pokemonId)) {
        overallThreats.add(CupPokemon.fromBattlePokemon(
          loss.opponent,
          pogoRepository.getPokemonById(loss.opponent.pokemonId),
        ));
      }

      if (overallThreats.length == 20) break;
    }

    // If the user's team has a lead Pokemon
    if (teamRankingData.containsKey(0)) {
      List<BattleResult> leadLosses = teamRankingData[0]!.leadOutcomes!.losses;
      // Scale opponent's outcome rating to it's rating against the meta.
      /*
      for (BattleResult result in leadLosses) {
        int i = opponents.indexWhere((pokemon) =>
            pokemon.getBase().pokemonId == result.opponent.pokemonId);
        if (i == -1) {
          result.opponent.currentRating = 0;
        } else {
          result.opponent.currentRating *= opponents[i].ratings.lead;
        }
      }

      // Resort the losses after scaling
      leadLosses.sort((r1, r2) =>
          (r2.opponent.currentRating > r1.opponent.currentRating ? -1 : 1));
          */

      int len = min(leadLosses.length, 20);
      for (BattleResult result in leadLosses.getRange(0, len)) {
        leadThreats.add(CupPokemon.fromBattlePokemon(
          result.opponent,
          pogoRepository.getPokemonById(result.opponent.pokemonId),
        ));
      }
    }
  }
}
