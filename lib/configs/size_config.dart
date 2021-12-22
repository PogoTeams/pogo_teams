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
  static late double appBarHeight;

  static late double h1;
  static late double h2;
  static late double h3;
  static late double p;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    appBarHeight = AppBar().preferredSize.height;

    h1 = blockSizeHorizontal * 4.0;
    h2 = blockSizeHorizontal * 3.7;
    h3 = blockSizeHorizontal * 2.7;
    p = blockSizeHorizontal * 2.2;
  }
}
