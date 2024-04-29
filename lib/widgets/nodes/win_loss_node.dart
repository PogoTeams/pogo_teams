// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../enums/battle_outcome.dart';
import '../../app/ui/sizing.dart';
import '../../app/ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A dropdown button for selecting a "win", "tie", or "loss" for a match. This is
used in the battle log page where a user can report these matches as a
backlog.
-------------------------------------------------------------------------------
*/

class WinLossNode extends StatelessWidget {
  const WinLossNode({
    super.key,
    required this.outcome,
  });

  final BattleOutcome outcome;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Sizing.screenHeight(context) * .005,
        bottom: Sizing.screenHeight(context) * .005,
      ),
      alignment: Alignment.center,
      width: Sizing.screenWidth(context) * .15,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: Sizing.borderWidth,
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
