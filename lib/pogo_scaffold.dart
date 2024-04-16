// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'pages/pogo_pages.dart';
import 'modules/data/pogo_repository.dart';
import 'tools/pair.dart';
import 'modules/ui/sizing.dart';
import 'modules/data/globals.dart';
import 'widgets/pogo_drawer.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The top level scaffold for the app. Navigation via the scaffold's drawer, will
apply changes to the body, and app bar title. Upon startup, this widget enters
a loading phase, which animates a progress bar while the gamemaster and
rankings data are loaded. 
-------------------------------------------------------------------------------
*/

class PogoScaffold extends StatefulWidget {
  const PogoScaffold({Key? key}) : super(key: key);

  @override
  _PogoScaffoldState createState() => _PogoScaffoldState();
}

class _PogoScaffoldState extends State<PogoScaffold>
    with SingleTickerProviderStateMixin {
  // Flag for when the app has finished the loading phase
  bool _loaded = false;

  bool _forceUpdate = Globals.forceUpdate;

  bool get forceUpdate {
    if (_forceUpdate) {
      _forceUpdate = false;
      return true;
    }

    return _forceUpdate;
  }

  // Used to navigate between pages by key
  PogoPages _currentPage = PogoPages.teams;

  // For animating the loading progress bar
  late final AnimationController _progressBarAnimController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  // The main scaffold for the app
  // This will build once the loading phase is complete
  Widget _buildPogoScaffold() {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: PogoDrawer(
        onNavSelected: _onNavSelected,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: Sizing.blockSizeHorizontal * 2.0,
          right: Sizing.blockSizeHorizontal * 2.0,
        ),
        child: _currentPage.page,
      ),
    );
  }

  // Build the app bar with the current page title, and icon
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            _currentPage.displayName,
            style: Theme.of(context).textTheme.headlineSmall?.apply(
                  fontStyle: FontStyle.italic,
                ),
          ),

          // Spacer
          SizedBox(
            width: Sizing.blockSizeHorizontal * 2.0,
          ),

          // Page icon
          _currentPage.icon,
        ],
      ),
    );
  }

  // Callback for navigating to a new page in the app
  void _onNavSelected(PogoPages page) {
    setState(() {
      if (page == PogoPages.sync) {
        _forceUpdate = true;
        _loaded = false;
        _currentPage = PogoPages.teams;
      } else {
        _currentPage = page;
      }
    });
  }

  @override
  void dispose() {
    _progressBarAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize media queries
    Sizing().init(context);

    if (_loaded) return _buildPogoScaffold();

    // App loading procedure
    return StreamBuilder<Pair<String, double>>(
      stream: PogoRepository.loadPogoData(
        forceUpdate: forceUpdate,
      ),
      initialData: Pair(a: '', b: 0.0),
      builder: (context, snapshot) {
        // App is finished loading
        if (snapshot.connectionState == ConnectionState.done) {
          _loaded = true;
          _progressBarAnimController.stop();

          return _buildPogoScaffold();
        }
        // Progress update
        if (snapshot.hasData) {
          _progressBarAnimController.animateTo(
            snapshot.data!.b,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInCirc,
          );
        }

        // Rebuild progress bar
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              left: Sizing.blockSizeHorizontal * 2.0,
              right: Sizing.blockSizeHorizontal * 2.0,
              bottom: Sizing.blockSizeVertical * 10.0,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: Sizing.blockSizeHorizontal * 3.0,
                right: Sizing.blockSizeHorizontal * 5.0,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Loading message
                    Text(
                      snapshot.data!.a,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    // Loading indicator
                    SizedBox(
                      child: AnimatedBuilder(
                        animation: _progressBarAnimController,
                        builder: (context, child) => CircularProgressIndicator(
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.cyan),
                          semanticsLabel: 'Pogo Teams Loading Indicator',
                          semanticsValue: snapshot.data.toString(),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
