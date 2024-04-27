// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../model/cup.dart';
import '../../app/ui/sizing.dart';
import '../../app/ui/pogo_colors.dart';
import '../../modules/pogo_repository.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A single dropdown button to display all pvp cup options.
The selected cup will affect all meta calculations
as well as the Pokemon's ideal IVs.
-------------------------------------------------------------------------------
*/

class CupDropdown extends StatefulWidget {
  const CupDropdown({
    super.key,
    required this.cup,
    required this.onCupChanged,
    required this.width,
  });

  final Cup cup;
  final void Function(String?) onCupChanged;
  final double width;

  @override
  _CupDropdownState createState() => _CupDropdownState();
}

class _CupDropdownState extends State<CupDropdown>
    with AutomaticKeepAliveClientMixin {
  // List of dropdown menu items
  late final cupOptions =
      PogoRepository.getCupsSync().map<DropdownMenuItem<String>>(
    (Cup cup) {
      return DropdownMenuItem(
        value: cup.cupId,
        child: Center(
          child: Text(
            cup.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    },
  ).toList();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final selectedCup = widget.cup;

    return Container(
      alignment: Alignment.center,
      width: widget.width,
      padding: EdgeInsets.only(
        right: Sizing.blockSizeHorizontal * 2.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: Sizing.blockSizeHorizontal * .4,
        ),
        borderRadius: BorderRadius.circular(100.0),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.centerRight,
          colors: [
            PogoColors.getCupColor(selectedCup),
            Colors.transparent,
          ],
          tileMode: TileMode.clamp,
        ),
      ),

      // Cup dropdown button
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          borderRadius: BorderRadius.circular(5),
          isExpanded: true,
          value: selectedCup.cupId,
          icon: Icon(
            Icons.arrow_drop_down_circle,
            size: Sizing.blockSizeVertical * 3.0,
          ),
          style: DefaultTextStyle.of(context).style,
          onChanged: widget.onCupChanged,
          items: cupOptions,
        ),
      ),
    );
  }
}
