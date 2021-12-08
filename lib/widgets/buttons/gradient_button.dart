// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
A gradient button that uses gradient coloring in theme with the app design.
-------------------------------------------------------------------------------
*/

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.width,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xBF29F19C), Color(0xFF02A1F9)],
          tileMode: TileMode.clamp,
        ),
        borderRadius:
            BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5),
      ),
      width: width,
      height: SizeConfig.blockSizeVertical * 5.5,
      child: MaterialButton(
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
