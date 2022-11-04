// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';

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

  final String selectedOption;
  final void Function(String?) onChanged;
  final double width;

  @override
  _WinLossDropdownState createState() => _WinLossDropdownState();
}

class _WinLossDropdownState extends State<WinLossDropdown>
    with AutomaticKeepAliveClientMixin {
  final List<String> optionStrings = ['Win', 'Tie', 'Loss'];

  // List of dropdown menu items
  late final options = optionStrings.map<DropdownMenuItem<String>>(
    (String optionString) {
      return DropdownMenuItem(
        value: optionString,
        child: Center(
          child: Text(
            optionString,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );
    },
  ).toList();

  Color _getColor() {
    Color color;

    switch (widget.selectedOption) {
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
        color: _getColor(),
      ),

      // Cup dropdown button
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: widget.selectedOption,
          icon: const Icon(Icons.arrow_drop_down_circle),
          style: DefaultTextStyle.of(context).style,
          onChanged: widget.onChanged,
          items: options,
        ),
      ),
    );
  }
}
