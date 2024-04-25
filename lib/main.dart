// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Packages
import 'package:hive_flutter/hive_flutter.dart';

// Local Imports
import 'pogo_teams_app.dart';
import 'modules/data/pogo_repository.dart';
import 'modules/data/google_drive_repository.dart';

// ----------------------------------------------------------------- @PogoTeams

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict view orientation to portrait only
  //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  await PogoRepository.init();
  await GoogleDriveRepository.init();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  runApp(const PogoTeamsApp());
}
