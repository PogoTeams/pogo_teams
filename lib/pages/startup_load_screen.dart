// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:pogo_teams/data/teams_provider.dart';
import 'package:pogo_teams/pogo_scaffold.dart';

// Package Imports
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:provider/provider.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/masters/gamemaster.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
Gamemaster and Pokemon Rankings data is loaded here. An empty screen with a
progress indicator is displayed to the user via a StreamBuilder.
-------------------------------------------------------------------------------
*/

class StartupLoadScreen extends StatefulWidget {
  const StartupLoadScreen({Key? key}) : super(key: key);

  @override
  _LoadingScaffold createState() => _LoadingScaffold();
}

class _LoadingScaffold extends State<StartupLoadScreen>
    with SingleTickerProviderStateMixin {
  // To smooth the progress bar animation
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  // Load the gamemaster, and yield values to the progress indicator
  Stream<double> _loadGamemaster() async* {
    bool update = false;
    yield .1;
    final Box gmBox = await Hive.openBox('gamemaster'); // Pokemon GO data
    yield .3;
    final Box rankingsBox = await Hive.openBox('rankings');

    // DEBUGGING : uncomment to implicitly invoke update
    await gmBox.put('timestamp', globals.earliestTimestamp);

    final client = RetryClient(Client());
    dynamic gmJson;

    try {
      // If an update is available
      // make an http request for the new gamemaster
      if (await _updateAvailable(gmBox, client)) {
        update = true;
        yield .5;
        // Retrieve gamemaster
        String response =
            await client.read(Uri.https(globals.url, '/gamemaster.json'));

        yield .8;
        // If request was successful, load in the new gamemaster,
        gmJson = jsonDecode(response);
      }
      // No new update available, attempt to load locally
      // Upon db failure, an http request will be made
      else {
        yield .8;
        gmJson = await _loadCachedGamemaster(gmBox, client, httpAttempt: true);
      }
    }
    // If HTTP request or json decoding fails
    catch (error) {
      update = false;
      yield .8;
      gmJson = await _loadCachedGamemaster(gmBox, client);
    }

    await gmBox.put('gamemaster', gmJson);
    globals.gamemaster = await GameMaster.generateGameMaster(
        gmJson, client, rankingsBox,
        update: update);

    yield 1.0;
    // Just an asthetic for allowing the loading progress indicator to fill
    await Future.delayed(const Duration(milliseconds: 1200));

    client.close();
    await gmBox.close();
  }

  Future<bool> _updateAvailable(Box box, Client client) async {
    bool updateAvailable = false;

    // Retrieve local timestamp
    final String timestampString =
        box.get('timestamp') ?? globals.earliestTimestamp;
    DateTime localTimeStamp = DateTime.parse(timestampString);

    // Retrieve server timestamp
    String response =
        await client.read(Uri.https(globals.url, '/timestamp.txt'));

    // If request is successful, compare timestamps to determine update
    final latestTimestamp = DateTime.tryParse(response);

    if (latestTimestamp != null &&
        !localTimeStamp.isAtSameMomentAs(latestTimestamp)) {
      updateAvailable = true;
      localTimeStamp = latestTimestamp;
    }

    // Store the timestamp in the local db
    await box.put('timestamp', localTimeStamp.toString());

    return updateAvailable;
  }

  // Attempt to load gm from the local db
  // If the db fails and httpAttempt is true, attempt a new http request
  // As a last resort, load the gm and rankings from assets
  dynamic _loadCachedGamemaster(Box box, Client client,
      {bool httpAttempt = false}) async {
    dynamic gmJson = box.get('gamemaster');

    if (gmJson == null && httpAttempt) {
      try {
        // Retrieve gamemaster
        String response =
            await client.read(Uri.https(globals.url, '/gamemaster.json'));

        // If request was successful, load in the new gamemaster,
        gmJson = jsonDecode(response);
      } catch (error) {
        await _loadFromAssets();
      }
    } else if (gmJson == null) {
      await _loadFromAssets();
    }

    return gmJson;
  }

  // Load the gm from local assets
  // This is the final fail safe for loading gamemaster data
  Future<Map<String, dynamic>> _loadFromAssets() async {
    // Load the JSON string
    final String gmString =
        await rootBundle.loadString('assets/gamemaster.json');

    // Decode to a map
    return jsonDecode(gmString);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize media queries
    SizeConfig().init(context);

    return StreamBuilder<double>(
      stream: _loadGamemaster(),
      initialData: 0.0,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (_) => TeamsProvider(),
            child: MaterialApp(
              title: 'Pogo Teams',
              theme:
                  ThemeData(brightness: Brightness.dark, fontFamily: 'Futura'),

              home: const PogoScaffold(),

              //Removes the debug banner
              debugShowCheckedModeBanner: false,
            ),
            lazy: false,
          );
        }

        if (snapshot.hasData) {
          _animationController.animateTo(snapshot.data!,
              curve: Curves.decelerate);
        }

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 2.0,
              right: SizeConfig.blockSizeHorizontal * 2.0,
              bottom: SizeConfig.blockSizeVertical * 10.0,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => LinearProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                  value: _animationController.value,
                  semanticsLabel: 'Pogo Teams Loading Progress',
                  semanticsValue: snapshot.data.toString(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
