// Flutter
import 'package:flutter/material.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All screen size queries are handled here. This class is initialized via init
upon the initial app build.
-------------------------------------------------------------------------------
*/

class Sizing {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double icon3;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    // Tablet query
    if (isTablet()) {
      blockSizeHorizontal = screenWidth * .8 / 100;
      blockSizeVertical = screenHeight * 1.2 / 100;
    }

    // Mobile query
    else {
      blockSizeHorizontal = screenWidth / 100;
      blockSizeVertical = screenHeight / 100;
    }

    icon3 = blockSizeHorizontal * 6;
  }

  // Calculate the screen diagonal and determine if the device is a tablet
  bool isTablet() {
    return _mediaQueryData.size.shortestSide > 550;
  }
}
