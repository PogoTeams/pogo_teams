// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'startup_load_screen.dart';

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

      home: const StartupLoadScreen(),

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
