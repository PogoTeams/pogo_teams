// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../game_objects/pokemon.dart';
import '../../game_objects/move.dart';
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
        MoveNode(move: pokemon.selectedFastMove),
        MoveNode(move: pokemon.selectedChargeMoves[0]),
        MoveNode(move: pokemon.selectedChargeMoves[1]),
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
      child: Text(
        move.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      margin: EdgeInsets.only(
        top: Sizing.blockSizeVertical * .7,
      ),
      width: Sizing.blockSizeHorizontal * 28.0,
      height: Sizing.blockSizeVertical * 3.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1.5,
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moveColors
          .map(
            (color) => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: Sizing.blockSizeHorizontal * 0.3,
                ),
                color: color,
                borderRadius: BorderRadius.circular(100),
              ),
              height: Sizing.blockSizeHorizontal * 4.0,
              width: Sizing.blockSizeHorizontal * 5.0,
            ),
          )
          .toList(),
    );
  }
}
