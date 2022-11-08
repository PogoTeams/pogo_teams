// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'pokemon_node.dart';
import '../../game_objects/cup.dart';
import '../../game_objects/pokemon.dart';
import '../../game_objects/pokemon_team.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
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
    required this.team,
    required this.cup,
    this.buildHeader = false,
    this.footer,
    this.focusIndex,
    this.emptyTransparent = false,
    this.collapsible = false,
    this.padding,
  }) : super(key: key);

  final Function(int) onPressed;
  final Function(int) onEmptyPressed;
  final PokemonTeam team;
  final Cup cup;

  final bool buildHeader;
  final Widget? footer;
  final int? focusIndex;
  final bool emptyTransparent;
  final bool collapsible;
  final EdgeInsets? padding;

  Widget _buildHeader(BuildContext context) {
    // Only applicable to user Pokemon teams
    if (team.runtimeType != UserPokemonTeam) return Container();

    return Padding(
      padding: EdgeInsets.only(
        left: Sizing.blockSizeHorizontal * 2.0,
        right: Sizing.blockSizeHorizontal * 2.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            cup.name,
            style: Theme.of(context).textTheme.headline6?.apply(
                  fontStyle: FontStyle.italic,
                ),
          ),
          Text(
            'Win Rate : ${(team as UserPokemonTeam).winRateString} %',
            style: Theme.of(context).textTheme.bodyLarge?.apply(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  // Build the grid view of the current Pokemon team
  Widget _buildPokemonNodes() {
    if (collapsible && team.isEmpty()) return Container();

    final pokemonTeam = team.pokemonTeam;

    if (focusIndex != null) {
      return _buildFocusNodes(pokemonTeam);
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: Sizing.blockSizeHorizontal * 3.0,
        mainAxisSpacing: Sizing.blockSizeHorizontal * 3.0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: pokemonTeam.length,
      itemBuilder: (context, index) => PokemonNode.square(
        onEmptyPressed: () => onEmptyPressed(index),
        pokemon: pokemonTeam[index],
        emptyTransparent: emptyTransparent,
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildFocusNodes(List<Pokemon?> pokemonTeam) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: Sizing.blockSizeHorizontal * 1.0,
        mainAxisSpacing: Sizing.blockSizeHorizontal * 1.0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: pokemonTeam.length,
      itemBuilder: (context, index) =>
          _buildFocusNode(pokemonTeam[index], index),
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
          width: Sizing.blockSizeHorizontal * 1.0,
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
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeVertical * 1.0,
        bottom: Sizing.blockSizeVertical * 1.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: PogoColors.getCupColor(cup.cupId),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              PogoColors.getCupColor(cup.cupId),
              const Color(0xBF29F19C),
            ],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(20),
        ),

        // The contents of the team node (Square Nodes and icons)
        child: Padding(
          padding: padding ??
              EdgeInsets.only(
                top: Sizing.blockSizeVertical * 1.0,
                left: Sizing.blockSizeHorizontal * 3.0,
                right: Sizing.blockSizeHorizontal * 3.0,
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Optional header build
              buildHeader ? _buildHeader(context) : Container(),

              // A gridview of the Pokemon in this team
              Padding(
                padding: EdgeInsets.only(
                  top: Sizing.blockSizeVertical,
                ),
                child: _buildPokemonNodes(),
              ),

              // Icon buttons for team operations
              footer ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
