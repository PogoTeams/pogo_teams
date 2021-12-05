// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/pokemon/pokemon.dart';
import '../data/pokemon/pokemon_team.dart';
import 'colored_container.dart';

/*
-------------------------------------------------------------------------------
A vertically scrollable view of a list of Pokemon Teams. Each Pokemon will have
a square node within the team node. Two icon buttons will be available to
either remove or edit the team.
-------------------------------------------------------------------------------
*/

class TeamsList extends StatelessWidget {
  const TeamsList({
    Key? key,
    required this.teams,
    required this.cupColor,
    required this.onTeamCleared,
    required this.onEdit,
  }) : super(key: key);

  final List<List<Pokemon?>> teams;
  final Color cupColor;
  final Function(int) onTeamCleared;
  final Function(List<Pokemon?>, int) onEdit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: teams.length,
        itemBuilder: (context, index) {
          return TeamContainer(
            team: teams[index],
            cupColor: cupColor,
            teamIndex: index,
            onClear: onTeamCleared,
            onEdit: onEdit,
          );
        },
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}

class TeamContainer extends StatelessWidget {
  const TeamContainer({
    Key? key,
    required this.team,
    required this.cupColor,
    required this.teamIndex,
    required this.onClear,
    required this.onEdit,
  }) : super(key: key);

  final List<Pokemon?> team;
  final Color cupColor;
  final int teamIndex;
  final Function(int) onClear;
  final Function(List<Pokemon?>, int) onEdit;

  // Build a row of icon buttons at the bottom of a Pokemon's Node
  Row _buildNodeFooter() {
    // Size of the footer icons
    final double iconSize = SizeConfig.blockSizeHorizontal * 6.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            onClear(teamIndex);
          },
          icon: const Icon(Icons.clear),
          tooltip: 'Remove Team',
          iconSize: iconSize,
        ),
        IconButton(
          onPressed: () {
            onEdit(team, teamIndex);
          },
          icon: const Icon(Icons.swap_horiz),
          tooltip: 'Edit Team',
          iconSize: iconSize,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 1.0,
        bottom: SizeConfig.blockSizeVertical * 1.0,
      ),

      // Border to team node
      child: Container(
        height: SizeConfig.screenHeight * .22,
        decoration: BoxDecoration(
          color: cupColor,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cupColor, Colors.transparent],
            tileMode: TileMode.clamp,
          ),
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5),
        ),

        // The contents of the team node (Square Nodes and icons)
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 2.0,
            left: SizeConfig.blockSizeHorizontal * 1.0,
            right: SizeConfig.blockSizeHorizontal * 1.0,
            bottom: SizeConfig.blockSizeVertical * .3,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: team
                    .map((pokemon) => SquareTeamNode(pokemon: pokemon))
                    .toList(),
              ),
              _buildNodeFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class SquareTeamNode extends StatelessWidget {
  const SquareTeamNode({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final Pokemon? pokemon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.blockSizeHorizontal * 25.0,
      height: SizeConfig.blockSizeHorizontal * 25.0,
      child:
          pokemon == null ? Container() : SquarePokemonNode(pokemon: pokemon!),
    );
  }
}

class SquareEmptyNode extends StatelessWidget {
  const SquareEmptyNode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: SizeConfig.blockSizeHorizontal * 0.5,
        ),
        borderRadius:
            BorderRadius.circular(SizeConfig.blockSizeHorizontal * .5),
      ),
    );
  }
}

class SquarePokemonNode extends StatelessWidget {
  const SquarePokemonNode({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return ColoredContainer(
      pokemon: pokemon,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            pokemon.speciesName,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
