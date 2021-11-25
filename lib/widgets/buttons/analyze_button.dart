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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xBF29F19C), Color(0xFF02A1F9)],
          tileMode: TileMode.clamp,
        ),
        borderRadius:
            BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5),
      ),
      width: SizeConfig.screenWidth * 0.95,
      height: SizeConfig.blockSizeVertical * 5.5,
      child: TextButton(
        child: Text(
          'Analyze',
          style: TextStyle(
            fontSize: SizeConfig.h1,
            color: Colors.white,
          ),
        ),
        onPressed: onAnalyzePressed,
      ),
    );
  }
}
