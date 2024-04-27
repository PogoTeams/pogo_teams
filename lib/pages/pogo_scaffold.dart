// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'pogo_pages.dart';
import '../modules/pogo_repository.dart';
import '../utils/pair.dart';
import '../app/ui/sizing.dart';
import '../modules/globals.dart';
import '../widgets/navigation/pogo_drawer.dart';
import '../utils/animations.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The top level scaffold for the app. Navigation via the scaffold's drawer, will
apply changes to the body, and app bar title. Upon startup, this widget enters
a loading phase, which animates a progress bar while the gamemaster and
rankings data are loaded. 
-------------------------------------------------------------------------------
*/

class PogoScaffold extends StatefulWidget {
  const PogoScaffold({super.key});

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
    if (_loaded) {
      return _CanonicalPogoScaffold(
        currentPage: _currentPage,
        onNavSelected: _onNavSelected,
      );
    }

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

          return _CanonicalPogoScaffold(
            currentPage: _currentPage,
            onNavSelected: _onNavSelected,
          );
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
              left: Sizing.screenWidth(context) * .02,
              right: Sizing.screenWidth(context) * .02,
              bottom: Sizing.screenHeight(context) * .10,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: Sizing.screenWidth(context) * .03,
                right: Sizing.screenWidth(context) * .05,
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

class _CanonicalPogoScaffold extends StatefulWidget {
  const _CanonicalPogoScaffold({
    required this.currentPage,
    required this.onNavSelected,
  });

  final PogoPages currentPage;
  final void Function(PogoPages) onNavSelected;

  @override
  State<_CanonicalPogoScaffold> createState() => _CanonicalPogoScaffoldState();
}

class _CanonicalPogoScaffoldState extends State<_CanonicalPogoScaffold>
    with TickerProviderStateMixin {
  late final _navigationAnimationController = AnimationController(
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 1250),
    value: 0,
    vsync: this,
  );

  late final _railAnimation = RailAnimation(
    parent: _navigationAnimationController,
  );

  late final _railFabAnimation = RailFabAnimation(
    parent: _navigationAnimationController,
  );

  late final _barAnimation = BarAnimation(
    parent: _navigationAnimationController,
  );

  late final TabController _tabController =
      TabController(length: 6, vsync: this);

  late final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _controllerInitialized = false;

  // Build the app bar with the current page title, and icon
  AppBar _buildAppBar(bool isWideScreen) {
    return AppBar(
      automaticallyImplyLeading: !isWideScreen,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Page title
          Text(
            widget.currentPage.displayName,
            style: Theme.of(context).textTheme.headlineSmall?.apply(
                  fontStyle: FontStyle.italic,
                ),
          ),

          // Spacer
          SizedBox(
            width: Sizing.screenWidth(context) * .02,
          ),

          // Page icon
          widget.currentPage.icon,
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = Sizing.screenWidth(context);

    final AnimationStatus status = _navigationAnimationController.status;
    if (width > 600) {
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        _navigationAnimationController.forward();
      }
    } else {
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        _navigationAnimationController.reverse();
      }
    }

    if (!_controllerInitialized) {
      _controllerInitialized = true;
      _navigationAnimationController.value = width > 600 ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _railAnimation.dispose();
    _railFabAnimation.dispose();
    _navigationAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = Sizing.isWideScreen(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(isWideScreen),
      drawer: isWideScreen
          ? null
          : PogoDrawer(
              onNavSelected: widget.onNavSelected,
            ),
      extendBody: true,
      body: Row(
        children: [
          if (isWideScreen)
            PogoDrawer(
                onNavSelected: widget.onNavSelected, popOnNavSelected: false),
          /*
            HomeNavigationRail(
              railAnimation: _railAnimation,
              railFabAnimation: _railFabAnimation,
              destinations: const [
                PogoPages.teams,
                PogoPages.tags,
                PogoPages.battleLogs,
                PogoPages.rankings,
                PogoPages.sync,
                PogoPages.settings,
              ],
              selectedIndex: _tabController.index,
              backgroundColor: Theme.of(context).colorScheme.background,
              onDestinationSelected: (index) {
                _tabController.index = index;
                widget.onNavSelected(pogoPageFromIndex(index));
              },
            ),
            */
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: Sizing.screenWidth(context) * .02,
                right: Sizing.screenWidth(context) * .02,
              ),
              child: widget.currentPage.page,
            ),
          ),
        ],
      ),
    );
  }
}
