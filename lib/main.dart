// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:hive_flutter/hive_flutter.dart';

// Local Imports
import 'pogo_teams_app.dart';

/*
-------------------------------------------------------------------------------
APP STARTUP CASES (for gamemaster and rankings data)

* LOCAL RETRIEVE
  - Attempt to read from local database
  - If db fails: read from assets

1) No network connection : *

2) HTTPS timestamp.txt fails : *

3) The server timestamp is the same as the local one (no update) : *

4) The server timestamp is different from the local one (update)
  a) HTTP request for gamemaster.json
    - If request fails : *

  b) Decode response, generate gamemaster, save to local db
-------------------------------------------------------------------------------
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict view orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize the database for user data persistance
  await Hive.initFlutter();
  runApp(const PogoTeamsApp());
}
