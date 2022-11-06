// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'gradient_button.dart';
import '../../modules/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A button that will appear when there is 1 or more Pokemon on a team. When the
team is empty, the button will take up that same space as blank space.
-------------------------------------------------------------------------------
*/

class AnalyzeButton extends StatelessWidget {
  const AnalyzeButton({
    Key? key,
    required this.isEmpty,
    required this.onPressed,
  }) : super(key: key);

  final bool isEmpty;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Analyze button
    return isEmpty
        ? SizedBox(
            height: Sizing.blockSizeVertical * 8.5,
          )
        : GradientButton(
            child: Text(
              'Analyze',
              style: Theme.of(context).textTheme.headline5,
            ),
            onPressed: onPressed,
            width: Sizing.screenWidth * .85,
            height: Sizing.blockSizeVertical * 8.5,
          );
  }
}
