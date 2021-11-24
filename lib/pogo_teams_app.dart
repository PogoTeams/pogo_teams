// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'screens/team_builder.dart';
import 'screens/rankings.dart';

//// APPLICATION ROOT
class PogoTeamsApp extends StatelessWidget {
  const PogoTeamsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POGO Teams',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Futura'),

      // There is a single page in this app
      // All navigation is delegated to a bottom tap bar
      home: const TeamBuilder(),
      routes: <String, WidgetBuilder>{
        '/rankings': (BuildContext context) => const Rankings(),
      },

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
