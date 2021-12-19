// Flutter Imports
import 'package:flutter/material.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A gradient button that uses gradient coloring in theme with the app design.
-------------------------------------------------------------------------------
*/

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

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
        borderRadius: borderRadius ?? BorderRadius.circular(20),
      ),
      width: width,
      height: height,
      child: MaterialButton(
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
