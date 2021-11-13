// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../data/cup.dart';
import '../../configs/size_config.dart';
import '../../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
A single dropdown button to display all pvp cup options.
The selected cup will affect all meta calculations
as well as the Pokemon's ideal IVs.
-------------------------------------------------------------------------------
*/

class CupDropdown extends StatefulWidget {
  const CupDropdown({
    Key? key,
    required this.cup,
    required this.onCupChanged,
  }) : super(key: key);

  final Cup cup;
  final void Function(String?) onCupChanged;

  @override
  _CupDropdownState createState() => _CupDropdownState();
}

class _CupDropdownState extends State<CupDropdown>
    with AutomaticKeepAliveClientMixin {
  // List of pvp cups
  final List<Cup> cups = globals.gamemaster.cups;

  // List of pvp cup names
  late final List<String> cupNames = cups.map((cup) => cup.title).toList();

  // List of dropdown menu items
  late final cupOptions =
      cupNames.map<DropdownMenuItem<String>>((String cupName) {
    return DropdownMenuItem(
      value: cupName,
      child: Center(
        child: Text(
          cupName,
          style: TextStyle(
            fontSize: SizeConfig.h2,
          ),
        ),
      ),
    );
  }).toList();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _selectedCup = widget.cup;

    return Container(
      alignment: Alignment.center,
      width: SizeConfig.screenWidth * .95,
      height: SizeConfig.blockSizeVertical * 4.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: SizeConfig.blockSizeHorizontal * .4,
        ),
        borderRadius: BorderRadius.circular(100.0),
        color: _selectedCup.cupColor,
      ),

      // Cup dropdown button
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: _selectedCup.title,
          icon: const Icon(Icons.arrow_drop_down),
          style: DefaultTextStyle.of(context).style,
          onChanged: widget.onCupChanged,
          items: cupOptions,
        ),
      ),
    );
  }
}
