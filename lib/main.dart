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

// The earliest timestamp (used for initial app start up)
const String earliestTimestamp = '2021-01-01 00:00:00.00';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict view orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize the database for user data persistance
  await Hive.initFlutter();
  await Hive.openBox('teams'); // User data
  Box gmBox = await Hive.openBox('gamemaster'); // Pokemon GO data

  // DEBUGGING : implicitly invoke update
  gmBox.put('timestamp', earliestTimestamp);

  final client = RetryClient(Client());
  dynamic gmJson;

  // If an update is available, load the new gamemaster data
  try {
    if (await _updateAvailable(gmBox, client)) {
      // Retrieve gamemaster
      String response =
          await client.read(Uri.https(globals.url, '/gamemaster.json'));

      // If request was successful, load in the new gamemaster,
      gmJson = jsonDecode(response);
    } else {
      gmJson = await _loadCachedGamemaster(gmBox);
    }
  } catch (error) {
    gmJson = await _loadCachedGamemaster(gmBox);
  }

  globals.gamemaster =
      await GameMaster.generateGameMaster(gmJson, client, update: true);
  gmBox.put('gamemaster', gmJson);
  client.close();

  runApp(
    ChangeNotifierProvider(
      create: (_) => TeamsProvider(),
      child: const PogoTeamsApp(),
      lazy: false,
    ),
  );
}

Future<bool> _updateAvailable(Box box, Client client) async {
  bool updateAvailable = false;

  // Retrieve local timestamp
  final String timestampString = box.get('timestamp') ?? earliestTimestamp;
  DateTime localTimeStamp = DateTime.parse(timestampString);

  // Retrieve server timestamp
  String response = await client.read(Uri.https(globals.url, '/timestamp.txt'));

  // If request is successful, compare timestamps to determine update
  final latestTimestamp = DateTime.tryParse(response);

  if (latestTimestamp != null &&
      !localTimeStamp.isAtSameMomentAs(latestTimestamp)) {
    updateAvailable = true;
    localTimeStamp = latestTimestamp;
  }

  // Store the timestamp in the local db
  box.put('timestamp', localTimeStamp.toString());

  return updateAvailable;
}

// Attempt to load gm from the local db, if that fails, load the assets gm
dynamic _loadCachedGamemaster(Box box) async {
  return box.get('gamemaster') ?? await _loadFromAssets();
}

// Load the gm from local assets
// This is the final fail safe for loading gamemaster data
Future<Map<String, dynamic>> _loadFromAssets() async {
  // Load the JSON string
  final String gmString = await rootBundle.loadString('assets/gamemaster.json');

  // Decode to a map
  return jsonDecode(gmString);
}
