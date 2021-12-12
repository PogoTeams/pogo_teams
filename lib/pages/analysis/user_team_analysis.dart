// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Local Imports
import '../../widgets/analysis/swap_list.dart';
import '../../widgets/analysis/type_coverage.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../teams/team_swap.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/masters/type_master.dart';
import '../../data/pokemon/typing.dart';
import '../../configs/size_config.dart';
import '../../tools/pair.dart';

/*
-------------------------------------------------------------------------------
An analysis page for a single user team. The user will be able to edit their
team via the swap feature, given the current threats / counters of their team.
-------------------------------------------------------------------------------
*/

class UserTeamAnalysis extends StatefulWidget {
  const UserTeamAnalysis({
    Key? key,
    required this.team,
    required this.defenseThreats,
    required this.offenseCoverage,
    required this.netEffectiveness,
  }) : super(key: key);

  final UserPokemonTeam team;
  final List<Pair<Type, double>> defenseThreats;
  final List<Pair<Type, double>> offenseCoverage;
  final List<Pair<Type, double>> netEffectiveness;

  @override
  _UserTeamAnalysisState createState() => _UserTeamAnalysisState();
}

class _UserTeamAnalysisState extends State<UserTeamAnalysis> {
  // The list of expansion panels
  List<PanelStates> _expansionPanels = [];

  final ScrollController _scrollController = ScrollController();

  // Setup the list of expansion panels given the PokemonTeam
  void _initializeExpansionPanels(List<Pokemon> pokemonTeam) {
    final defenseThreatTypes =
        widget.defenseThreats.map((typeData) => typeData.a).toList();

    final List<Type> threatCounterTypes =
        TypeMaster.getCounters(defenseThreatTypes);

    _expansionPanels = [
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
          onSwap: _onSwap,
          onAdd: _onAddPokemon,
          team: widget.team,
          types: defenseThreatTypes,
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
          onSwap: _onSwap,
          onAdd: _onAddPokemon,
          team: widget.team,
          types: threatCounterTypes,
        ),
        isExpanded: true,
      ),
    ];
  }

  // When the team is changed from a swap page, animate to the top of to
  // display the new team
  void _onSwap(Pokemon swapPokemon) async {
    List<Pokemon>? newTeam = await Navigator.push(
      context,
      MaterialPageRoute<List<Pokemon>>(
        builder: (BuildContext context) {
          return TeamSwap(
            team: widget.team,
            swap: swapPokemon,
          );
        },
      ),
    );

    if (newTeam != null) {
      setState(() {
        widget.team.setTeam(newTeam);
        _scrollController.animateTo(
          0.0,
          duration: const Duration(seconds: 1),
          curve: Curves.decelerate,
        );
      });
    }
  }

  void _onAddPokemon(Pokemon pokemon) {
    setState(() {
      widget.team.addPokemon(pokemon);
      _scrollController.animateTo(
        0.0,
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
      );
    });
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
            dropdowns: false,
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

    _initializeExpansionPanels(widget.team.getPokemonTeam());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

            // Build the Pokemon nodes
            _buildPokemonNodes(widget.team.getPokemonTeam()),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),

            Text(
              'Type Coverage',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: SizeConfig.blockSizeHorizontal * .8,
                fontSize: SizeConfig.h1,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),

            TypeCoverage(
              netEffectiveness: widget.netEffectiveness,
              defenseThreats: widget.defenseThreats,
              offenseCoverage: widget.offenseCoverage,
            ),

            // Collapsible Pokemon threats and counters
            _buildPanelList(),
          ],
        ),
      ),
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
