// Dart Imports
import 'dart:convert';

// Flutter Imports
import 'package:flutter/services.dart';

// Package Imports
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';

// Local Imports
import 'tools/pair.dart';
import 'data/user_teams.dart';
import 'pages/teams/teams_builder.dart';
import 'pages/rankings.dart';
import 'configs/size_config.dart';
import 'widgets/pogo_drawer.dart';
import 'data/masters/gamemaster.dart';
import 'data/globals.dart' as globals;

/*
-------------------------------------------------------------------- @PogoTeams
The top level scaffold for the app. Navigation via the scaffold's drawer, will
apply changes to the body, and app bar title. Upon startup, this widget enters
a loading phase, which animates a progress bar while the gamemaster and
rankings data are loaded. The loading procedure is illustrated below.

-------------------------------------------------------------------------------

The priority of this loading procedure is to update via HTTPS when necessary,
otherwise restore state from the local db. As a last resort there is model data
stored in the assets folder that can be retrieved, but this will only be
updated with each version release to the app store, so it is more or less an
additional fail safe. A simple timestamp is all that will trigger an update for
all instances of the app, as long as the timestamp is different, the app will
attempt to update.

APP STARTUP CASES (for gamemaster and rankings data)
* LOCAL RETRIEVE
  - Attempt to read from local database
    -- If db fails, and HTTPS hasn't already failed, attempt 3a)
  - If db fails: read from assets

1) No network connection or HTTPS request fails at any point : *

2) The server timestamp is the same as the local one (no update) : *

3) The server timestamp is different from the local one (update)
  a) HTTP request for gamemaster.json
    - If request fails : *
  b) Decode response, generate gamemaster, save to local db

-------------------------------------------------------------------------------
*/

class PogoScaffold extends StatefulWidget {
  const PogoScaffold({
    Key? key,
    required this.testing,
    required this.forceUpdate,
  }) : super(key: key);

  final bool testing;
  final bool forceUpdate;

  @override
  _PogoScaffoldState createState() => _PogoScaffoldState();
}

class _PogoScaffoldState extends State<PogoScaffold>
    with SingleTickerProviderStateMixin {
  // Flag for when the app has finished the loading phase
  bool _loaded = false;

  // User data
  final UserTeams teams = UserTeams();

  // Initialize all user data, called once after loading is done
  void _initializeTeams() async => await teams.init();

  // All pages that are accessible at the top level of the app
  late final Map<String, Widget> _pages = {
    'Teams': TeamsBuilder(teams: teams),
    'Rankings': const Rankings(),
  };

  // Icons cooresponding to the pages
  late final Map<String, Widget> _icons = {
    'Teams': Image.asset(
      'assets/pokeball_icon.png',
      width: SizeConfig.blockSizeHorizontal * 5.0,
    ),
    'Rankings': Icon(
      Icons.bar_chart,
      size: SizeConfig.blockSizeHorizontal * 6.0,
    ),
  };

  // Used to navigate between pages by key
  String _navKey = 'Teams';

  // For animating the loading progress bar
  late final AnimationController _progressBarAnimController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  // Build the app bar with the current page title, and icon
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            _navKey,
            style: TextStyle(
              fontSize: SizeConfig.h2,
              fontStyle: FontStyle.italic,
            ),
          ),

          // Spacer
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 3.0,
          ),

          // Page icon
          _icons[_navKey]!,
        ],
      ),
    );
  }

  // Callback for navigating to a new page in the app
  void _onNavSelected(String navKey) {
    setState(() {
      _navKey = navKey;
    });
  }

  // Load the gamemaster, and yield values to the progress indicator
  Stream<Pair<String, double>> _loadGamemaster() async* {
    bool update = false; // Flag for whether the local gamemaster an update

    // Pokemon GO local db data
    // This is a "cache" of the latest data model from the server
    final Box gmBox = await Hive.openBox('gamemaster');
    final Box rankingsBox = await Hive.openBox('rankings');

    String prefix = ''; // For indicating testing

    // TRUE FOR TESTING ONLY
    if (widget.testing) {
      globals.pathPrefix = '/test/';
      prefix = '[ TEST ]  ';
    }

    // Implicitly invoke an app update via HTTPS
    if (widget.forceUpdate) {
      await gmBox.put('timestamp', globals.earliestTimestamp);
    }

    String message = prefix + 'Loading...'; // Message above progress bar
    final client = RetryClient(Client());
    dynamic gmJson;

    try {
      // If an update is available
      // make an http request for the new gamemaster
      if (await _updateAvailable(gmBox, client)) {
        message = prefix + 'Updating Pogo Teams...';
        yield Pair(a: message, b: .8);

        update = true;
        // Retrieve gamemaster
        String response = await client.read(
            Uri.https(globals.url, '${globals.pathPrefix}gamemaster.json'));

        // If request was successful, load in the new gamemaster,
        gmJson = jsonDecode(response);
      }
      // No new update available, attempt to load locally
      // Upon db failure, an http request will be made
      else {
        yield Pair(a: message, b: .8);
        gmJson = await _loadCachedGamemaster(gmBox, client, httpAttempt: true);
      }
    }
    // If HTTP request or json decoding fails
    catch (error) {
      message = prefix + 'No Network Connection...';
      update = false;
      yield Pair(a: message, b: .8);
      gmJson = await _loadCachedGamemaster(gmBox, client);
    }

    yield Pair(a: message, b: .9);

    // Setup the gamemaster instance
    await gmBox.put('gamemaster', gmJson);
    globals.gamemaster = await GameMaster.generateGameMaster(
        gmJson, client, rankingsBox,
        update: update);

    client.close();
    await gmBox.close();

    yield Pair(a: message, b: 1.0);
    _initializeTeams();

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
    String response = await client
        .read(Uri.https(globals.url, '${globals.pathPrefix}timestamp.txt'));

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
        String response = await client.read(
            Uri.https(globals.url, '${globals.pathPrefix}gamemaster.json'));

        // If request was successful, load in the new gamemaster,
        gmJson = jsonDecode(response);
      } catch (error) {
        gmJson = await _loadFromAssets();
      }
    }

    gmJson ??= await _loadFromAssets();
    return gmJson;
  }

  Widget _buildPogoScaffold() {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: PogoDrawer(
        onNavSelected: _onNavSelected,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: _pages[_navKey],
      ),
    );
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
  void dispose() {
    _progressBarAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize media queries
    SizeConfig().init(context);

    if (_loaded) return _buildPogoScaffold();

    // App loading procedure
    return StreamBuilder<Pair<String, double>>(
      stream: _loadGamemaster(),
      initialData: Pair(a: 'Loading...', b: 0.0),
      builder: (context, snapshot) {
        // App is finished loading
        if (snapshot.connectionState == ConnectionState.done) {
          _loaded = true;
          _progressBarAnimController.stop();

          return _buildPogoScaffold();
        }
        // Progress update
        if (snapshot.hasData) {
          _progressBarAnimController.animateTo(snapshot.data!.b,
              curve: Curves.easeInOut);
        }

        // Rebuild progress bar
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 2.0,
              right: SizeConfig.blockSizeHorizontal * 2.0,
              bottom: SizeConfig.blockSizeVertical * 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Loading message
                Text(
                  snapshot.data!.a,
                  style: TextStyle(
                    fontSize: SizeConfig.h2,
                  ),
                ),

                // Spacer
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2.0,
                ),

                // Progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 80.0,
                      child: AnimatedBuilder(
                        animation: _progressBarAnimController,
                        builder: (context, child) => LinearProgressIndicator(
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.cyan),
                          value: _progressBarAnimController.value,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
