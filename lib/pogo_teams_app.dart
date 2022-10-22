// Flutter Imports
import 'package:flutter/material.dart';
import 'package:pogo_teams/pages/pogo_account.dart';

// Local Imports
import 'pogo_scaffold.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PogoTeamsApp extends StatelessWidget {
  const PogoTeamsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pogo Teams',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Futura',
      ),

      home: const PogoScaffold(),

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
