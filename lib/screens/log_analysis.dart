// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pogo_teams/widgets/analysis_visuals/coverage_graph.dart';

// Local Imports
import '../data/pokemon/pokemon.dart';
import '../data/masters/type_master.dart';
import '../data/pokemon/typing.dart';
import '../widgets/buttons/exit_button.dart';
import '../widgets/analysis_visuals/swap_list.dart';
import '../configs/size_config.dart';
import '../tools/pair.dart';
import '../data/cup.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
A screen that displays an analysis of all logged teams in a team log page.
This will show a user the potential vulnerabilties of all of the logged teams
and potential top performing counters.
-------------------------------------------------------------------------------
*/

class LogAnalysis extends StatefulWidget {
  const LogAnalysis({
    Key? key,
    required this.teams,
    required this.cup,
  }) : super(key: key);

  final List<List<Pokemon?>> teams;
  final Cup cup;

  @override
  _LogAnalysisState createState() => _LogAnalysisState();
}

class _LogAnalysisState extends State<LogAnalysis> {
  // The list of expansion panels
  List<PanelStates> _expansionPanels = [];

  // Setup the list of expansion panels given the PokemonTeam
  void _initializeExpansionPanels() {
    final _teams = widget.teams;

    final List<Pair<Type, double>> netDefense = List.generate(globals.typeCount,
        (index) => Pair(a: TypeMaster.typeList[index], b: 0.0));
    final List<Pair<Type, double>> netOffense = List.generate(globals.typeCount,
        (index) => Pair(a: TypeMaster.typeList[index], b: 0.0));

    int totalPokemon = 0;

    void _analyzeTeam(List<Pokemon?> team) {
      // Reduce array to non null Pokemon
      final pokemonTeam = team.whereType<Pokemon>().toList();
      totalPokemon += pokemonTeam.length;

      // Get net effectiveness of this team
      final List<double> teamEffectiveness =
          TypeMaster.getNetEffectiveness(pokemonTeam);

      // Get coverage lists
      final defense = TypeMaster.getDefenseCoverage(teamEffectiveness);
      final offense = TypeMaster.getOffenseCoverage(pokemonTeam);

      for (int i = 0; i < globals.typeCount; ++i) {
        netDefense[i].b += defense[i].b;
        netOffense[i].b += offense[i].b;
      }
    }

    _teams.forEach(_analyzeTeam);

    // Filter to the key values
    List<Pair<Type, double>> defenseThreats =
        netDefense.where((typeData) => typeData.b > totalPokemon).toList();

    List<Pair<Type, double>> offenseCoverage =
        netOffense.where((pair) => pair.b > totalPokemon).toList();

    // Get an overall effectiveness for the bar graph display
    List<Pair<Type, double>> netEffectiveness =
        TypeMaster.getMovesWeightedEffectiveness(
            netDefense, netOffense, totalPokemon);

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
          teamSize: totalPokemon,
        ),
        isExpanded: true,
      ),

      // Team Alternatives (Threat Counters)
      PanelStates(
        headerValue: Text(
          'Counters',
          style: TextStyle(
            letterSpacing: SizeConfig.blockSizeHorizontal * .8,
            fontSize: SizeConfig.h1,
            fontWeight: FontWeight.bold,
          ),
        ),
        expandedValue: LogSwapList(
          cup: widget.cup,
          types: threatCounterTypes,
          onTeamChanged: (pokemonTeam) {},
        ),
        isExpanded: true,
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
    // Build an expansion panel for each category of the analysis
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            ExpansionPanelList(
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
            ),
          ],
        ),
      ),
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
