// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../app/ui/sizing.dart';
import '../../model/pokemon.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A button that displays at the bottom of a Pokemon node, indicating the user
can perform an action with that Pokemon.
-------------------------------------------------------------------------------
*/

class PokemonActionButton extends StatelessWidget {
  const PokemonActionButton({
    super.key,
    this.width = double.infinity,
    required this.pokemon,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final double width;
  final Pokemon pokemon;
  final String label;
  final Icon icon;
  final Function(Pokemon) onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.screenHeight(context) * .01,
        bottom: Sizing.screenHeight(context) * .005,
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () => onPressed(pokemon),
        child: Container(
          height: Sizing.screenHeight(context) * .04,
          width: width,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(Sizing.screenWidth(context) * .025),
            color: Colors.black54,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
