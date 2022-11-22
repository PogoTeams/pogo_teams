// Flutter
import 'package:flutter/material.dart';

// Local
import '../modules/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class GradientDivider extends StatelessWidget {
  const GradientDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeHorizontal * 2.0,
        bottom: Sizing.blockSizeHorizontal * 2.0,
      ),
      child: Container(
        height: Sizing.blockSizeVertical * .75,
        padding: EdgeInsets.only(
          top: Sizing.blockSizeVertical * 2.0,
          bottom: Sizing.blockSizeVertical * 2.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xBF29F19C), Color(0xFF02A1F9)],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }
}
