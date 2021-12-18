// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:pogo_teams/data/user_teams.dart';
import 'package:pogo_teams/pogo_scaffold.dart';

// Package Imports
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';

// Local Imports
import 'configs/size_config.dart';
import 'data/masters/gamemaster.dart';
import 'data/globals.dart' as globals;

/*
-------------------------------------------------------------------- @PogoTeams
Gamemaster and Pokemon Rankings data is loaded here. An empty screen with a
progress indicator is displayed to the user via a StreamBuilder. Several cases
are handled during the app's loading phase, and they are described below

-------------------------------------------------------------------------------

APP STARTUP CASES (for gamemaster and rankings data)

* LOCAL RETRIEVE
  - Attempt to read from local database
  - If db fails: read from assets

1) No network connection : *

2) HTTPS timestamp.txt fails : *

3) The server timestamp is the same as the local one (no update) : *

4) The server timestamp is different from the local one (update)
  a) HTTP request for gamemaster.json
    - If request fails : *

  b) Decode response, generate gamemaster, save to local db
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

  // User teams data
  final UserTeams _teams = UserTeams();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _teams.close();

    super.dispose();
  }

  // Load the gamemaster, and yield values to the progress indicator
  Stream<double> _loadGamemaster() async* {
    bool update = false;
    final Box gmBox = await Hive.openBox('gamemaster'); // Pokemon GO data
    final Box rankingsBox = await Hive.openBox('rankings');

    // DEBUGGING : uncomment to implicitly invoke update
    //await gmBox.put('timestamp', globals.earliestTimestamp);

    final client = RetryClient(Client());
    dynamic gmJson;

    try {
      // If an update is available
      // make an http request for the new gamemaster
      if (await _updateAvailable(gmBox, client)) {
        update = true;
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

    yield .9;
    // Setup the gamemaster instance
    await gmBox.put('gamemaster', gmJson);
    globals.gamemaster = await GameMaster.generateGameMaster(
        gmJson, client, rankingsBox,
        update: update);

    client.close();
    await gmBox.close();

    yield 1.0;
    // Initialize user teams data
    await _teams.init();

    // Just an asthetic for allowing the loading progress indicator to fill
    await Future.delayed(const Duration(seconds: 2));
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
        gmJson = await _loadFromAssets();
      }
    }

    gmJson ??= await _loadFromAssets();
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
          return MaterialApp(
            title: 'Pogo Teams',
            theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Futura'),

            home: PogoScaffold(teams: _teams),

            //Removes the debug banner
            debugShowCheckedModeBanner: false,
          );
        }

        if (snapshot.hasData) {
          _animationController.animateTo(snapshot.data!,
              curve: Curves.easeInOut);
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 80.0,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) => LinearProgressIndicator(
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.cyan),
                        value: _animationController.value,
                        semanticsLabel: 'Pogo Teams Loading Progress',
                        semanticsValue: snapshot.data.toString(),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/pokeball_icon.png',
                    width: SizeConfig.blockSizeHorizontal * 5.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
