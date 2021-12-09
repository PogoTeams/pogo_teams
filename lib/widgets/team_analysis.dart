// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Local Imports
import 'analysis_visuals/swap_list.dart';
import 'analysis_visuals/type_coverage.dart';
import '../widgets/nodes/pokemon_node.dart';
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
  }) : super(key: key);

  final PokemonTeam team;

  @override
  _TeamAnalysisState createState() => _TeamAnalysisState();
}

class _TeamAnalysisState extends State<TeamAnalysis> {
  // The list of expansion panels
  List<PanelStates> _expansionPanels = [];

  final ScrollController _scrollController = ScrollController();

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
        expandedValue: TypeCoverage(
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
          onTeamChanged: _onTeamChanged,
        ),
        isExpanded: true,
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
          onTeamChanged: _onTeamChanged,
        ),
        isExpanded: true,
      ),
    ];
  }

  void _onTeamChanged(List<Pokemon?> newPokemonTeam) {
    setState(() {
      widget.team.setTeam(newPokemonTeam);
      _scrollController.animateTo(
        0.0,
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
      );
    });
  }

  // Build the scaffold for this page
  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 2.0,
            right: SizeConfig.blockSizeHorizontal * 2.0,
          ),
          child: ListView(
            controller: _scrollController,
            children: [
              // Spacer
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1.0,
              ),
              _buildPokemonNodes(widget.team.getPokemonTeam()),
              _buildPanelList(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(
          context,
          widget.team.team,
        ),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Team Analysis',
            style: TextStyle(
              fontSize: SizeConfig.h2,
              fontStyle: FontStyle.italic,
            ),
          ),

          // Spacer
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 3.0,
          ),

          // Page icon
          Icon(
            Icons.analytics,
            size: SizeConfig.blockSizeHorizontal * 6.0,
          ),
        ],
      ),
    );
  }

  // Build the list of either 3 or 6 PokemonNodes that make up this team
  Widget _buildPokemonNodes(List<Pokemon> pokemonTeam) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        pokemonTeam.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * .5,
            bottom: SizeConfig.blockSizeVertical * .5,
          ),
          child: PokemonNode.small(
            pokemon: pokemonTeam[index],
          ),
        ),
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildPanelList() {
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

  @override
  void initState() {
    super.initState();
    _initializeExpansionPanels();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only render analysis if there is at least 1 Pokemon
    if (widget.team.isEmpty()) return Container();

    // Build an expansion panel for each category of the analysis
    return _buildScaffold(context);
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
