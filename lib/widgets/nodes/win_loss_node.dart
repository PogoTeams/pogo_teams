// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A dropdown button for selecting a "win", "tie", or "loss" for a match. This is
used in the battle log page where a user can report these matches as a
backlog.
-------------------------------------------------------------------------------
*/

class WinLossNode extends StatelessWidget {
  const WinLossNode({
    Key? key,
    required this.winLossKey,
  }) : super(key: key);

  final String winLossKey;

  Color _getColor() {
    Color color;

    switch (winLossKey) {
      case 'Win':
        color = Colors.green;
        break;

      case 'Tie':
        color = Colors.grey;
        break;

      case 'Loss':
        color = Colors.red;
        break;

      default:
        color = Colors.green;
        break;
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeVertical * .5,
        bottom: Sizing.blockSizeVertical * .5,
      ),
      alignment: Alignment.center,
      width: Sizing.blockSizeHorizontal * 15.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: Sizing.blockSizeHorizontal * .4,
        ),
        borderRadius: BorderRadius.circular(100),
        color: _getColor(),
      ),

      // Cup dropdown button
      child: Text(
        winLossKey,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Sizing.h3,
        ),
      ),
    );
  }
}
