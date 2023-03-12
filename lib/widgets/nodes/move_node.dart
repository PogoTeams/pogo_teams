// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../pogo_objects/pokemon.dart';
import '../../pogo_objects/move.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Any Pokemon move displays that are not a dropdown are managed by these
MoveNodes.
-------------------------------------------------------------------------------
*/

class MoveNodes extends StatelessWidget {
  const MoveNodes({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

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
    Key? key,
    required this.move,
  }) : super(key: key);

  final Move move;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FittedBox(
        child: Text(
          move.name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      margin: EdgeInsets.only(
        top: Sizing.blockSizeVertical * .7,
      ),
      width: Sizing.blockSizeHorizontal * 28.0,
      height: Sizing.blockSizeVertical * 3.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1.1,
        ),
        borderRadius: BorderRadius.circular(100.0),
        color: PogoColors.getPokemonTypeColor(move.type.typeId),
      ),
    );
  }
}

class MoveDots extends StatelessWidget {
  const MoveDots({
    Key? key,
    required this.moveColors,
  }) : super(key: key);

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
                  width: Sizing.blockSizeHorizontal * 0.4,
                ),
                color: color,
                borderRadius: BorderRadius.circular(100),
              ),
              height: Sizing.blockSizeHorizontal * 5.0,
              width: Sizing.blockSizeHorizontal * 5.0,
            ),
          )
          .toList(),
    );
  }
}
