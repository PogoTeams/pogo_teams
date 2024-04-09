// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../enums/battle_outcome.dart';
import '../../modules/ui/sizing.dart';
import '../../modules/ui/pogo_colors.dart';

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
    required this.outcome,
  }) : super(key: key);

  final BattleOutcome outcome;

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
        borderRadius: BorderRadius.circular(15.0),
        color: PogoColors.getBattleOutcomeColor(outcome),
      ),

      // Cup dropdown button
      child: Text(
        outcome.name,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
