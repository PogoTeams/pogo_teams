// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Local Imports
import 'user_team_analysis.dart';
import 'opponent_team_analysis.dart';
import 'logs_analysis.dart';
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/pokemon_team.dart';
import '../../pogo_objects/pokemon_typing.dart';
import '../../pogo_objects/opponent_teams.dart';
import '../../modules/data/pokemon_types.dart';
import '../../tools/pair.dart';

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
    Key? key,
    required this.team,
    this.opponentTeam,
    this.opponentTeams,
  }) : super(key: key);

  final UserPokemonTeam team;
  final OpponentPokemonTeam? opponentTeam;
  final OpponentPokemonTeams? opponentTeams;

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  // The list of expansion panels
  List<Pair<PokemonType, double>> defenseThreats = [];
  List<Pair<PokemonType, double>> offenseCoverage = [];
  List<Pair<PokemonType, double>> netEffectiveness = [];

  final ScrollController _scrollController = ScrollController();

  void _calculateSingleCoverage(
    List<Pokemon> pokemonTeam,
    List<double> effectiveness,
    List<String> includedTypesKeys,
  ) {
    // Get coverage lists
    final defense =
        PokemonTypes.getDefenseCoverage(effectiveness, includedTypesKeys);

    final offense =
        PokemonTypes.getOffenseCoverage(pokemonTeam, includedTypesKeys);

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
        defense.where((typeData) => typeData.b > pokemonTeam.length).toList();

    offenseCoverage =
        offense.where((pair) => pair.b > pokemonTeam.length).toList();

    // Get an overall effectiveness for the bar graph display
    netEffectiveness = PokemonTypes.getMovesWeightedEffectiveness(
      defense,
      offense,
      includedTypesKeys,
    );

    // Scale effectiveness to non-effectiveness
    // TBH, this is convoluted, but hey it works...
    // The big complication is the net coverage of all logged opponents also
    // uses this abstraction.
    final double teamLength = pokemonTeam.length * PokemonTypes.notEffective;
    void _scaleEffectiveness(typeData) => typeData.b *= teamLength;
    netEffectiveness.forEach(_scaleEffectiveness);
  }

  // For the logged opponent teams, calculate the net coverage
  void _calculateNetCoverage(
    OpponentPokemonTeams logs,
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
    void _accumulateLog(OpponentPokemonTeam log) {
      final List<Pokemon> pokemonTeam = log.getPokemonTeam();
      loggedPokemonCount += pokemonTeam.length;

      // Get coverage lists
      final defense =
          PokemonTypes.getDefenseCoverage(log.effectiveness, includedTypesKeys);
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

    logs.teamsList.forEach(_accumulateLog);

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
    loggedPokemonCount /= widget.team.pokemonTeam.length;
    void _scaleEffectiveness(typeData) => typeData.b /= loggedPokemonCount;
    netEffectiveness.forEach(_scaleEffectiveness);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> includedTypesKeys = widget.team.cup.includedTypeKeys();

    // Analysis will be on all logged opponent teams
    if (widget.opponentTeams != null) {
      _calculateNetCoverage(
        widget.opponentTeams!,
        includedTypesKeys,
      );
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
      _calculateSingleCoverage(
        widget.opponentTeam!.getPokemonTeam(),
        widget.opponentTeam!.effectiveness,
        includedTypesKeys,
      );
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
      widget.team.getPokemonTeam(),
      widget.team.effectiveness,
      includedTypesKeys,
    );
    return UserTeamAnalysis(
      team: widget.team,
      defenseThreats: defenseThreats,
      offenseCoverage: offenseCoverage,
      netEffectiveness: netEffectiveness,
      recalculate: (team, effectiveness) => setState(() {
        _calculateSingleCoverage(
          team,
          effectiveness,
          includedTypesKeys,
        );
      }),
    );
  }
}
