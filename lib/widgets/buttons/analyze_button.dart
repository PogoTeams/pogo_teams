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
An icon button used to scroll to the team analysis portion of a team page.
-------------------------------------------------------------------------------
*/

class AnalyzeButton extends StatelessWidget {
  const AnalyzeButton({
    Key? key,
    required this.onAnalyzePressed,
  }) : super(key: key);

  final VoidCallback onAnalyzePressed;

  @override
  Widget build(BuildContext context) {
    // Analyze button
    return SizedBox(
      width: SizeConfig.screenWidth * 0.95,
      height: SizeConfig.blockSizeVertical * 5.5,
      child: TextButton.icon(
        label: Text(
          'Analyze',
          style: TextStyle(
            fontSize: SizeConfig.h2,
            color: Colors.white,
          ),
        ),
        icon: Icon(
          Icons.analytics,
          size: SizeConfig.blockSizeHorizontal * 7.0,
          color: Colors.white,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Colors.cyan;
            },
          ),
        ),
        onPressed: onAnalyzePressed,
      ),
    );
  }
}
