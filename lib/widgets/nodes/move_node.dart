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
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 2.0,
              right: 2.0,
            ),
            child: MoveNode(move: pokemon.getSelectedFastMove()),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 2.0,
              right: 2.0,
            ),
            child: MoveNode(move: pokemon.getSelectedChargeMoveL()),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 2.0,
              right: 2.0,
            ),
            child: MoveNode(move: pokemon.getSelectedChargeMoveR()),
          ),
        ),
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
      margin: EdgeInsets.only(
        top: Sizing.screenHeight(context) * .007,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: Sizing.borderWidthThin,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: moveColors
              .map(
                (color) => Padding(
                  padding: const EdgeInsets.only(
                    left: 2.0,
                    right: 2.0,
                  ),
                  child: Container(
                    width: constraints.maxHeight,
                    height: constraints.maxHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: Sizing.borderWidthThin,
                      ),
                      color: color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
