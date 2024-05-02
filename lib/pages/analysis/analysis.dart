// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'user_team_analysis.dart';
import 'opponent_team_analysis.dart';
import 'logs_analysis.dart';
import '../../model/pokemon.dart';
import '../../model/pokemon_team.dart';
import '../../model/pokemon_typing.dart';
import '../../modules/pokemon_types.dart';
import '../../utils/pair.dart';
import '../../modules/pogo_repository.dart';

/*
-------------------------------------------------------------------- @PogoTeams
An analysis page that will generate different results, given the provided
team(s). This widget is used to branch unique analysis pages for a :

- user team
- opponent team
- logged opponent teams
-------------------------------------------------------------------------------
*/

class Analysis extends StatefulWidget {
  const Analysis({
    super.key,
    required this.team,
    this.opponentTeam,
    this.opponentTeams,
  });

  final UserPokemonTeam team;
  final OpponentPokemonTeam? opponentTeam;
  final List<OpponentPokemonTeam>? opponentTeams;

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  late UserPokemonTeam _team = widget.team;

  List<Pair<PokemonType, double>> defenseThreats = [];
  List<Pair<PokemonType, double>> offenseCoverage = [];
  List<Pair<PokemonType, double>> netEffectiveness = [];

  final ScrollController _scrollController = ScrollController();

  void _calculateSingleCoverage(
    List<UserPokemon> pokemonTeam,
    List<double> effectiveness,
    List<String> includedTypesKeys,
  ) {
    // Get coverage lists
    final defense =
        PokemonTypes.getDefenseCoverage(effectiveness, includedTypesKeys);

    final offense =
        PokemonTypes.getOffenseCoverage(pokemonTeam, includedTypesKeys);

    // Get an overall effectiveness for the bar graph display
    netEffectiveness = PokemonTypes.getMovesWeightedEffectiveness(
      defense,
      offense,
      includedTypesKeys,
    );

    if (_team.teamSize > 3) {
      int teamLengthFactor = _team.teamSize ~/ 3;
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
    defenseThreats =
        defense.where((pair) => pair.b > pokemonTeam.length).toList();

    offenseCoverage =
        offense.where((pair) => pair.b > pokemonTeam.length).toList();

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
    List<OpponentPokemonTeam> opponents,
    List<String> includedTypesKeys,
  ) {
    // The count of individually logged Pokemon in all the logs
    double loggedPokemonCount = 0;

    // Generate the coverage lists, gien the included typing for a given cup
    defenseThreats =
        PokemonTypes.generateTypeValuePairedList(includedTypesKeys);
    offenseCoverage =
        PokemonTypes.generateTypeValuePairedList(includedTypesKeys);
    netEffectiveness =
        PokemonTypes.generateTypeValuePairedList(includedTypesKeys);

    // Foreach callback
    // Get the effectiveness of a single log, and accumulate it to the coverage
    void accumulateLog(OpponentPokemonTeam opponent) {
      final List<UserPokemon> pokemonTeam = opponent.getOrderedPokemonList();
      loggedPokemonCount += pokemonTeam.length;

      // Get coverage lists
      final defense = PokemonTypes.getDefenseCoverage(
          opponent.getTeamTypeffectiveness(), includedTypesKeys);
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

    opponents.forEach(accumulateLog);

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
    loggedPokemonCount /= _team.pokemonTeam.length;
    void scaleEffectiveness(typeData) => typeData.b /= loggedPokemonCount;
    netEffectiveness.forEach(scaleEffectiveness);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _team = PogoRepository.getUserTeam(widget.team.id);
    List<String> includedTypesKeys = _team.getCup().includedTypeKeys();

    // Analysis will be on all logged opponent teams
    if (widget.opponentTeams != null) {
      _calculateNetCoverage(
        widget.opponentTeams!,
        includedTypesKeys,
      );
      return LogsAnalysis(
        team: _team,
        opponents: widget.opponentTeams!,
        defenseThreats: defenseThreats,
        offenseCoverage: offenseCoverage,
        netEffectiveness: netEffectiveness,
      );
    }

    // Analysis will be on the opponent team
    else if (widget.opponentTeam != null) {
      _calculateSingleCoverage(
        widget.opponentTeam!.getOrderedPokemonList(),
        widget.opponentTeam!.getTeamTypeffectiveness(),
        includedTypesKeys,
      );
      return OpponentTeamAnalysis(
        team: _team,
        pokemonTeam: widget.opponentTeam!.getOrderedPokemonList(),
        defenseThreats: defenseThreats,
        offenseCoverage: offenseCoverage,
        netEffectiveness: netEffectiveness,
      );
    }

    // Analysis will be on the user team
    _calculateSingleCoverage(
      _team.getOrderedPokemonList(),
      _team.getTeamTypeffectiveness(),
      includedTypesKeys,
    );
    return UserTeamAnalysis(
      team: _team,
      defenseThreats: defenseThreats,
      offenseCoverage: offenseCoverage,
      netEffectiveness: netEffectiveness,
      onTeamChanged: () => setState(() {}),
    );
  }
}
