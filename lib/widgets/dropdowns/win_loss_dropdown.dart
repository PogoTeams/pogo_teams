// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';
import '../../modules/ui/pogo_colors.dart';
import '../../enums/battle_outcome.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A dropdown menu for indicating a "win", "tie" or "loss" for a match between the
user's team and a logged opponent team.
-------------------------------------------------------------------------------
*/

class WinLossDropdown extends StatefulWidget {
  const WinLossDropdown({
    Key? key,
    required this.selectedOption,
    required this.onChanged,
    required this.width,
  }) : super(key: key);

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
      height: Sizing.blockSizeVertical * 5.0,
      padding: EdgeInsets.only(
        right: Sizing.blockSizeHorizontal * 2.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: Sizing.blockSizeHorizontal * .4,
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
