// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:provider/provider.dart';

// Local Imports
import 'pogo_teams_app.dart';
import 'data/teams_provider.dart';
import 'data/masters/gamemaster.dart';
import 'data/globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global gamemaster reference setup
  // All Pokemon GO related data is in the gamemaster
  globals.gamemaster = await GameMaster.generateGameMaster();

  // Restrict view orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => TeamsProvider(),
      child: const PogoTeamsApp(),
      lazy: false,
    ),
  );
}
