// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'gradient_button.dart';
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
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
            height: SizeConfig.blockSizeVertical * 8.5,
          )
        : GradientButton(
            child: Text(
              'Analyze',
              style: TextStyle(
                fontSize: SizeConfig.h1,
                color: Colors.white,
              ),
            ),
            onPressed: onPressed,
            width: SizeConfig.screenWidth * .85,
            height: SizeConfig.blockSizeVertical * 8.5,
          );
  }
}
