// Flutter Imports
import 'package:flutter/material.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All screen size queries are handled here. This class is initialized via init
upon the initial app build.
-------------------------------------------------------------------------------
*/

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double h1;
  static late double h2;
  static late double h3;
  static late double p;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    if (isTablet()) {
      screenWidth = _mediaQueryData.size.width;
      screenHeight = _mediaQueryData.size.height;

      blockSizeHorizontal = screenWidth * .8 / 100;
      blockSizeVertical = screenHeight * 1.2 / 100;

      h1 = blockSizeHorizontal * 4.0;
      h2 = blockSizeHorizontal * 3.7;
      h3 = blockSizeHorizontal * 2.7;
      p = blockSizeHorizontal * 2.2;
    } else {
      screenWidth = _mediaQueryData.size.width;
      screenHeight = _mediaQueryData.size.height;

      blockSizeHorizontal = screenWidth / 100;
      blockSizeVertical = screenHeight / 100;

      h1 = blockSizeHorizontal * 4.0;
      h2 = blockSizeHorizontal * 3.7;
      h3 = blockSizeHorizontal * 2.7;
      p = blockSizeHorizontal * 2.2;
    }
  }

  // Calculate the screen diagonal and determine if the device is a tablet
  bool isTablet() {
    return _mediaQueryData.size.shortestSide > 550;
  }
}
