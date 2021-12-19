// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:hive_flutter/hive_flutter.dart';

// Local Imports
import 'pogo_teams_app.dart';

// ----------------------------------------------------------------- @PogoTeams

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict view orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize the database for user data persistance
  await Hive.initFlutter();

  runApp(const PogoTeamsApp());
}
