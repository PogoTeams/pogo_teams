// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'gradient_button.dart';
import '../../app/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A button that will appear when there is 1 or more Pokemon on a team. When the
team is empty, the button will take up that same space as blank space.
-------------------------------------------------------------------------------
*/

class AnalyzeButton extends StatelessWidget {
  const AnalyzeButton({
    super.key,
    required this.isEmpty,
    required this.onPressed,
  });

  final bool isEmpty;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Analyze button
    return isEmpty
        ? SizedBox(
            height: Sizing.screenHeight(context) * .085,
          )
        : GradientButton(
            onPressed: onPressed,
            width: Sizing.screenWidth(context) * .85,
            height: Sizing.screenHeight(context) * .085,
            child: Text(
              'Analyze',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
  }
}
