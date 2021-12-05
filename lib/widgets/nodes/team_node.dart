// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../nodes/pokemon_nodes.dart';
import '../nodes/empty_node.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/pokemon.dart';
import '../../configs/size_config.dart';
import '../../screens/pokemon_search.dart';

/*
-------------------------------------------------------------------------------
A TeamNode is either an EmptyNode or PokemonNode. An EmptyNode can be tapped
by the user to add a Pokemon to it, after a Pokemon is added it is a
PokemonNode.
-------------------------------------------------------------------------------
*/

class TeamNode extends StatefulWidget {
  const TeamNode({
    Key? key,
    required this.nodeIndex,
    required this.team,
    required this.onNodeChanged,
  }) : super(key: key);

  final int nodeIndex;
  final PokemonTeam team;
  final Function(int index, Pokemon?) onNodeChanged;

  @override
  _TeamNodeState createState() => _TeamNodeState();
}

class _TeamNodeState extends State<TeamNode> {
  // Open a new app page that allows the user to search for a given Pokemon
  // If a Pokemon is selected in that page, the Pokemon reference will be kept
  // The node will then populate all data related to that Pokemon
  _searchMode() async {
    final newPokemon = await Navigator.push(
      context,
      MaterialPageRoute<Pokemon>(builder: (BuildContext context) {
        return PokemonSearch(
          team: widget.team,
        );
      }),
    );

    // If a pokemon was returned from the search page, update the node
    // Should only be null when the user exits the search page using the app bar
    if (newPokemon != null) {
      widget.onNodeChanged(widget.nodeIndex, newPokemon);
    }
  }

  // Revert a PokemonNode back to an EmptyNode
  _clearNode() {
    widget.onNodeChanged(widget.nodeIndex, null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight * .19,

      // If the Pokemon ref is null, build an empty node
      // Otherwise build a Pokemon node with cooresponding data
      child: (widget.team.isNull(widget.nodeIndex)
          ? EmptyNode(
              onPressed: _searchMode,
            )
          : PokemonNode(
              nodeIndex: widget.nodeIndex,
              pokemon: widget.team.getPokemon(widget.nodeIndex),
              cup: widget.team.cup,
              searchMode: _searchMode,
              clear: _clearNode,
              onNodeChanged: widget.onNodeChanged,
            )),
    );
  }
}
