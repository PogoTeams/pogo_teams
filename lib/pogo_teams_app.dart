// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'pogo_scaffold.dart';

/*
-------------------------------------------------------------------- @PogoTeams
This is the root widget for Pogo Teams. It starts up the loading phase with
StartupLoadScreen.
-------------------------------------------------------------------------------
*/

class PogoTeamsApp extends StatelessWidget {
  const PogoTeamsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pogo Teams Load Screen',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Futura'),

      home: const PogoScaffold(),

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
