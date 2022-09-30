// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';
import '../../pogo_data/pokemon.dart';

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
        top: Sizing.blockSizeVertical * 1.0,
        bottom: Sizing.blockSizeVertical * .5,
      ),
      child: MaterialButton(
        onPressed: () => onPressed(pokemon),
        child: Container(
          height: Sizing.blockSizeVertical * 4.0,
          width: width,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(Sizing.blockSizeHorizontal * 2.5),
            color: Colors.black54,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(
                label,
                style: TextStyle(
                  fontSize: Sizing.h3,
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
