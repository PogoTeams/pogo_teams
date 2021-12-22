// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'pogo_scaffold.dart';

/*
-------------------------------------------------------------------- @PogoTeams
This is the root widget for Pogo Teams. It starts up the loading phase with
StartupLoadScreen. When testing a new update of the gamemaster and rankings
via our test bucket, the 'testing' and 'forceUpdate' flags can be used.
-------------------------------------------------------------------------------
*/

class PogoTeamsApp extends StatelessWidget {
  const PogoTeamsApp({Key? key}) : super(key: key);

  // TESTING ------------------------------------------------------------------
  // * These values MUST be false for all production builds
  // * These values should ONLY be true for testing scenarios

  // If true, all update data will come from the test directory in our bucket
  final bool testing = false;

  // If true, an update from our bucket will be implicitly invoked
  final bool forceUpdate = false;

  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pogo Teams',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Futura',
      ),

      home: PogoScaffold(
        testing: testing,
        forceUpdate: forceUpdate,
      ),

      //Removes the debug banner
      debugShowCheckedModeBanner: false,
    );
  }
}
