// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'team_builder.dart';
import '../analysis/analysis.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/data/pogo_data.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../widgets/dropdowns/cup_dropdown.dart';
import '../../widgets/dropdowns/team_size_dropdown.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../pogo_objects/pokemon_team.dart';
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/cup.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A full page view of a user's Pokemon team. When there is at least 1 Pokemon on
the team, an Analysis button will appear, where the user can view a complete
analysis of their team. The Pokemon can be removed, swapped out, or their
moveset can be adjusted.
-------------------------------------------------------------------------------
*/

class TeamEdit extends StatefulWidget {
  const TeamEdit({
    Key? key,
    required this.team,
  }) : super(key: key);

  final UserPokemonTeam team;

  @override
  _TeamEditState createState() => _TeamEditState();
}

class _TeamEditState extends State<TeamEdit> {
  // The working copy of this team
  late UserPokemonTeam _builderTeam = widget.team;

  // SETTER CALLBACKS
  void _onCupChanged(String? newCup) {
    if (newCup == null) return;

    setState(() {
      _builderTeam.setCupById(newCup);
      PogoData.updatePokemonTeamSync(_builderTeam);
    });
  }

  void _onTeamSizeChanged(int? newSize) {
    if (newSize == null) return;

    setState(() {
      _builderTeam.teamSize = newSize;
      PogoData.updatePokemonTeamSync(_builderTeam);
    });
  }

  void _onPokemonCleared(int index) {
    setState(() {
      _builderTeam.removePokemon(index);
      PogoData.updatePokemonTeamSync(_builderTeam);
    });
  }

  void _onPokemonMoveChanged() {
    setState(() {
      PogoData.updatePokemonTeamSync(_builderTeam);
    });
  }

  void _onSearchPressed(int nodeIndex) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return TeamBuilder(
          team: _builderTeam,
          cup: _builderTeam.getCup(),
          focusIndex: nodeIndex,
        );
      }),
    );

    setState(() {});
  }

  // Scroll to the analysis portion of the screen
  void _onAnalyzePressed() async {
    // If the team is empty, no action will be taken
    if (_builderTeam.isEmpty()) return;

    await Navigator.push(
      context,
      MaterialPageRoute<List<Pokemon?>>(builder: (BuildContext context) {
        return Analysis(team: _builderTeam);
      }),
    );

    PogoData.updatePokemonTeamSync(_builderTeam);
  }

  AppBar _buildAppBar() {
    return AppBar(
      // Upon navigating back, return the updated team ref
      leading: IconButton(
        onPressed: () => Navigator.pop(
          context,
          _builderTeam,
        ),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            'Team Edit',
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
            Icons.build_circle,
            size: Sizing.icon3,
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
    final double iconSize = Sizing.blockSizeHorizontal * 6.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _onPokemonCleared(nodeIndex),
          icon: const Icon(Icons.clear),
          tooltip: 'remove this pokemon from your team',
          iconSize: iconSize,
        ),
        IconButton(
          onPressed: () => _onSearchPressed(nodeIndex),
          icon: const Icon(Icons.swap_horiz),
          tooltip: 'search for a different pokemon',
          iconSize: iconSize,
        ),
      ],
    );
  }

  // Build a cup dropdown and team size dropdown
  Widget _buildHeaderDropdowns(Cup cup) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dropdown for pvp cup selection
        CupDropdown(
          cup: cup,
          onCupChanged: _onCupChanged,
          width: Sizing.screenWidth * .7,
        ),

        // Dropdown to select team size
        TeamSizeDropdown(
          size: _builderTeam.teamSize,
          onTeamSizeChanged: _onTeamSizeChanged,
        ),
      ],
    );
  }

  // Build the list of either 3 or 6 PokemonNodes that make up this team
  Widget _buildTeamNodes() {
    return ListView(
      shrinkWrap: true,
      children: List.generate(
        _builderTeam.teamSize,
        (index) => Padding(
          padding: EdgeInsets.only(
            top: Sizing.blockSizeVertical * 1.1,
            bottom: Sizing.blockSizeVertical * 1.1,
          ),
          child: (index == _builderTeam.teamSize - 1)
              ? Column(
                  children: [
                    PokemonNode.large(
                      pokemon: _builderTeam.getPokemon(index),
                      onEmptyPressed: () => _onSearchPressed(index),
                      onMoveChanged: _onPokemonMoveChanged,
                      cup: _builderTeam.getCup(),
                      footer: _buildNodeFooter(
                          _builderTeam.getPokemon(index), index),
                      padding: EdgeInsets.only(
                        top: Sizing.blockSizeVertical * .7,
                        left: Sizing.blockSizeHorizontal * 2.0,
                        right: Sizing.blockSizeHorizontal * 2.0,
                      ),
                    ),

                    // Spacer to give last node in the list more scroll room
                    SizedBox(
                      height: Sizing.blockSizeVertical * 10.0,
                    ),
                  ],
                )
              : PokemonNode.large(
                  pokemon: _builderTeam.getPokemon(index),
                  onEmptyPressed: () => _onSearchPressed(index),
                  onMoveChanged: _onPokemonMoveChanged,
                  cup: _builderTeam.getCup(),
                  footer:
                      _buildNodeFooter(_builderTeam.getPokemon(index), index),
                  padding: EdgeInsets.only(
                    top: Sizing.blockSizeVertical * .7,
                    left: Sizing.blockSizeHorizontal * 2.0,
                    right: Sizing.blockSizeHorizontal * 2.0,
                  ),
                ),
        ),
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _builderTeam = PogoData.getUserPokemonTeamSync(_builderTeam.id);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: Sizing.blockSizeVertical * 2.0,
          left: Sizing.blockSizeHorizontal * 2.0,
          right: Sizing.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            // Cup and team size dropdown menus at the top of the page
            _buildHeaderDropdowns(_builderTeam.getCup()),

            // Spacer
            SizedBox(
              height: Sizing.blockSizeVertical * 1.0,
            ),

            // The list of team nodes
            _buildTeamNodes(),

            // Spacer
            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),
          ],
        ),
      ),
      floatingActionButton: _builderTeam.isEmpty()
          ? Container()
          : GradientButton(
              onPressed: _onAnalyzePressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Analyze Team',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    width: Sizing.blockSizeHorizontal * 5.0,
                  ),
                  Icon(
                    Icons.analytics,
                    size: Sizing.blockSizeHorizontal * 7.0,
                  ),
                ],
              ),
              width: Sizing.screenWidth * .85,
              height: Sizing.blockSizeVertical * 8.5,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
