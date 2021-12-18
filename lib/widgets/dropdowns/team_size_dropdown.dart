// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class TeamSizeDropdown extends StatefulWidget {
  const TeamSizeDropdown({
    Key? key,
    required this.size,
    required this.onTeamSizeChanged,
  }) : super(key: key);

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
              style: TextStyle(
                fontSize: SizeConfig.h2,
                color: size == widget.size ? Colors.yellow : Colors.white,
              ),
            ),
          ),
        );
      },
    ).toList();

    return Container(
      alignment: Alignment.center,
      width: SizeConfig.screenWidth * .2,
      height: SizeConfig.blockSizeVertical * 5.0,
      padding: EdgeInsets.only(
        right: SizeConfig.blockSizeHorizontal * 2.0,
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
          width: SizeConfig.blockSizeHorizontal * .4,
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),

      // Cup dropdown button
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: widget.size,
          icon: const Icon(Icons.arrow_drop_down_circle),
          style: DefaultTextStyle.of(context).style,
          onChanged: widget.onTeamSizeChanged,
          items: sizeOptions,
        ),
      ),
    );
  }
}
