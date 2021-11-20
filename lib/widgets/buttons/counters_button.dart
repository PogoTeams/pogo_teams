// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo_teams/widgets/buttons/filter_button.dart';
import 'package:pogo_teams/widgets/nodes/pokemon_nodes.dart';

// Local Imports
import '../../configs/size_config.dart';
import '../../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class CountersButton extends StatelessWidget {
  const CountersButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: SizeConfig.screenWidth * .025,
        left: SizeConfig.screenWidth * .025,
      ),
      // Analyze button
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5),
          color: Colors.black54,
        ),
        width: SizeConfig.screenWidth * .9,
        height: SizeConfig.blockSizeVertical * 3.5,
        child: PopupMenuButton<FooterPokemonNode>(
          itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<FooterPokemonNode>>[
            PopupMenuItem<FooterPokemonNode>(
              child: FooterPokemonNode(
                pokemon: globals.gamemaster.pokemonIdMap['bulbasaur']!,
                footerChild: CountersButton(
                  onPressed: () {},
                ),
              ),
            ),
          ],
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Counters ',
                style: TextStyle(
                  fontSize: SizeConfig.h3,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.search,
                size: SizeConfig.blockSizeHorizontal * 3.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
