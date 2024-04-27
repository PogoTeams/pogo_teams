// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../app/ui/sizing.dart';
import '../../app/ui/pogo_colors.dart';
import '../../enums/battle_outcome.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A dropdown menu for indicating a "win", "tie" or "loss" for a match between the
user's team and a logged opponent team.
-------------------------------------------------------------------------------
*/

class WinLossDropdown extends StatefulWidget {
  const WinLossDropdown({
    super.key,
    required this.selectedOption,
    required this.onChanged,
    required this.width,
  });

  final BattleOutcome selectedOption;
  final void Function(BattleOutcome?) onChanged;
  final double width;

  @override
  _WinLossDropdownState createState() => _WinLossDropdownState();
}

class _WinLossDropdownState extends State<WinLossDropdown>
    with AutomaticKeepAliveClientMixin {
  List<DropdownMenuItem<BattleOutcome>> _buildOptions() {
    return BattleOutcome.values.map<DropdownMenuItem<BattleOutcome>>(
      (BattleOutcome outcome) {
        return DropdownMenuItem(
          value: outcome,
          child: Center(
            child: Text(
              outcome.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      alignment: Alignment.center,
      width: widget.width,
      height: Sizing.screenHeight(context) * .05,
      padding: EdgeInsets.only(
        right: Sizing.screenWidth(context) * .02,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: Sizing.borderWidth,
        ),
        borderRadius: BorderRadius.circular(100.0),
        color: PogoColors.getBattleOutcomeColor(widget.selectedOption),
      ),

      // Cup dropdown button
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: widget.selectedOption,
          icon: const Icon(Icons.arrow_drop_down_circle),
          style: DefaultTextStyle.of(context).style,
          onChanged: widget.onChanged,
          items: _buildOptions(),
        ),
      ),
    );
  }
}
