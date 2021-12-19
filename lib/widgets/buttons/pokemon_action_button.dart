// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../configs/size_config.dart';
import '../../data/pokemon/pokemon.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A button that displays at the bottom of a Pokemon node, indicating the user
can perform an action with that Pokemon.
-------------------------------------------------------------------------------
*/

class PokemonActionButton extends StatelessWidget {
  const PokemonActionButton({
    Key? key,
    this.width = double.infinity,
    required this.pokemon,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final double width;
  final Pokemon pokemon;
  final String label;
  final Icon icon;
  final Function(Pokemon) onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 1.0,
        bottom: SizeConfig.blockSizeVertical * .5,
      ),
      child: MaterialButton(
        onPressed: () => onPressed(pokemon),
        child: Container(
          height: SizeConfig.blockSizeVertical * 4.0,
          width: width,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5),
            color: Colors.black54,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(
                label,
                style: TextStyle(
                  fontSize: SizeConfig.h3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
