// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pogo_teams/widgets/analysis_visuals/coverage_graph.dart';

// Local Imports
import 'meta_threats.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/masters/type_master.dart';
import '../../data/pokemon/typing.dart';
import '../../configs/size_config.dart';
import '../../tools/pair.dart';

// Expansion panel state information container
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  Widget expandedValue;
  Widget headerValue;
  bool isExpanded;
}

class MetaLists extends StatefulWidget {
  const MetaLists({
    Key? key,
    required this.team,
  }) : super(key: key);

  final PokemonTeam team;

  @override
  _MetaListsState createState() => _MetaListsState();
}

class _MetaListsState extends State<MetaLists> {
  late final List<Item> _data;

  @override
  void initState() {
    super.initState();

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

    _data = [
      Item(
        headerValue:
            // Header
            Text(
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
      Item(
        headerValue:
            // Header
            Text(
          'Meta Threats',
          style: TextStyle(
            letterSpacing: SizeConfig.blockSizeHorizontal * .8,
            fontSize: SizeConfig.h1,
            fontWeight: FontWeight.bold,
          ),
        ),
        expandedValue: MetaThreats(
          team: widget.team,
          typeThreats: defenseThreats.map((typeData) => typeData.a).toList(),
        ),
        isExpanded: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
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
            onTap: () {},
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
