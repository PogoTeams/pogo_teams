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
A button that will appear when there is 1 or more Pokemon on a team. When the
team is empty, the button will take up that same space as blank space.
-------------------------------------------------------------------------------
*/

class AnalysisButton extends StatelessWidget {
  const AnalysisButton({
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
            height: SizeConfig.blockSizeVertical * 5.5,
          )
        : Container(
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
            child: MaterialButton(
              child: Text(
                'Analyze',
                style: TextStyle(
                  fontSize: SizeConfig.h1,
                  color: Colors.white,
                ),
              ),
              onPressed: onPressed,
            ),
          );
  }
}
