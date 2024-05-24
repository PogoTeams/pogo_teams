// Flutter
import 'package:flutter/material.dart';

// Packages
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pogo_teams/app/bloc_observer.dart';

// Local Imports
import 'app/app.dart';
import 'modules/pogo_repository.dart';
import 'modules/google_drive_repository.dart';

// ----------------------------------------------------------------- @PogoTeams

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Bloc.observer = const AppBlocObserver();

  // Restrict view orientation to portrait only
  //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  final PogoRepository pogoRepository = PogoRepository();
  await pogoRepository.init();
  await GoogleDriveRepository.init();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  runApp(App(pogoRepository: pogoRepository));
}
