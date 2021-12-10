// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pogo_teams/widgets/pokemon_list.dart';

// Local Imports
import '../widgets/analysis/swap_list.dart';
import '../widgets/analysis/type_coverage.dart';
import '../widgets/nodes/pokemon_node.dart';
import '../data/pokemon/pokemon.dart';
import '../data/pokemon/pokemon_team.dart';
import '../data/masters/type_master.dart';
import '../data/pokemon/typing.dart';
import '../data/cup.dart';
import '../configs/size_config.dart';
import '../tools/pair.dart';
import '../data/globals.dart' as globals;

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
      body: Padding(
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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(
          context,
          widget.team.pokemonTeam,
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
            onMoveChanged: () => setState(() {
              _initializeExpansionPanels();
            }),
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

class OpponentTeamAnalysis extends StatelessWidget {
  const OpponentTeamAnalysis({
    Key? key,
    required this.team,
  }) : super(key: key);

  final PokemonTeam team;

  // Setup the list of expansion panels given the PokemonTeam
  Widget _buildTypeCoverage() {
    final List<Pokemon> pokemonTeam = team.getPokemonTeam();

    final List<double> teamEffectiveness = team.effectiveness;

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

    return TypeCoverage(
      netEffectiveness: netEffectiveness,
      defenseThreats: defenseThreats,
      offenseCoverage: offenseCoverage,
      teamSize: pokemonTeam.length,
    );
  }

  // Build the scaffold for this page
  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 1.0,
            ),

            // Opponent team
            _buildPokemonNodes(team.getPokemonTeam()),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),

            // Type coverage widgets
            _buildTypeCoverage(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Opponent Team Analysis',
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
            dropdowns: false,
          ),
        ),
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }
}

class LogsAnalysis extends StatelessWidget {
  const LogsAnalysis({
    Key? key,
    required this.logs,
    required this.cup,
  }) : super(key: key);

  final List<PokemonTeam> logs;
  final Cup cup;

  // Setup the list of expansion panels given the PokemonTeam
  Widget _buildTypeCoverage() {
    // The count of individually logged Pokemon in all the logs
    int loggedPokemonCount = 0;

    List<Pair<Type, double>> defenseThreats =
        TypeMaster.generateTypeValuePairedList();

    List<Pair<Type, double>> offenseCoverage =
        TypeMaster.generateTypeValuePairedList();

    List<Pair<Type, double>> netEffectiveness =
        TypeMaster.generateTypeValuePairedList();

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

    // TODO : This works in generating a reasonable graph, but man it is not
    // intuitive
    void _scaleEffectiveness(typeData) =>
        typeData.b /= (loggedPokemonCount / 3);
    netEffectiveness.forEach(_scaleEffectiveness);

    return ListView(
      children: [
        // Type coverage widgets
        TypeCoverage(
          netEffectiveness: netEffectiveness,
          defenseThreats: defenseThreats,
          offenseCoverage: offenseCoverage,
          teamSize: loggedPokemonCount,
        ),

        // Spacer
        SizedBox(
          height: SizeConfig.blockSizeVertical * 3.0,
        ),

        Text('Top Counters',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.h1,
              fontWeight: FontWeight.bold,
              letterSpacing: SizeConfig.blockSizeHorizontal * .7,
            )),

        Divider(
          height: SizeConfig.blockSizeVertical * 5.0,
          thickness: SizeConfig.blockSizeVertical * .5,
          indent: SizeConfig.blockSizeHorizontal * 2.0,
          endIndent: SizeConfig.blockSizeHorizontal * 2.0,
          color: Colors.white,
        ),

        // A list of top counters to the logged opponent teams
        _buildCountersList(defenseThreats),
      ],
    );
  }

  Widget _buildCountersList(List<Pair<Type, double>> defenseThreats) {
    final threatTypes = defenseThreats.map((typeData) => typeData.a).toList();

    return LogSwapList(
      cup: cup,
      types: threatTypes,
      onTeamChanged: (_) {},
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Logged Opponents Net Analysis',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 2.0,
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: _buildTypeCoverage(),
      ),
    );
  }
}
