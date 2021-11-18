// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Local Imports
import 'coverage_graph.dart';
import 'coverage_grids.dart';
import 'meta_lists.dart';
import '../../tools/pair.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/masters/type_master.dart';
import '../../data/pokemon/typing.dart';
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
Team offense & defense coverage visualizers. The user will get a list of
noteable type threats, offense moveset coverage, and a bar graph expressing
the 'net coverage' of the team. The 'net coverage' factors both normalized
defense and offense values across the team, it's more or less a way to see
which types your team will likely excel against.
-------------------------------------------------------------------------------
*/

class TeamCoverage extends StatelessWidget {
  const TeamCoverage({
    Key? key,
    required this.team,
  }) : super(key: key);

  final PokemonTeam team;

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Horizontal divider
        Divider(
          height: blockSize * 5.0,
          thickness: blockSize * .5,
          indent: blockSize * 1.5,
          endIndent: blockSize * 1.5,
          color: Colors.white54,
        ),

        // Spacer
        SizedBox(
          height: blockSize * 2.5,
        ),

        MetaLists(team: team),
      ],
    );
  }
}
