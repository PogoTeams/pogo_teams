// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';
import '../pogo_objects/tag.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class TagDot extends StatelessWidget {
  const TagDot({
    Key? key,
    required this.tag,
    this.onPressed,
  }) : super(key: key);

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
            width: 1.0,
          ),
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

    return Container(
      decoration: BoxDecoration(
        color: Color(
          int.parse(tag!.uiColor),
        ),
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
