// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
A row of icon text buttons at the bottom of the screen. These buttons will use
callbacks to push a new screen on the navigator.
-------------------------------------------------------------------------------
*/
class FooterButtons extends StatelessWidget {
  const FooterButtons({
    Key? key,
    required this.onAnalyzePressed,
    required this.onTeamInfoPressed,
  }) : super(key: key);

  final VoidCallback onAnalyzePressed;
  final VoidCallback onTeamInfoPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: SizeConfig.screenWidth * .025,
        left: SizeConfig.screenWidth * .025,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Analyze button
          SizedBox(
            width: SizeConfig.screenWidth * 0.45,
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
          ),

          // Team Info button
          SizedBox(
            width: SizeConfig.screenWidth * 0.45,
            height: SizeConfig.blockSizeVertical * 5.5,
            child: TextButton.icon(
              label: Text(
                'Team Info',
                style: TextStyle(
                  fontSize: SizeConfig.h2,
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.info,
                size: SizeConfig.blockSizeHorizontal * 7.0,
                color: Colors.white,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.indigo;
                  },
                ),
              ),
              onPressed: onTeamInfoPressed,
            ),
          ),
        ],
      ),
    );
  }
}
