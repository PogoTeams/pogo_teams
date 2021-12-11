// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'user_team_analysis.dart';
import 'opponent_team_analysis.dart';
import 'logs_analysis.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/masters/type_master.dart';
import '../../data/pokemon/typing.dart';
import '../../tools/pair.dart';
import '../../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
An analysis page that will generate different results, given the provided
team(s). This widget is used to branch unique analysis pages for a :

- user team
- opponent team
- logged opponent teams
-------------------------------------------------------------------------------
*/

class Analysis extends StatefulWidget {
  const Analysis({
    Key? key,
    required this.team,
    this.opponentTeam,
    this.opponentTeams,
  }) : super(key: key);

  final UserPokemonTeam team;
  final LogPokemonTeam? opponentTeam;
  final List<LogPokemonTeam>? opponentTeams;

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  // The list of expansion panels
  List<Pair<Type, double>> defenseThreats = [];
  List<Pair<Type, double>> offenseCoverage = [];
  List<Pair<Type, double>> netEffectiveness = [];

  final ScrollController _scrollController = ScrollController();

  void _calculateSingleCoverage(
      List<Pokemon> pokemonTeam, List<double> effectiveness) {
    // Get coverage lists
    final defense = TypeMaster.getDefenseCoverage(effectiveness);
    final offense = TypeMaster.getOffenseCoverage(pokemonTeam);

    // Filter to the key values
    defenseThreats =
        defense.where((typeData) => typeData.b > pokemonTeam.length).toList();

    offenseCoverage =
        offense.where((pair) => pair.b > pokemonTeam.length).toList();

    // Get an overall effectiveness for the bar graph display
    netEffectiveness = TypeMaster.getMovesWeightedEffectiveness(
        defense, offense, pokemonTeam.length);

    offenseCoverage.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());

    defenseThreats.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());
  }

  // For the logged opponent teams, calculate the net coverage
  void _calculateNetCoverage(List<PokemonTeam> logs) {
    // The count of individually logged Pokemon in all the logs
    int loggedPokemonCount = 0;

    defenseThreats = TypeMaster.generateTypeValuePairedList();
    offenseCoverage = TypeMaster.generateTypeValuePairedList();
    netEffectiveness = TypeMaster.generateTypeValuePairedList();

    void _accumulateLog(log) {
      final List<Pokemon> pokemonTeam = log.getPokemonTeam();
      loggedPokemonCount += pokemonTeam.length;

      // Get coverage lists
      final defense = TypeMaster.getDefenseCoverage(log.effectiveness);
      final offense = TypeMaster.getOffenseCoverage(pokemonTeam);

      List<Pair<Type, double>> logEffectiveness =
          TypeMaster.getMovesWeightedEffectiveness(
              defense, offense, pokemonTeam.length);

      for (int i = 0; i < globals.typeCount; ++i) {
        defenseThreats[i].b += defense[i].b;
        offenseCoverage[i].b += offense[i].b;
        netEffectiveness[i].b += logEffectiveness[i].b;
      }
    }

    logs.forEach(_accumulateLog);

    // Filter to the key values
    defenseThreats = defenseThreats
        .where((typeData) => typeData.b > loggedPokemonCount)
        .toList();

    offenseCoverage =
        offenseCoverage.where((pair) => pair.b > loggedPokemonCount).toList();

    offenseCoverage.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());
    defenseThreats.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());

    // Scale effectiveness to the total logged Pokemon
    void _scaleEffectiveness(typeData) =>
        typeData.b /= (loggedPokemonCount / 3);
    netEffectiveness.forEach(_scaleEffectiveness);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Analysis will be on all logged opponent teams
    if (widget.opponentTeams != null) {
      _calculateNetCoverage(widget.opponentTeams!);
      return LogsAnalysis(
        team: widget.team,
        logs: widget.opponentTeams!,
        defenseThreats: defenseThreats,
        offenseCoverage: offenseCoverage,
        netEffectiveness: netEffectiveness,
      );
    }

    // Analysis will be on the opponent team
    else if (widget.opponentTeam != null) {
      _calculateSingleCoverage(widget.opponentTeam!.getPokemonTeam(),
          widget.opponentTeam!.effectiveness);
      return OpponentTeamAnalysis(
        team: widget.team,
        pokemonTeam: widget.opponentTeam!.getPokemonTeam(),
        defenseThreats: defenseThreats,
        offenseCoverage: offenseCoverage,
        netEffectiveness: netEffectiveness,
      );
    }

    // Analysis will be on the user team
    _calculateSingleCoverage(
        widget.team.getPokemonTeam(), widget.team.effectiveness);
    return UserTeamAnalysis(
      team: widget.team,
      defenseThreats: defenseThreats,
      offenseCoverage: offenseCoverage,
      netEffectiveness: netEffectiveness,
    );
  }
}
