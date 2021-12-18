// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import 'data/builder_teams.dart';
import 'pages/teams/teams_builder.dart';
import 'pages/rankings.dart';
import 'configs/size_config.dart';
import 'widgets/pogo_drawer.dart';

/*
-------------------------------------------------------------------------------
The top level scaffold for the app. Navigation via the scaffold's drawer, will
apply changes to the body, and app bar title. This widget renders upon the app
finishing it's loading phase.
-------------------------------------------------------------------------------
*/

class PogoScaffold extends StatefulWidget {
  const PogoScaffold({
    Key? key,
    required this.teams,
  }) : super(key: key);

  final UserTeams teams;

  @override
  _PogoScaffoldState createState() => _PogoScaffoldState();
}

class _PogoScaffoldState extends State<PogoScaffold>
    with SingleTickerProviderStateMixin {
  // All pages that are accessible at the top level of the app
  late final Map<String, Widget> _pages;

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
    _pages = {
      'Teams': TeamsBuilder(teams: widget.teams),
      'Rankings': const Rankings(),
    };
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Begin fade in animation
    _animController.forward();

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
          ),
          child: _pages[_navKey],
        ),
      ),
    );
  }
}
