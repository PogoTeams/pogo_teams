// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'pages/startup_load_screen.dart';

//// APPLICATION ROOT
class PogoTeamsApp extends StatelessWidget {
  const PogoTeamsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pogo Teams',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Futura'),

      home: const StartupLoadScreen(),

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
