// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../app/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
For selecting the size of a user's team. This will always be 3 by default, but
do to custom tournaments it can be helpful to do an analysis on teams of 6.
All logged Pokemon teams under this team will then be adjusted to be of size 6.
-------------------------------------------------------------------------------
*/

class TeamSizeDropdown extends StatefulWidget {
  const TeamSizeDropdown({
    super.key,
    required this.size,
    required this.onTeamSizeChanged,
  });

  final void Function(int?) onTeamSizeChanged;
  final int size;

  @override
  _TeamSizeDropdownState createState() => _TeamSizeDropdownState();
}

class _TeamSizeDropdownState extends State<TeamSizeDropdown>
    with AutomaticKeepAliveClientMixin {
  // List of pvp cup names
  final List<int> sizes = [3, 6];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // List of dropdown menu items
    final sizeOptions = sizes.map<DropdownMenuItem<int>>(
      (int size) {
        return DropdownMenuItem(
          value: size,
          child: Center(
            child: Text(
              size.toString(),
              style: Theme.of(context).textTheme.headlineSmall?.apply(
                    color: size == widget.size ? Colors.yellow : Colors.white,
                  ),
            ),
          ),
        );
      },
    ).toList();

    return Container(
      alignment: Alignment.center,
      width: Sizing.screenWidth(context) * .2,
      padding: EdgeInsets.only(
        right: Sizing.screenWidth(context) * .02,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Colors.transparent,
          ],
          tileMode: TileMode.clamp,
        ),
        border: Border.all(
          color: Colors.white,
          width: Sizing.borderWidth,
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),

      // Cup dropdown button
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: widget.size,
          icon: const Icon(
            Icons.arrow_drop_down_circle,
          ),
          style: DefaultTextStyle.of(context).style,
          onChanged: widget.onTeamSizeChanged,
          items: sizeOptions,
        ),
      ),
    );
  }
}
