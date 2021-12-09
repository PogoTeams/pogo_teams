// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:provider/provider.dart';

// Local Imports
import 'pokemon_node.dart';
import '../../configs/size_config.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/pokemon_team.dart';

/*
-------------------------------------------------------------------------------
A top level view of a Pokemon team. Each Pokemon (or lack there of) is
displayed in a square node, any null space in the team is a button that will
call onEmptyPressed. Every team is provided an index, via the TeamBuilder,
which allows for any team changes, to be reflected at the provider level.
-------------------------------------------------------------------------------
*/

class TeamNode extends StatelessWidget {
  const TeamNode({
    Key? key,
    required this.onPressed,
    required this.onEmptyPressed,
    required this.teamIndex,
    this.footer,
    this.focusIndex,
    this.emptyTransparent = false,
  }) : super(key: key);

  final Function(int) onPressed;
  final Function(int) onEmptyPressed;
  final int teamIndex;

  final Widget? footer;
  final int? focusIndex;
  final bool emptyTransparent;

  // Build the grid view of the current Pokemon team
  Widget _buildPokemonNodes(List<Pokemon?> team) {
    if (focusIndex != null) {
      return _buildFocusNodes(team);
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: SizeConfig.blockSizeHorizontal * 3.0,
        mainAxisSpacing: SizeConfig.blockSizeHorizontal * 3.0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: team.length,
      itemBuilder: (context, index) => PokemonNode.square(
        onEmptyPressed: () => onEmptyPressed(index),
        pokemon: team[index],
        emptyTransparent: emptyTransparent,
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildFocusNodes(List<Pokemon?> team) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: SizeConfig.blockSizeHorizontal * 1.0,
        mainAxisSpacing: SizeConfig.blockSizeHorizontal * 1.0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: team.length,
      itemBuilder: (context, index) => _buildFocusNode(team[index], index),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  // If the focus index is provided, draw a special border
  // This indicates the current 'focus' node
  Widget _buildFocusNode(Pokemon? pokemon, int index) {
    Color _color;

    if (index == focusIndex) {
      _color = Colors.amber;
    } else {
      _color = Colors.transparent;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: SizeConfig.blockSizeHorizontal * 1.0,
          color: _color,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: PokemonNode.square(
        onPressed: () => onPressed(index),
        onEmptyPressed: () => onEmptyPressed(index),
        pokemon: pokemon,
        emptyTransparent: emptyTransparent,
        padding: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve this node's team
    final team = Provider.of<PokemonTeams>(context).pokemonTeams[teamIndex];

    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 1.0,
        bottom: SizeConfig.blockSizeVertical * 1.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: team.cup.cupColor,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [team.cup.cupColor, Colors.transparent],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(20),
        ),

        // The contents of the team node (Square Nodes and icons)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 1.5,
                left: SizeConfig.blockSizeHorizontal * 3.0,
                right: SizeConfig.blockSizeHorizontal * 3.0,
                bottom: SizeConfig.blockSizeVertical * 1.0,
              ),
              // A gridview of the Pokemon in this team
              child: _buildPokemonNodes(team.team),
            ),

            // Icon buttons for team operations
            footer ?? Container(),
          ],
        ),
      ),
    );
  }
}
