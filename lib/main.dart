// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package Imports
import 'package:firebase_core/firebase_core.dart';

// Local Imports
import 'firebase_options.dart';
import 'pogo_teams_app.dart';
import 'modules/data/data_access.dart';

// ----------------------------------------------------------------- @PogoTeams

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict view orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DataAccess.loadGamemaster();

  runApp(const PogoTeamsApp());
}
