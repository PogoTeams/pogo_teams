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
  const PogoScaffold({Key? key}) : super(key: key);

  @override
  _PogoScaffoldState createState() => _PogoScaffoldState();
}

class _PogoScaffoldState extends State<PogoScaffold>
    with TickerProviderStateMixin {
  bool _loaded = false;
  final UserTeams teams = UserTeams();

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

  // Fade in animation on page startup
  late final AnimationController _animController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _animController,
    curve: Curves.easeIn,
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
    // Reset and replay the fade in animation
    _animController.reset();
    _animController.forward();

    setState(() {
      _navKey = navKey;
    });
  }

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
    _animController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  late final AnimationController _animationController;

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

  Widget _buildPogoScaffold() {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: PogoDrawer(
        onNavSelected: _onNavSelected,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 2.0,
            right: SizeConfig.blockSizeHorizontal * 2.0,
            bottom: SizeConfig.blockSizeVertical * 2.0,
          ),
          child: _pages[_navKey],
        ),
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
  Widget build(BuildContext context) {
    // Initialize media queries
    SizeConfig().init(context);

    if (_loaded) return _buildPogoScaffold();

    // App loading procedure
    return StreamBuilder<double>(
      stream: _loadGamemaster(),
      initialData: 0.0,
      builder: (context, snapshot) {
        // App is finished loading
        if (snapshot.connectionState == ConnectionState.done) {
          _loaded = true;

          // Begin fade in animation
          _animController.forward();

          return _buildPogoScaffold();
        }

        // Progress update
        if (snapshot.hasData) {
          _animationController.animateTo(snapshot.data!,
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
