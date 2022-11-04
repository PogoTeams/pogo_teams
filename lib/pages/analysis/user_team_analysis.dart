// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../widgets/analysis/swap_list.dart';
import '../../widgets/analysis/type_coverage.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../teams/team_swap.dart';
import '../../game_objects/pokemon.dart';
import '../../game_objects/pokemon_team.dart';
import '../../game_objects/pokemon_typing.dart';
import '../../modules/data/pokemon_types.dart';
import '../../modules/ui/sizing.dart';
import '../../tools/pair.dart';

/*
-------------------------------------------------------------------- @PogoTeams
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
    required this.recalculate,
  }) : super(key: key);

  final UserPokemonTeam team;
  final List<Pair<PokemonType, double>> defenseThreats;
  final List<Pair<PokemonType, double>> offenseCoverage;
  final List<Pair<PokemonType, double>> netEffectiveness;
  final Function(List<Pokemon>, List<double>) recalculate;

  @override
  _UserTeamAnalysisState createState() => _UserTeamAnalysisState();
}

class _UserTeamAnalysisState extends State<UserTeamAnalysis> {
  // The included type keys of the team's given cup
  late final List<String> includedTypesKeys = widget.team.cup.includedTypeKeys;

  // The list of expansion panels
  List<PanelStates> _expansionPanels = [];

  final ScrollController _scrollController = ScrollController();

  // Setup the list of expansion panels given the PokemonTeam
  void _initializeExpansionPanels(List<Pokemon> pokemonTeam) {
    final defenseThreatTypes =
        widget.defenseThreats.map((typeData) => typeData.a).toList();

    final List<PokemonType> threatCounterTypes =
        PokemonTypes.getCounterTypes(defenseThreatTypes, includedTypesKeys);

    _expansionPanels = [
      // Meta Threats
      PanelStates(
        headerValue: Text(
          'Threats',
          style: Theme.of(context).textTheme.headline5,
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
          style: Theme.of(context).textTheme.headline5,
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
      widget.team.setPokemonTeam(newTeam);

      widget.recalculate(
        widget.team.getPokemonTeam(),
        widget.team.effectiveness,
      );

      setState(() {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(seconds: 1),
          curve: Curves.decelerate,
        );
      });
    }
  }

  void _onAddPokemon(Pokemon pokemon) {
    widget.team.addPokemon(pokemon);

    widget.recalculate(
      widget.team.getPokemonTeam(),
      widget.team.effectiveness,
    );

    setState(() {
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
            style: Theme.of(context).textTheme.headline5?.apply(
                  fontStyle: FontStyle.italic,
                ),
          ),

          // Spacer
          SizedBox(
            width: Sizing.blockSizeHorizontal * 3.0,
          ),

          // Page icon
          Icon(
            Icons.analytics,
            size: Sizing.icon3,
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
            top: Sizing.blockSizeVertical * .5,
            bottom: Sizing.blockSizeVertical * .5,
          ),
          child: PokemonNode.small(
            pokemon: pokemonTeam[index],
            onMoveChanged: () {
              widget.recalculate(
                widget.team.getPokemonTeam(),
                widget.team.effectiveness,
              );
            },
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
          left: Sizing.blockSizeHorizontal * 2.0,
          right: Sizing.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          controller: _scrollController,
          children: [
            // Spacer
            SizedBox(
              height: Sizing.blockSizeVertical * 1.0,
            ),

            // Build the Pokemon nodes
            _buildPokemonNodes(widget.team.getPokemonTeam()),

            // Spacer
            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

            Text(
              'PokemonType Coverage',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),

            // Spacer
            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

            TypeCoverage(
              netEffectiveness: widget.netEffectiveness,
              defenseThreats: widget.defenseThreats,
              offenseCoverage: widget.offenseCoverage,
              includedTypesKeys: includedTypesKeys,
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
