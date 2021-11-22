// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../data/pokemon/pokemon.dart';
import '../../data/cup.dart';
import '../colored_container.dart';
import '../traits_icons.dart';
import '../../configs/size_config.dart';
import '../pvp_stats.dart';
import '../dropdowns/move_dropdowns.dart';

/*
-------------------------------------------------------------------------------
These 'nodes' are merely Pokemon containers, that will conditionally render
information about a given Pokemon. Depending on the type of node, there will
be different functionality, such as icon buttons, dropdown menus, colored
themes and more.
-------------------------------------------------------------------------------
*/

class PokemonNode extends StatelessWidget {
  const PokemonNode({
    Key? key,
    required this.nodeIndex,
    required this.pokemon,
    required this.cup,
    required this.searchMode,
    required this.clear,
    required this.onNodeChanged,
  }) : super(key: key);

  final int nodeIndex;
  final Pokemon pokemon;
  final Cup cup;

  // Search for a new Pokemon
  final VoidCallback searchMode;

  // Remove the Pokemon and restore to an EmptyNode
  final VoidCallback clear;

  // Callback to rebuild page when a Pokemon move is changed
  final Function(int, Pokemon) onNodeChanged;

  void _onMoveNodeChanged() {
    onNodeChanged(nodeIndex, pokemon);
  }

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
            children: pokemon.getTypeIcons(iconColor: 'white'),
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
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return ColoredContainer(
      padding: EdgeInsets.only(
        top: blockSize * 1.0,
        right: blockSize * 2.2,
        bottom: blockSize * .5,
        left: blockSize * 2.2,
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
            thickness: blockSize * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          MoveDropdowns(
            pokemon: pokemon,
            fastMoveNames: pokemon.getFastMoveIds(),
            chargedMoveNames: pokemon.getChargedMoveIds(),
            onNodeChanged: _onMoveNodeChanged,
          ),

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
            children: pokemon.getTypeIcons(iconColor: 'white'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return ColoredContainer(
      padding: EdgeInsets.only(
        top: blockSize * 1.3,
        right: blockSize * 2.2,
        bottom: blockSize * 5.0,
        left: blockSize * 2.2,
      ),
      pokemon: pokemon,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNodeHeader(pokemon),

          // A line divider
          Divider(
            color: Colors.white,
            thickness: blockSize * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          MoveDropdowns(
            pokemon: pokemon,
            fastMoveNames: pokemon.getFastMoveIds(),
            chargedMoveNames: pokemon.getChargedMoveIds(),
            onNodeChanged: () {},
          ),
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
            children: pokemon.getTypeIcons(iconColor: 'white'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return ColoredContainer(
      padding: EdgeInsets.only(
        top: blockSize * 1.3,
        right: blockSize * 2.2,
        bottom: blockSize * 5.0,
        left: blockSize * 2.2,
      ),
      pokemon: pokemon,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNodeHeader(pokemon),

          // A line divider
          Divider(
            color: Colors.white,
            thickness: blockSize * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          MoveDropdowns(
            pokemon: pokemon,
            fastMoveNames: pokemon.getFastMoveIds(),
            chargedMoveNames: pokemon.getChargedMoveIds(),
            onNodeChanged: () {},
          ),

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
