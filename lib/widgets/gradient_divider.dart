// Flutter
import 'package:flutter/material.dart';

// Local
import '../app/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class GradientDivider extends StatelessWidget {
  const GradientDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.screenWidth(context) * .02,
        bottom: Sizing.screenWidth(context) * .02,
      ),
      child: Container(
        height: Sizing.screenHeight(context) * .0075,
        padding: EdgeInsets.only(
          top: Sizing.screenHeight(context) * .02,
          bottom: Sizing.screenHeight(context) * .02,
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
