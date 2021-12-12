// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// Package Import
import 'package:provider/provider.dart';

// Local Imports
import 'team_builder_search.dart';
import '../analysis/analysis.dart';
import '../../configs/size_config.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../widgets/dropdowns/cup_dropdown.dart';
import '../../widgets/dropdowns/team_size_dropdown.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/teams_provider.dart';
import '../../data/cup.dart';

/*
-------------------------------------------------------------------------------
A full page view of a user's Pokemon team. When there is at least 1 Pokemon on
the team, an Analysis button will appear, where the user can view a complete
analysis of their team. The following operations are currently supported for
each Pokemon node on the team :

- Remove Pokemon
- Swap Pokemon
-------------------------------------------------------------------------------
*/

class TeamEdit extends StatefulWidget {
  const TeamEdit({
    Key? key,
    required this.teamIndex,
  }) : super(key: key);

  final int teamIndex;

  @override
  _TeamEditState createState() => _TeamEditState();
}

class _TeamEditState extends State<TeamEdit>
    with AutomaticKeepAliveClientMixin {
  // Used to manually notify parent listeners that use this team
  late TeamsProvider _provider;

  // The team at to edit
  late UserPokemonTeam _team;

  // SETTER CALLBACKS
  void _onCupChanged(String? newCup) {
    if (newCup == null) return;

    setState(() {
      _team.setCup(newCup);
      _provider.notify();
    });
  }

  void _onTeamSizeChanged(int? newSize) {
    if (newSize == null) return;

    setState(() {
      _team.setTeamSize(newSize);
      _provider.notify();
    });
  }

  void _onPokemonChanged(int index, Pokemon? newPokemon) {
    setState(() {
      _team.setPokemon(index, newPokemon);
      _provider.notify();
    });
  }

  void _onTeamChanged(List<Pokemon?> newPokemonTeam) {
    setState(() {
      _team.setTeam(newPokemonTeam);
      _provider.notify();
    });
  }

  void _searchMode(int nodeIndex) async {
    final _newTeam = await Navigator.push(
      context,
      MaterialPageRoute<UserPokemonTeam>(builder: (BuildContext context) {
        return TeamBuilderSearch(
          team: _team,
          cup: _team.cup,
          focusIndex: nodeIndex,
        );
      }),
    );

    if (_newTeam != null) {
      setState(() {
        Provider.of<TeamsProvider>(context, listen: false)
            .setTeamAt(widget.teamIndex, _newTeam);
      });
    }
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzePressed() async {
    // If the team is empty, no action will be taken
    if (_team.isEmpty()) return;

    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<List<Pokemon?>>(builder: (BuildContext context) {
        return Analysis(team: _team);
      }),
    );

    if (newTeam != null) _onTeamChanged(newTeam);
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Team Edit',
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
            Icons.build_circle,
            size: SizeConfig.blockSizeHorizontal * 6.0,
          ),
        ],
      ),
    );
  }

  // Build a row of icon buttons at the bottom of a Pokemon's Node
  // If the Pokemon in question is null, this footer is also null
  Widget? _buildNodeFooter(Pokemon? pokemon, int nodeIndex) {
    if (pokemon == null) return null;

    // Size of the footer icons
    final double iconSize = SizeConfig.blockSizeHorizontal * 6.2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _onPokemonChanged(nodeIndex, null),
          icon: const Icon(Icons.clear),
          tooltip: 'remove this pokemon from your team',
          iconSize: iconSize,
        ),
        IconButton(
          onPressed: () => _searchMode(nodeIndex),
          icon: const Icon(Icons.swap_horiz),
          tooltip: 'search for a different pokemon',
          iconSize: iconSize,
        ),
      ],
    );
  }

  // Build a cup dropdown and team size dropdown
  Widget _buildHeaderDropdowns(Cup cup, int teamLength) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dropdown for pvp cup selection
        CupDropdown(
          cup: cup,
          onCupChanged: _onCupChanged,
          width: SizeConfig.screenWidth * .7,
        ),

        // Dropdown to select team size
        TeamSizeDropdown(
          size: teamLength,
          onTeamSizeChanged: _onTeamSizeChanged,
        ),
      ],
    );
  }

  // Build the list of either 3 or 6 PokemonNodes that make up this team
  Widget _buildTeamNodes(List<Pokemon?> pokemonTeam) {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        pokemonTeam.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1.1,
            bottom: SizeConfig.blockSizeVertical * 1.1,
          ),
          child: (index == pokemonTeam.length - 1)
              ? Column(
                  children: [
                    PokemonNode.large(
                      pokemon: pokemonTeam[index],
                      onEmptyPressed: () => _searchMode(index),
                      onMoveChanged: (pokemon) {
                        _team.setPokemon(index, pokemon);
                        _provider.notify();
                      },
                      cup: _team.cup,
                      footer: _buildNodeFooter(pokemonTeam[index], index),
                    ),

                    // Spacer to give last node in the list more scroll room
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 10.0,
                    ),
                  ],
                )
              : PokemonNode.large(
                  pokemon: pokemonTeam[index],
                  onEmptyPressed: () => _searchMode(index),
                  onMoveChanged: (pokemon) {
                    _team.setPokemon(index, pokemon);
                    _provider.notify();
                  },
                  cup: _team.cup,
                  footer: _buildNodeFooter(pokemonTeam[index], index),
                ),
        ),
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  // Keeps page state upon swiping away in PageView
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Provider retrieval
    _provider = Provider.of<TeamsProvider>(context);
    _team = _provider.builderTeams[widget.teamIndex];

    final pokemonTeam = _team.pokemonTeam;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 2.0,
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            // Cup and team size dropdown menus at the top of the page
            _buildHeaderDropdowns(_team.cup, pokemonTeam.length),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 1.0,
            ),

            // The list of team nodes
            _buildTeamNodes(pokemonTeam),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),
          ],
        ),
      ),
      floatingActionButton: _team.isEmpty()
          ? Container()
          : GradientButton(
              onPressed: _onAnalyzePressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Analyze Team',
                    style: TextStyle(
                      fontSize: SizeConfig.h2,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 5.0,
                  ),
                  Icon(
                    Icons.analytics,
                    size: SizeConfig.blockSizeHorizontal * 7.0,
                  ),
                ],
              ),
              width: SizeConfig.screenWidth * .85,
              height: SizeConfig.blockSizeVertical * 8.5,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
