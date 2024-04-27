// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../app/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A floating action button that is docked at the bottom center. This is used to
exit from the current screen, returning to the previous screen on the
navigator stack. No information is returned from the current screen.
-------------------------------------------------------------------------------
*/

class ExitButton extends StatelessWidget {
  const ExitButton({
    super.key,
    required this.onPressed,
    this.icon = const Icon(Icons.close),
    this.backgroundColor = Colors.teal,
  });

  final VoidCallback onPressed;
  final Icon icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    // Block size from MediaQuery
    return Container(
      height: Sizing.blockSizeHorizontal * 9.0,
      width: Sizing.blockSizeHorizontal * 9.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: Sizing.blockSizeHorizontal * 0.7,
        ),
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        heroTag: key,
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,

        // Callback
        onPressed: onPressed,
        child: Icon(
          icon.icon,
          size: Sizing.blockSizeHorizontal * 5.0,
        ),
      ),
    );
  }
}
