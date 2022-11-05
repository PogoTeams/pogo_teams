// Flutter Imports
import 'package:flutter/material.dart';
import 'package:pogo_teams/pages/account/pogo_account.dart';

// Local Imports
import 'pogo_scaffold.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PogoTeamsApp extends StatelessWidget {
  const PogoTeamsApp({Key? key}) : super(key: key);

  ThemeData _buildBaseTheme() {
    return ThemeData(
      fontFamily: 'Futura',
    );
  }

  ThemeData _buildLightTheme(
    BuildContext context,
    ThemeData baseThemeData,
  ) {
    return baseThemeData.copyWith(
      colorScheme: const ColorScheme.light(),
    );
  }

  ThemeData _buildDarkTheme(
    BuildContext context,
    ThemeData baseThemeData,
  ) {
    return baseThemeData.copyWith(
      colorScheme: const ColorScheme.dark(),
      scaffoldBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
      canvasColor: const Color.fromARGB(255, 25, 25, 25),
      cardColor: const Color.fromARGB(255, 25, 25, 25),
      errorColor: Colors.deepOrange,
      hintColor: const Color.fromARGB(155, 2, 162, 249),
      disabledColor: Colors.white70,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.deepOrange,
        actionTextColor: Colors.white,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Futura',
        ),
      ),
      dialogTheme: const DialogTheme(
        contentTextStyle: TextStyle(
          color: Colors.white,
        ),
        iconColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 25, 25, 25),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF02A1F9),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF02A1F9),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF02A1F9),
        ),
        iconColor: const Color(0xFF02A1F9),
      ),
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Futura',
            displayColor: Colors.white,
            bodyColor: Colors.white,
            decorationColor: Colors.white,
          ),
      buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.dark(),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) => Colors.white,
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) => Colors.transparent,
          ),
        ),
      ),
      highlightColor: Colors.transparent,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      hoverColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData baseThemeData = _buildBaseTheme();

    return MaterialApp(
      title: 'Pogo Teams',
      theme: _buildLightTheme(context, baseThemeData),
      darkTheme: _buildDarkTheme(context, baseThemeData),
      themeMode: ThemeMode.dark,

      home: const PogoScaffold(),

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
