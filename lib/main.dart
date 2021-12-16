// Flutter Imports
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// Local Imports
import 'pogo_teams_app.dart';
import 'data/teams_provider.dart';
import 'data/masters/gamemaster.dart';
import 'data/globals.dart' as globals;

const String url = 'pogoteams.github.io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict view orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize the database for user data persistance
  await Hive.initFlutter();
  await Hive.openBox('teams'); // User data
  Box gmBox = await Hive.openBox('gamemaster'); // Pokemon GO data

  final client = http.Client();

  try {
    var response = await client.get(
      Uri.https(url, '/timestamp.txt'),
    );

    final timestamp = jsonDecode(json.encode(response.body));
    print(timestamp);

    response = await client.get(
      Uri.http(url, '/rankings/all/attackers/rankings-500.json'),
    );

    final gamemaster = jsonDecode(utf8.decode(response.bodyBytes));
    print(gamemaster);
  } finally {
    client.close();
  }

  // Global gamemaster reference setup
  // All Pokemon GO related data is in the gamemaster
  globals.gamemaster = await GameMaster.generateGameMaster();

  runApp(
    ChangeNotifierProvider(
      create: (_) => TeamsProvider(),
      child: const PogoTeamsApp(),
      lazy: false,
    ),
  );
}
