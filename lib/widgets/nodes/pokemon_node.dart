// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'empty_node.dart';
import '../pvp_stats.dart';
import '../colored_container.dart';
import '../traits_icons.dart';
import '../dropdowns/move_dropdowns.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/cup.dart';
import '../../configs/size_config.dart';
import '../../screens/pokemon_search.dart';

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class PokemonContainer extends StatefulWidget {
  const PokemonContainer({
    Key? key,
    required this.onNodeChanged,
    required this.nodeIndex,
    required this.team,
  }) : super(key: key);

  final Function(int index, Pokemon?) onNodeChanged;
  final int nodeIndex;
  final PokemonTeam team;

  @override
  _PokemonContainerState createState() => _PokemonContainerState();
}

class _PokemonContainerState extends State<PokemonContainer> {
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
      height: SizeConfig.screenHeight * .2,

      // If the Pokemon ref is null, build an empty node
      // Otherwise build a Pokemon node with cooresponding data
      child: (widget.team.isNull(widget.nodeIndex)
          ? EmptyNode(
              onPressed: _searchMode,
            )
          : PokemonNerd(
              nodeIndex: widget.nodeIndex,
              pokemon: widget.team.getPokemon(widget.nodeIndex),
              cup: widget.team.cup,
              searchMode: _searchMode,
              clear: _clearNode,
            )),
    );
  }
}

class PokemonNerd extends StatelessWidget {
  const PokemonNerd({
    Key? key,
    required this.nodeIndex,
    required this.pokemon,
    required this.cup,
    required this.searchMode,
    required this.clear,
  }) : super(key: key);

  final int nodeIndex;
  final Pokemon pokemon;
  final Cup cup;

  // Search for a new Pokemon
  final VoidCallback searchMode;

  // Remove the Pokemon and restore to an EmptyNode
  final VoidCallback clear;

  // Display the Pokemon's name perfect PVP ivs and typing icon(s)
  Row _buildNodeHeader(Pokemon pokemon, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pokemon name
        Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.0),
          child: Text(
            pokemon.speciesName,
            style: TextStyle(
              fontSize: SizeConfig.h1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // The perfect IVs for this Pokemon given the selected cup
        PvpStats(
          perfectStats: pokemon.getPerfectPvpStats(cup.cp),
        ),

        // Typing icon(s)
        Container(
          alignment: Alignment.topRight,
          height: SizeConfig.blockSizeHorizontal * 8.0,
          child: Row(
            children: pokemon.getTypeIcons(),
          ),
        ),
      ],
    );
  }

  // Build a row of icon buttons at the bottom of a Pokemon's Node
  Row _buildNodeFooter() {
    // Size of the footer icons
    final double iconSize = SizeConfig.blockSizeHorizontal * 6.2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: clear,
          icon: const Icon(Icons.clear),
          tooltip: 'remove this pokemon from your team',
          iconSize: iconSize,
        ),

        // Traits Icons
        TraitsIcons(pokemon: pokemon),

        IconButton(
          onPressed: searchMode,
          icon: const Icon(Icons.swap_horiz),
          tooltip: 'search for a different pokemon',
          iconSize: iconSize,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredContainer(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeHorizontal * 1.0,
        right: SizeConfig.blockSizeHorizontal * 2.2,
        bottom: SizeConfig.blockSizeHorizontal * .5,
        left: SizeConfig.blockSizeHorizontal * 2.2,
      ),
      pokemon: pokemon,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pokemon name, perfect IVs, and typing icons
          _buildNodeHeader(pokemon, context),

          // A line divider
          Divider(
            color: Colors.white,
            thickness: SizeConfig.blockSizeHorizontal * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          MoveDropdowns(pokemon: pokemon),

          // Icon buttons to remove, replace or toggle shadow of a Pokemon
          _buildNodeFooter(),
        ],
      ),
    );
  }
}

class CompactPokemonNode extends StatelessWidget {
  const CompactPokemonNode({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  // The Pokemon name and type icon(s)
  Row _buildNodeHeader(Pokemon pokemon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pokemon name
        Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.0),
          alignment: Alignment.topLeft,
          child: Text(
            pokemon.speciesName,
            style: TextStyle(
              fontSize: SizeConfig.h1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Traits Icons
        TraitsIcons(pokemon: pokemon),

        // Typing icon(s)
        Container(
          alignment: Alignment.topRight,
          height: SizeConfig.blockSizeHorizontal * 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: pokemon.getTypeIcons(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredContainer(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeHorizontal * 1.3,
        right: SizeConfig.blockSizeHorizontal * 2.2,
        bottom: SizeConfig.blockSizeHorizontal * 5.0,
        left: SizeConfig.blockSizeHorizontal * 2.2,
      ),
      pokemon: pokemon,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNodeHeader(pokemon),

          // A line divider
          Divider(
            color: Colors.white,
            thickness: SizeConfig.blockSizeHorizontal * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          MoveDropdowns(pokemon: pokemon),
        ],
      ),
    );
  }
}

class FooterPokemonNode extends StatelessWidget {
  const FooterPokemonNode({
    Key? key,
    required this.pokemon,
    required this.footerChild,
  }) : super(key: key);

  final Pokemon pokemon;
  final Widget footerChild;

  // The Pokemon name and type icon(s)
  Row _buildNodeHeader(Pokemon pokemon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pokemon name
        Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.0),
          alignment: Alignment.topLeft,
          child: Text(
            pokemon.speciesName,
            style: TextStyle(
              fontSize: SizeConfig.h1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Traits Icons
        TraitsIcons(pokemon: pokemon),

        // Typing icon(s)
        Container(
          alignment: Alignment.topRight,
          height: SizeConfig.blockSizeHorizontal * 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: pokemon.getTypeIcons(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredContainer(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeHorizontal * 1.3,
        right: SizeConfig.blockSizeHorizontal * 2.2,
        bottom: SizeConfig.blockSizeHorizontal * 5.0,
        left: SizeConfig.blockSizeHorizontal * 2.2,
      ),
      pokemon: pokemon,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNodeHeader(pokemon),

          // A line divider
          Divider(
            color: Colors.white,
            thickness: SizeConfig.blockSizeHorizontal * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          MoveDropdowns(pokemon: pokemon),

          // Spacer
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.0,
          ),

          footerChild,
        ],
      ),
    );
  }
}
