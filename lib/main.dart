// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Local Imports
import 'pogo_teams_app.dart';
import 'data/globals.dart' as globals;
import 'data/masters/gamemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global gamemaster reference setup
  // All Pokemon GO related data is in the gamemaster
  globals.gamemaster = await GameMaster.generateGameMaster();

  // Restrict view orientation to portrait only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const PogoTeamsApp());
}
