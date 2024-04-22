// flutter
import 'package:flutter/material.dart';

// recipio
import '../../modules/ui/pogo_colors.dart';

class InactiveOutlinedButton extends StatelessWidget {
  const InactiveOutlinedButton({
    Key? key,
    this.width = 400.0,
    this.height = 60.0,
    this.borderRadius,
    this.child,
  }) : super(key: key);

  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(100.0),
            ),
          ),
          side: MaterialStateProperty.all(
            const BorderSide(
              width: 2.0,
              color: PogoColors.inactiveGrey,
            ),
          ),
        ),
        onPressed: null,
        child: child,
      ),
    );
  }
}
