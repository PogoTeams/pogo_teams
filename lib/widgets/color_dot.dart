// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class ColorDot extends StatelessWidget {
  const ColorDot({
    Key? key,
    required this.color,
    this.onPressed,
  }) : super(key: key);

  final Color color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      height: Sizing.blockSizeHorizontal * 7.0,
      width: Sizing.blockSizeHorizontal * 7.0,
      child: onPressed == null
          ? Container()
          : MaterialButton(
              onPressed: onPressed,
            ),
    );
  }
}
