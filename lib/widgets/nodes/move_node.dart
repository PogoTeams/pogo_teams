// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../model/pokemon.dart';
import '../../model/move.dart';
import '../../app/ui/sizing.dart';
import '../../app/ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Any Pokemon move displays that are not a dropdown are managed by these
MoveNodes.
-------------------------------------------------------------------------------
*/

class MoveNodes extends StatelessWidget {
  const MoveNodes({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MoveNode(move: pokemon.getSelectedFastMove()),
        MoveNode(move: pokemon.getSelectedChargeMoveL()),
        MoveNode(move: pokemon.getSelectedChargeMoveR()),
      ],
    );
  }
}

class MoveNode extends StatelessWidget {
  const MoveNode({
    super.key,
    required this.move,
  });

  final Move move;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: Sizing.screenWidth(context) * .28,
      height: 35.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1.1,
        ),
        borderRadius: BorderRadius.circular(100.0),
        color: PogoColors.getPokemonTypeColor(move.type.typeId),
      ),
      child: FittedBox(
        child: Text(
          move.name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class MoveDots extends StatelessWidget {
  const MoveDots({
    super.key,
    required this.moveColors,
  });

  final List<Color> moveColors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: moveColors
          .map(
            (color) => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
                color: color,
                borderRadius: BorderRadius.circular(100),
              ),
              width: 20.0,
              height: 20.0,
            ),
          )
          .toList(),
    );
  }
}
