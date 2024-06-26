// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../app/ui/sizing.dart';
import '../model/tag.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class TagDot extends StatelessWidget {
  const TagDot({
    super.key,
    required this.tag,
    this.onPressed,
  });

  final Tag? tag;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    if (tag == null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.white,
            width: Sizing.borderWidthThin,
          ),
        ),
        child: onPressed == null
            ? Container()
            : MaterialButton(
                onPressed: onPressed,
              ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(
          int.parse(tag!.uiColor),
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: onPressed == null
          ? Container()
          : MaterialButton(
              onPressed: onPressed,
            ),
    );
  }
}
