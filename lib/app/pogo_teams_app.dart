// Flutter
import 'package:flutter/material.dart';
import 'package:pogo_teams/pages/pogo_data_sync.dart';

// Local Imports
import '../pages/pogo_scaffold.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PogoTeamsApp extends StatelessWidget {
  const PogoTeamsApp({super.key});

  static const String _fontFamily = 'Futura';

  ThemeData _buildLightTheme(
    BuildContext context,
  ) {
    return ThemeData(
      fontFamily: _fontFamily,
      colorScheme: const ColorScheme.light(),
    );
  }

  ThemeData _buildDarkTheme(
    BuildContext context,
  ) {
    return ThemeData(
      colorScheme: const ColorScheme.dark().copyWith(
        background: const Color.fromARGB(255, 25, 25, 25),
        error: Colors.deepOrange,
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
      canvasColor: const Color.fromARGB(255, 25, 25, 25),
      cardColor: const Color.fromARGB(255, 25, 25, 25),
      hintColor: const Color.fromARGB(155, 2, 162, 249),
      disabledColor: Colors.white70,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.deepOrange,
        actionTextColor: Colors.white,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: _fontFamily,
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
            fontFamily: _fontFamily,
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
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      hoverColor: Colors.black,
      radioTheme: RadioThemeData(
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) => Colors.white,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 19, 19, 19),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pogo Teams',
      theme: _buildLightTheme(context),
      darkTheme: _buildDarkTheme(context),
      themeMode: ThemeMode.dark,

      routes: {
        PogoDataSync.routeName: (context) => const PogoDataSync(),
        PogoScaffold.routeName: (context) => const PogoScaffold(),
      },
      initialRoute: PogoDataSync.routeName,

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
