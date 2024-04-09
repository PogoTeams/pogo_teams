// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'pokemon_node.dart';
import '../tag_dot.dart';
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/pokemon_team.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class TeamNode extends StatelessWidget {
  const TeamNode({
    Key? key,
    required this.onPressed,
    required this.onEmptyPressed,
    required this.team,
    this.onTagPressed,
    this.header,
    this.footer,
    this.focusIndex,
    this.emptyTransparent = false,
    this.collapsible = false,
  }) : super(key: key);

  final Function(int) onPressed;
  final Function(int) onEmptyPressed;
  final PokemonTeam team;
  final void Function()? onTagPressed;

  final Widget? header;
  final Widget? footer;
  final int? focusIndex;
  final bool emptyTransparent;
  final bool collapsible;

  bool _pokemonTeamIsEmpty() {
    for (var pokemon in team.getOrderedPokemonListFilled()) {
      if (pokemon != null) return false;
    }
    return true;
  }

  // Build the grid view of the current Pokemon team
  Widget _buildPokemonNodes(BuildContext context) {
    if (collapsible && _pokemonTeamIsEmpty()) return Container();

    if (focusIndex != null) {
      return _buildFocusNodes();
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: Sizing.blockSizeHorizontal * 3.0,
        mainAxisSpacing: Sizing.blockSizeHorizontal * 3.0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: team.teamSize,
      itemBuilder: (context, index) {
        return _buildPokemonNode(index);
      },
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildFocusNodes() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: Sizing.blockSizeHorizontal * 1.0,
        mainAxisSpacing: Sizing.blockSizeHorizontal * 1.0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: team.teamSize,
      itemBuilder: (context, index) =>
          _buildFocusNode(team.getPokemon(index), index),
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  // If the focus index is provided, draw a special border
  // This indicates the current 'focus' node
  Widget _buildFocusNode(UserPokemon? pokemon, int index) {
    Color color;

    if (index == focusIndex) {
      color = Colors.amber;
    } else {
      color = Colors.transparent;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: Sizing.blockSizeHorizontal * 1.0,
          color: color,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: _buildPokemonNode(index),
    );
  }

  Widget _buildPokemonNode(int index) {
    return PokemonNode.square(
      onEmptyPressed: () => onEmptyPressed(index),
      onPressed: () => onPressed(index),
      pokemon: team.getPokemon(index),
      emptyTransparent: emptyTransparent,
      lead: index == 0,
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              PogoColors.getCupColor(team.getCup()),
              const Color(0xBF29F19C),
            ],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(20),
        ),

        // The contents of the team node (Square Nodes and icons)
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Optional header build
            if (header != null) header!,

            // A gridview of the Pokemon in this team
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MediaQuery.removePadding(
                removeBottom: true,
                context: context,
                child: _buildPokemonNodes(context),
              ),
            ),

            // Icon buttons for team operations
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

class UserTeamNodeHeader extends StatelessWidget {
  const UserTeamNodeHeader({
    Key? key,
    required this.team,
    required this.onTagTeam,
  }) : super(key: key);

  final UserPokemonTeam team;
  final Function(UserPokemonTeam) onTagTeam;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 22.0,
        right: 22.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  team.getCup().name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Win Rate : ${team.getWinRate()} %',
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          // Tag
          Row(
            children: [
              if (team.getTag() != null)
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    team.getTag()!.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              TagDot(
                tag: team.getTag(),
                onPressed: () => onTagTeam(team),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserTeamNodeFooter extends StatelessWidget {
  const UserTeamNodeFooter({
    Key? key,
    required this.team,
    required this.onClear,
    required this.onBuild,
    required this.onTag,
    required this.onLog,
    required this.onLock,
    required this.onAnalyze,
  }) : super(key: key);

  final UserPokemonTeam team;
  final Function(UserPokemonTeam) onClear;
  final Function(UserPokemonTeam) onBuild;
  final Function(UserPokemonTeam) onTag;
  final Function(UserPokemonTeam) onLog;
  final Function(UserPokemonTeam) onLock;
  final Function(UserPokemonTeam) onAnalyze;

  // The icon buttons at the footer of each TeamNode
  Widget _buildIconButtons() {
    final IconData lockIcon = team.locked ? Icons.lock : Icons.lock_open;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remove team option if the team is unlocked
        if (!team.locked)
          IconButton(
            onPressed: () => onClear(team),
            icon: Icon(
              Icons.clear,
              size: Sizing.icon3,
            ),
            tooltip: 'Remove Team',
            splashRadius: Sizing.blockSizeHorizontal * 5.0,
          ),

        // Edit team
        IconButton(
          onPressed: () => onBuild(team),
          icon: Icon(
            Icons.build_circle,
            size: Sizing.icon3,
          ),
          tooltip: 'Edit Team',
          splashRadius: Sizing.blockSizeHorizontal * 5.0,
        ),

        // Tag team
        IconButton(
          onPressed: () => onTag(team),
          icon: Icon(
            Icons.tag,
            size: Sizing.icon3,
          ),
          tooltip: 'Tag Team',
          splashRadius: Sizing.blockSizeHorizontal * 5.0,
        ),

        // Log team
        IconButton(
          onPressed: () => onLog(team),
          icon: Icon(
            Icons.query_stats,
            size: Sizing.icon3,
          ),
          tooltip: 'Log Team',
          splashRadius: Sizing.blockSizeHorizontal * 5.0,
        ),

        IconButton(
          onPressed: () => onLock(team),
          icon: Icon(
            lockIcon,
            size: Sizing.icon3,
          ),
          tooltip: 'Toggle Team Lock',
          splashRadius: Sizing.blockSizeHorizontal * 5.0,
        )
      ],
    );
  }

  Widget _buildAnalysisFooter(BuildContext context) {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      onPressed: () => onAnalyze(team),
      child: Container(
        height: Sizing.blockSizeVertical * 5.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PogoColors.getPokemonTypeColor('fire'),
              PogoColors.getPokemonTypeColor('ice'),
            ],
            tileMode: TileMode.clamp,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: Sizing.blockSizeHorizontal * 2.0,
            right: Sizing.blockSizeHorizontal * 2.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.analytics,
                size: Sizing.icon3,
              ),
              SizedBox(
                width: Sizing.blockSizeHorizontal * 2.0,
              ),
              Text(
                'Analysis',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildIconButtons(),
        _buildAnalysisFooter(context),
      ],
    );
  }
}
