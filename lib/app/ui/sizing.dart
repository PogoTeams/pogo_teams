// Flutter
import 'package:flutter/material.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All screen size queries are handled here. This class is initialized via init
upon the initial app build.
-------------------------------------------------------------------------------
*/

/// [compact] width < 600
/// - Phone in portrait
///
/// [medium] 600 < width < 840
/// - Tablet in portrait
/// - Foldable in portrait (unfolded)
///
/// [expanded] width > 840
/// - Phone in landscape
/// - Tablet in landscape
/// - Foldable in landscape (unfolded)
/// - Desktop
///
/// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
enum WindowSizeClass {
  compact,
  medium,
  expanded,
}

/// https://m3.material.io/components/top-app-bar/specs
class AppBarSizing {
  const AppBarSizing({
    required this.height,
    required this.leadingTrailingIconSize,
    required this.avatarCornerRadius,
    required this.avatarDiameter,
    required this.padding,
    required this.elementPadding,
    required this.iconButtonStateLayerSize,
  });

  final double height;
  final double leadingTrailingIconSize;
  final double avatarCornerRadius;
  final double avatarDiameter;
  final EdgeInsets padding;
  final double elementPadding;
  final double iconButtonStateLayerSize;
}

/// Static wrapper around all calls to [MediaQuery].
///
/// All declaritions follow the Material3 design specifications for spacing
/// and sizing of ui elements.
///
/// https://m3.material.io
class Sizing {
  // icons --------------------------------------------------------------------
  static const double iconLarge = 30.0;
  static const double icon1 = 25.0;
  static const double icon2 = 22.0;
  static const double icon3 = 20.0;
  static const double icon4 = 18.0;
  static const double icon5 = 16.0;
  static const double icon6 = 12.0;

  /// https://m3.material.io/components/top-app-bar/specs
  static const double leadingTralingIcon = 64.0;

  // widgets ------------------------------------------------------------------
  static const double formFieldWidth = 400.0;
  static const double formFieldHeight = 64.0;
  static const double fabMediumWidth = 150.0;
  static const double fabMediumHeight = 60.0;
  static const double fabLargeHeight = 85.0;
  static const double recipeCardWidth = 400.0;
  static const double recipeCardHeight = 200.0;
  static const double avatarLeading = 74.0;
  static const double avatarMedium = 112.0;
  static const double avatarLarge = 250.0;
  static const double fabCircular = fabMediumHeight;
  static const double borderWidth = 3.0;
  static const double borderWidthThin = 1.1;

  static double modalDrawerWidth(BuildContext context) =>
      screenWidth(context) * .8;

  /// https://m3.material.io/components/top-app-bar/specs
  static const AppBarSizing smallTopAppBar = AppBarSizing(
    height: 64,
    leadingTrailingIconSize: 24,
    avatarCornerRadius: 15,
    avatarDiameter: 30,
    padding: EdgeInsets.only(
      left: 16,
      right: 16,
    ),
    elementPadding: 24,
    iconButtonStateLayerSize: 40,
  );

  /// https://m3.material.io/components/top-app-bar/specs
  static const AppBarSizing mediumTopAppBar = AppBarSizing(
    height: 112,
    leadingTrailingIconSize: 24,
    avatarCornerRadius: 15,
    avatarDiameter: 30,
    padding: EdgeInsets.fromLTRB(
      16,
      20,
      16,
      24,
    ),
    elementPadding: 24,
    iconButtonStateLayerSize: 40,
  );

  /// https://m3.material.io/components/top-app-bar/specs
  static const AppBarSizing largeTopAppBar = AppBarSizing(
    height: 152.0,
    leadingTrailingIconSize: 24.0,
    avatarCornerRadius: 15.0,
    avatarDiameter: 30.0,
    padding: EdgeInsets.fromLTRB(
      16.0,
      20.0,
      16.0,
      28.0,
    ),
    elementPadding: 24.0,
    iconButtonStateLayerSize: 40.0,
  );

  /// https://m3.material.io/foundations/layout/understanding-layout/spacing
  static const double minSelectableTarget = 48.0;

  /// https://m3.material.io/foundations/layout/understanding-layout/parts-of-layout
  static const double fixedPaneWidth = 360.0;

  // spacing ------------------------------------------------------------------
  /// https://m3.material.io/foundations/layout/understanding-layout/spacing
  static const double paneSpacing = 24.0;
  static const SizedBox paneSpacer = SizedBox(
    width: paneSpacing,
  );

  static const double listItemVerticalSpacing = 16.0;

  static const SizedBox listItemSpacer = SizedBox(
    height: listItemVerticalSpacing,
  );

  static const SizedBox lineItemSpacer = SizedBox(
    height: 4.0,
  );

  /// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
  static double horizontalSpacing(BuildContext context) {
    switch (windowSizeClass(context)) {
      case WindowSizeClass.compact:
        return 16.0;
      case WindowSizeClass.medium:
      case WindowSizeClass.expanded:
        return 24.0;
    }
  }

  // padding ------------------------------------------------------------------
  /// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
  static EdgeInsets horizontalWindowInsets(BuildContext context) {
    switch (windowSizeClass(context)) {
      case WindowSizeClass.compact:
        return const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        );
      case WindowSizeClass.medium:
      case WindowSizeClass.expanded:
        return const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
        );
    }
  }

  /// https://m3.material.io/components/top-app-bar/specs
  static EdgeInsets horizontalAppBarInsets() => const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      );

  /// https://m3.material.io/components/top-app-bar/specs
  static const double appBarElementPadding = 24.0;

  static EdgeInsets leadingAvatarInsets() => const EdgeInsets.fromLTRB(
        16.0,
        4.0,
        4.0,
        8.0,
      );

  /// https://m3.material.io/components/top-app-bar/specs
  static const double iconButtonStateLayerSize = 40.0;

  static EdgeInsets drawerPadding() => const EdgeInsets.fromLTRB(
        22.0,
        64.0,
        22.0,
        32.0,
      );
  static EdgeInsets bottomSheetPadding() => const EdgeInsets.fromLTRB(
        16.0,
        16.0,
        16.0,
        32.0,
      );
  static EdgeInsets suffixIconPadding() => const EdgeInsets.only(right: 27.0);
  static EdgeInsets listViewPadding() => const EdgeInsets.fromLTRB(
        20.0,
        200.0,
        20.0,
        200.0,
      );
  static EdgeInsets alertDialogPadding() => const EdgeInsets.fromLTRB(
        8.0,
        25.0,
        25.0,
        8.0,
      );
  static EdgeInsets cardPadding() => const EdgeInsets.fromLTRB(
        4.0,
        2.0,
        1.0,
        2.0,
      );

  // alignment ----------------------------------------------------------------
  static const Alignment formAlignment = Alignment(0, -1 / 3);
  static const double railGroupAlignment = -0.85;

// utils --------------------------------------------------------------------
  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;
  static double screenWidth(BuildContext context, {bool oriented = false}) {
    if (oriented) {
      return screenSize(context).width;
    }
    return isLandscape(context)
        ? screenSize(context).height
        : screenSize(context).width;
  }

  static double screenHeight(BuildContext context, {bool oriented = false}) {
    if (oriented) {
      return screenSize(context).height;
    }
    return isLandscape(context)
        ? screenSize(context).width
        : screenSize(context).height;
  }

  /// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
  static WindowSizeClass windowSizeClass(BuildContext context) {
    final width = screenWidth(context);
    if (width < 600) {
      return WindowSizeClass.compact;
    } else if (width < 840) {
      return WindowSizeClass.medium;
    } else {
      return WindowSizeClass.expanded;
    }
  }

  /// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
  static bool isWideScreen(BuildContext context) =>
      MediaQuery.of(context).size.width > 600;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// True if bottom [viewInsets] is 0.
  ///
  /// [viewInsets] refers to the top of the devices virtual keyboard.
  ///
  /// https://api.flutter.dev/flutter/widgets/MediaQueryData/viewInsets.html
  static bool keyboardIsClosed(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom == 0;

  static double aspectRatio(BuildContext context) {
    final Size size = screenSize(context);

    return size.height > size.width
        ? size.width / size.height
        : size.height / size.width;
  }
}
