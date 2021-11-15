// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
A floating action button that is docked at the bottom center. This is used to
exit from the current screen, returning to the previous screen on the
navigator stack. No information is returned from the current screen.
-------------------------------------------------------------------------------
*/

class ExitButton extends StatelessWidget {
  const ExitButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Block size from MediaQuery
    final double blockSize = SizeConfig.blockSizeHorizontal;
    return Container(
      height: blockSize * 11.0,
      width: blockSize * 11.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: blockSize * .7,
        ),
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        child: Icon(
          Icons.close,
          size: SizeConfig.blockSizeHorizontal * 7.5,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,

        // Callback
        onPressed: onPressed,
      ),
    );
  }
}
