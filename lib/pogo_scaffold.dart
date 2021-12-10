// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo_teams/widgets/pogo_drawer.dart';

// Package Imports
import 'package:provider/provider.dart';

// Local Imports
import 'configs/size_config.dart';
import 'pages/team_builder/team_builder.dart';
import 'pages/rankings.dart';
import 'data/teams_provider.dart';

/*
-------------------------------------------------------------------------------
The top level scaffold for the app. Navigation via the scaffold's drawer, will
apply changes to the body, and app bar title.
-------------------------------------------------------------------------------
*/

class PogoScaffold extends StatefulWidget {
  const PogoScaffold({Key? key}) : super(key: key);

  @override
  _PogoScaffoldState createState() => _PogoScaffoldState();
}

class _PogoScaffoldState extends State<PogoScaffold>
    with SingleTickerProviderStateMixin {
  // All pages that are accessible at the top level of the app
  final Map<String, Widget> _pages = {
    'Team Builder': Consumer<TeamsProvider>(
        builder: (context, value, child) => const TeamBuilder()),
    'Rankings': const Rankings(),
  };

  // Icons cooresponding to the pages
  final Map<String, IconData> _icons = {
    'Team Builder': Icons.build_circle,
    'Rankings': Icons.bar_chart,
  };

  // Used to navigate between pages by key
  String _navKey = 'Team Builder';

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
          Icon(
            _icons[_navKey],
            size: SizeConfig.blockSizeHorizontal * 6.0,
          ),
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

    // Begin fade in animation
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize media queries
    SizeConfig().init(context);

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
