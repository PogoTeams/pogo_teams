// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Packages
import 'package:hive_flutter/hive_flutter.dart';

// Local Imports
import 'pogo_teams_app.dart';
import 'modules/data/pogo_data.dart';

// ----------------------------------------------------------------- @PogoTeams

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict view orientation to portrait only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await PogoData.init();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  runApp(const PogoTeamsApp());
}
