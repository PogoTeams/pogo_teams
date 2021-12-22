// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../data/pokemon/pokemon.dart';
import '../../data/pokemon/move.dart';
import '../../configs/size_config.dart';

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
        MoveNode(move: pokemon.selectedChargedMoves[0]),
        MoveNode(move: pokemon.selectedChargedMoves[1]),
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
        style: TextStyle(
          fontFamily: DefaultTextStyle.of(context).style.fontFamily,
          fontSize: SizeConfig.h3,
        ),
      ),
      margin: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * .7,
      ),
      width: SizeConfig.blockSizeHorizontal * 28.0,
      height: SizeConfig.blockSizeVertical * 3.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(100.0),
        color: move.type.typeColor,
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
                  width: SizeConfig.blockSizeHorizontal * 0.3,
                ),
                color: color,
                borderRadius: BorderRadius.circular(100),
              ),
              height: SizeConfig.blockSizeHorizontal * 4.0,
              width: SizeConfig.blockSizeHorizontal * 5.0,
            ),
          )
          .toList(),
    );
  }
}
