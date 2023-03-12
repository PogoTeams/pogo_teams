// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'team_builder.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/data/pogo_data.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../widgets/dropdowns/cup_dropdown.dart';
import '../../widgets/dropdowns/team_size_dropdown.dart';
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

  final PokemonTeam team;

  @override
  _TeamEditState createState() => _TeamEditState();
}

class _TeamEditState extends State<TeamEdit> {
  // The working copy of this team
  late PokemonTeam _builderTeam = widget.team;

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

  // Build a row of icon buttons at the bottom of a Pokemon's Node
  // If the Pokemon in question is null, this footer is also null
  Widget? _buildNodeFooter(UserPokemon? pokemon, int nodeIndex) {
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
  Widget _buildPokemonNodes() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: List.generate(
          _builderTeam.teamSize,
          (index) => Padding(
            padding: EdgeInsets.only(
              top: Sizing.blockSizeVertical * 1.0,
              bottom: Sizing.blockSizeVertical * 1.0,
              left: Sizing.blockSizeHorizontal * 2.0,
              right: Sizing.blockSizeHorizontal * 2.0,
            ),
            child: PokemonNode.large(
              pokemon: _builderTeam.getPokemon(index),
              onEmptyPressed: () => _onSearchPressed(index),
              onMoveChanged: _onPokemonMoveChanged,
              cup: _builderTeam.getCup(),
              footer: _buildNodeFooter(_builderTeam.getPokemon(index), index),
              padding: EdgeInsets.only(
                top: Sizing.blockSizeVertical * .7,
                left: Sizing.blockSizeHorizontal * 2.0,
                right: Sizing.blockSizeHorizontal * 2.0,
              ),
              lead: index == 0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _builderTeam = PogoData.getUserTeamSync(_builderTeam.id);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cup and team size dropdown menus at the top of the page
        Padding(
          padding: EdgeInsets.only(
            top: Sizing.blockSizeVertical * 2.0,
            bottom: Sizing.blockSizeVertical * 2.0,
            left: Sizing.blockSizeHorizontal * 2.0,
            right: Sizing.blockSizeHorizontal * 2.0,
          ),
          child: _buildHeaderDropdowns(_builderTeam.getCup()),
        ),
        _buildPokemonNodes(),
        MaterialButton(
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () => Navigator.pop(context),
          height: Sizing.blockSizeVertical * 7.0,
          child: Center(
            child: Icon(
              Icons.clear,
              size: Sizing.icon2,
            ),
          ),
        ),
      ],
    );
  }
}
