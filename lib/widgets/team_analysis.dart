// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pogo_teams/widgets/analysis_visuals/coverage_graph.dart';

// Local Imports
import 'analysis_visuals/swap_list.dart';
import '../data/pokemon/pokemon.dart';
import '../data/pokemon/pokemon_team.dart';
import '../data/masters/type_master.dart';
import '../data/pokemon/typing.dart';
import '../configs/size_config.dart';
import '../tools/pair.dart';

/*
-------------------------------------------------------------------------------
Based on the PokemonTeam provided, various analysis will be displayed to the
user. The user will also be able to make adjustments to the team, and see
realtime analysis updates.
-------------------------------------------------------------------------------
*/

class TeamAnalysis extends StatefulWidget {
  const TeamAnalysis({
    Key? key,
    required this.team,
    required this.onTeamSwap,
  }) : super(key: key);

  final PokemonTeam team;
  final Function(Pokemon) onTeamSwap;

  @override
  _TeamAnalysisState createState() => _TeamAnalysisState();
}

class _TeamAnalysisState extends State<TeamAnalysis> {
  // The list of expansion panels
  List<PanelStates> _expansionPanels = [];

  // Setup the list of expansion panels given the PokemonTeam
  void _initializeExpansionPanels() {
    final List<Pokemon> pokemonTeam = widget.team.getPokemonTeam();

    final List<double> teamEffectiveness = widget.team.effectiveness;

    // Get coverage lists
    final defense = TypeMaster.getDefenseCoverage(teamEffectiveness);
    final offense = TypeMaster.getOffenseCoverage(pokemonTeam);

    // Filter to the key values
    List<Pair<Type, double>> defenseThreats =
        defense.where((typeData) => typeData.b > pokemonTeam.length).toList();

    List<Pair<Type, double>> offenseCoverage =
        offense.where((pair) => pair.b > pokemonTeam.length).toList();

    // Get an overall effectiveness for the bar graph display
    List<Pair<Type, double>> netEffectiveness =
        TypeMaster.getMovesWeightedEffectiveness(
            defense, offense, pokemonTeam.length);

    offenseCoverage.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());

    defenseThreats.sort((prev, curr) => ((curr.b - prev.b) * 1000).toInt());

    final defenseThreatTypes =
        defenseThreats.map((typeData) => typeData.a).toList();

    final List<Type> threatCounterTypes =
        TypeMaster.getCounters(defenseThreatTypes);

    _expansionPanels = [
      // Type Coverage
      PanelStates(
        headerValue: Text(
          'Type Coverage',
          style: TextStyle(
            letterSpacing: SizeConfig.blockSizeHorizontal * .8,
            fontSize: SizeConfig.h1,
            fontWeight: FontWeight.bold,
          ),
        ),
        expandedValue: CoverageGraph(
          netEffectiveness: netEffectiveness,
          defenseThreats: defenseThreats,
          offenseCoverage: offenseCoverage,
          teamSize: pokemonTeam.length,
        ),
        isExpanded: true,
      ),

      // Meta Threats
      PanelStates(
        headerValue: Text(
          'Threats',
          style: TextStyle(
            letterSpacing: SizeConfig.blockSizeHorizontal * .8,
            fontSize: SizeConfig.h1,
            fontWeight: FontWeight.bold,
          ),
        ),
        expandedValue: SwapList(
          team: widget.team,
          types: defenseThreatTypes,
          onTeamSwap: widget.onTeamSwap,
        ),
        isExpanded: false,
      ),

      // Team Alternatives (Threat Counters)
      PanelStates(
        headerValue: Text(
          'Threat Counters',
          style: TextStyle(
            letterSpacing: SizeConfig.blockSizeHorizontal * .8,
            fontSize: SizeConfig.h1,
            fontWeight: FontWeight.bold,
          ),
        ),
        expandedValue: SwapList(
          team: widget.team,
          types: threatCounterTypes,
          onTeamSwap: widget.onTeamSwap,
        ),
        isExpanded: false,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _initializeExpansionPanels();
  }

  @override
  Widget build(BuildContext context) {
    // Only render analysis if there is at least 1 Pokemon
    if (widget.team.isEmpty()) return Container();

    // Build an expansion panel for each category of the analysis
    return ExpansionPanelList(
      elevation: 0.0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _expansionPanels[index].isExpanded = !isExpanded;
        });
      },
      children: _expansionPanels.map<ExpansionPanel>(
        (PanelStates item) {
          return ExpansionPanel(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: item.headerValue,
              );
            },
            body: ListTile(
              title: item.expandedValue,
              contentPadding: EdgeInsets.zero,
            ),
            isExpanded: item.isExpanded,
          );
        },
      ).toList(),
    );
  }
}

// Expansion panel state information container
class PanelStates {
  PanelStates({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  Widget expandedValue;
  Widget headerValue;
  bool isExpanded;
}
