// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';

// Local Imports
import 'pogo_teams_app.dart';
import 'data/teams_provider.dart';
import 'data/masters/gamemaster.dart';
import 'data/globals.dart' as globals;

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
  await Hive.openBox('teams'); // User data

  runApp(const PogoTeamsApp());
}
