// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Local Imports
import 'pogo_teams_app.dart';
import 'modules/data/pogo_data.dart';

// ----------------------------------------------------------------- @PogoTeams

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict view orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await PogoData.init();

  runApp(const PogoTeamsApp());
}
