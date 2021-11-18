// Dart Imports
import 'dart:math';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pogo_teams/data/rankings.dart';

// Local Imports
import '../../data/pokemon/typing.dart';
import '../../data/pokemon/pokemon_team.dart';
import '../../data/pokemon/pokemon.dart';
import '../nodes/pokemon_nodes.dart';
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
Based on the PokemonTeam provided, various analysis will be displayed to the
user. The user will also be able to make adjustments to the team, and see
realtime analysis updates.
-------------------------------------------------------------------------------
*/

class MetaThreats extends StatelessWidget {
  const MetaThreats({
    Key? key,
    required this.team,
    required this.typeThreats,
  }) : super(key: key);

  final PokemonTeam team;
  final List<Type> typeThreats;

  @override
  Widget build(BuildContext context) {
    final List<Pokemon> topPokemonThreats = team.cup
        .getFilteredRankedPokemonList(typeThreats, 'overall', limit: 20);

    return Column(
      children: topPokemonThreats
          .map(
            (pokemon) => Padding(
              padding:
                  EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 2.0),
              child: CompactPokemonNode(pokemon: pokemon),
            ),
          )
          .toList(),
    );
  }
}
