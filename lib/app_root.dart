import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo_teams/pogo_data.dart';
import 'package:pogo_teams/team_builder.dart';

// All widgets will have access to the gamemaster through this widget
// All Pokemon GO related data is populated from a JSON via the GameMaster class
class PogoData extends InheritedWidget {
  const PogoData({
    Key? key,
    required Widget child,
    required this.gamemaster,
  }) : super(key: key, child: child);

  final GameMaster gamemaster;

  static PogoData of(BuildContext context) {
    final PogoData? result =
        context.dependOnInheritedWidgetOfExactType<PogoData>();
    assert(result != null, 'No PogoData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

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
      home: const TeamBuilder(title: 'Team Builder'),

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
