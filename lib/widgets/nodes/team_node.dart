// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:provider/provider.dart';

// Local Imports
import 'square_pokemon_node.dart';
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
    required this.onClear,
    required this.onEdit,
    required this.teamIndex,
    required this.onEmptyPressed,
  }) : super(key: key);

  final Function(int) onClear;
  final Function(int) onEdit;
  final VoidCallback onEmptyPressed;
  final int teamIndex;

  // Build the grid view of the current Pokemon team
  Widget _buildPokemonNodes(List<Pokemon?> team) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: SizeConfig.blockSizeHorizontal * 4.0,
        mainAxisSpacing: SizeConfig.blockSizeHorizontal * 4.0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: team.length,
      itemBuilder: (context, index) => PokemonNode.square(
        onEmptyPressed: onEmptyPressed,
        pokemon: team[index],
        nodeIndex: index,
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  // Build a row of icon buttons at the bottom of a Pokemon's Node
  Widget _buildNodeFooter(BuildContext context) {
    // Size of the footer icons
    final double iconSize = SizeConfig.blockSizeHorizontal * 6.0;

    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 2.0,
        right: SizeConfig.blockSizeHorizontal * 2.0,
        bottom: SizeConfig.blockSizeVertical * 1.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Remove team
          IconButton(
            onPressed: () {
              onClear(teamIndex);
            },
            icon: const Icon(Icons.clear),
            tooltip: 'Remove Team',
            iconSize: iconSize,
            splashRadius: SizeConfig.blockSizeHorizontal * 6.0,
          ),

          // Edit team
          IconButton(
            onPressed: () {
              onEdit(teamIndex);
            },
            icon: const Icon(Icons.change_circle),
            tooltip: 'Edit Team',
            iconSize: iconSize,
            splashRadius: SizeConfig.blockSizeHorizontal * 6.0,
          ),
        ],
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
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5),
        ),

        // The contents of the team node (Square Nodes and icons)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.blockSizeVertical * 2.0,
                left: SizeConfig.blockSizeHorizontal * 6.0,
                right: SizeConfig.blockSizeHorizontal * 6.0,
                bottom: SizeConfig.blockSizeVertical * 1.0,
              ),
              // A gridview of the Pokemon in this team
              child: _buildPokemonNodes(team.team),
            ),

            // Icon buttons for team operations
            _buildNodeFooter(context),
          ],
        ),
      ),
    );
  }
}
