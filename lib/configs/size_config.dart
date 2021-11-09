// Flutter Imports
import 'package:flutter/widgets.dart';

/*
-------------------------------------------------------------------------------
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

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

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

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    h1 = blockSizeHorizontal * 4.0;
    h2 = blockSizeHorizontal * 3.7;
    h3 = blockSizeHorizontal * 2.7;
    p = blockSizeHorizontal * 2.2;
  }
}
