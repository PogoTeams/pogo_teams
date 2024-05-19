import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pogo_teams/enums/battle_outcome.dart';
import 'package:pogo_teams/model/cup.dart';
import 'package:pogo_teams/model/pokemon.dart';
import 'package:pogo_teams/model/pokemon_team.dart';
import 'package:pogo_teams/model/tag.dart';
import 'package:pogo_teams/modules/pogo_repository.dart';
import 'package:pogo_teams/pages/analysis/analysis.dart';
import 'package:pogo_teams/pages/analysis/user_team_analysis.dart';
import 'package:pogo_teams/pages/teams/battle_log.dart';
import 'package:pogo_teams/pages/teams/tag_team.dart';
import 'package:pogo_teams/pages/teams/team_builder.dart';

part 'teams_event.dart';
part 'teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  TeamsBloc({
    required this.pogoRepository,
    required this.opponentTeams,
  }) : super(
          const TeamsState(
            pokemonTeams: [],
          ),
        ) {
    on<TeamsLoaded>(_onTeamsLoaded);
    on<TeamDetailViewChanged>(_onTeamDetailViewChanged);
    on<TeamBuilderIndexChanged>(_onTeamBuilderIndexChanged);
    on<CupChanged>(_onCupChanged);
    on<TeamSizeChanged>(_onTeamSizeChanged);
    on<BattleOutcomeChanged>(_onBattleOutcomeChanged);
    on<TagChanged>(_onTagChanged);
    on<TeamAdded>(_onTeamAdded);
    on<TeamChanged>(_onTeamChanged);
    on<TeamCleared>(_onTeamCleared);
    on<TeamTagged>(_onTeamTagged);
    on<TeamAnalyzed>(_onTeamAnalyzed);
    on<OpponentTeamLogged>(_onOpponentTeamLogged);
  }

  final PogoRepository pogoRepository;
  final bool opponentTeams;

  Future _onTeamsLoaded(TeamsLoaded event, Emitter<TeamsState> emit) async {
    emit(
      TeamsState(
        pokemonTeams: getTeams(),
      ),
    );
  }

  Future _onTeamDetailViewChanged(
      TeamDetailViewChanged event, Emitter<TeamsState> emit) async {
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
      TeamsState(
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

  Future _onTeamChanged(TeamChanged event, Emitter<TeamsState> emit) async {
    pogoRepository.putPokemonTeam(event.userTeam);

    emit(
      TeamsState(
        pokemonTeams: getTeams(),
      ),
    );
  }

  Future _onTeamTagged(TeamTagged event, Emitter<TeamsState> emit) async {
    event.userTeam.setTag(event.tag);
    pogoRepository.putPokemonTeam(event.userTeam);
    emit(
      TeamsState(
        pokemonTeams: getTeams(),
      ),
    );
  }

  // Scroll to the analysis portion of the screen
  void _onTeamAnalyzed(TeamAnalyzed event, Emitter<TeamsState> emit) async {
    // If the team is empty, no action will be taken
    if (event.userTeam.isEmpty()) return;

    // TODO: Analysis logic
  }

  void _onOpponentTeamLogged(
      OpponentTeamLogged event, Emitter<TeamsState> emit) async {
    event.userTeam.opponents.add(event.opponentTeam);
    pogoRepository.putPokemonTeam(event.userTeam);
    emit(
      TeamsState(
        pokemonTeams: getTeams(),
      ),
    );
  }

  // Remove the team at specified index
  Future _onTeamCleared(TeamCleared event, Emitter<TeamsState> emit) async {
    pogoRepository.deleteUserPokemonTeam(event.userTeam);
    emit(
      TeamsState(
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
}
