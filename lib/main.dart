// Flutter
import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

// Packages
import 'package:hive_flutter/hive_flutter.dart';

// Local Imports
import 'app/pogo_teams_app.dart';
import 'modules/pogo_repository.dart';
import 'modules/google_drive_repository.dart';

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
