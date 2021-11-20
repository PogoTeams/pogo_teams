// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../configs/size_config.dart';
import '../../data/pokemon/pokemon.dart';

/*
-------------------------------------------------------------------------------
A button that displays at the bottom of a Pokemon node, indicating the user
can swap this Pokemon with another in their team.
-------------------------------------------------------------------------------
*/

class TeamSwapButton extends StatelessWidget {
  const TeamSwapButton({
    Key? key,
    required this.pokemon,
    required this.onTeamSwap,
  }) : super(key: key);

  final Pokemon pokemon;
  final Function(Pokemon) onTeamSwap;

  void _onPressed() {
    onTeamSwap(pokemon);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Container(
        height: SizeConfig.blockSizeVertical * 4.0,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5),
          color: Colors.black54,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.swap_horiz_rounded,
              size: SizeConfig.blockSizeHorizontal * 5.0,
              color: Colors.white,
            ),
            Text(
              'Team Swap',
              style: TextStyle(
                fontSize: SizeConfig.h3,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
