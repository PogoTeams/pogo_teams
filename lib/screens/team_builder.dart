// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:dots_indicator/dots_indicator.dart';
import 'package:provider/provider.dart';

// Local Imports
import '../configs/size_config.dart';
import '../widgets/pokemon_team.dart';

/*
-------------------------------------------------------------------------------
From this screen, the user can select up to 3 Pokemon for a single PVP team.
The user can build multiple teams via a horizontally swipeable PageView, which
currently supports up to 5 teams. This would ideally be dynamically lengthed.
They can specify the PVP cup for that team, and meta-relevant information
on the Pokemon currently on the team will update in realtime. The user can
navigate to the Anaysis or GoHub Info screen via footer buttons.
-------------------------------------------------------------------------------
*/

// A horizontally swipeable page view of all teams the user has made
// each page represents a single team that can be analyzed and edited
class TeamBuilder extends StatelessWidget {
  const TeamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Perform media queries to scale app UI content
    SizeConfig().init(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            right: SizeConfig.screenWidth * .025,
            left: SizeConfig.screenWidth * .025,
          ),
          child: const TeamsPages(),
        ),
      ),
    );
  }
}

// The swipeable body of the team builder
// The user can make any number of teams using these pages
class TeamsPages extends StatefulWidget {
  const TeamsPages({Key? key}) : super(key: key);

  @override
  _TeamsPagesState createState() => _TeamsPagesState();
}

class _TeamsPagesState extends State<TeamsPages> {
  // The number of editable teams available to the user
  final int teamCount = 5;

  // Used for the dot indicator
  double _pageIndex = 0.0;

  // Used for a horizontally swipeable PageView
  final PageController _controller = PageController(
    initialPage: 0,
  );

  // Currently, the user is given 5 editable team pages.
  // Conditionally appending a new team could be a nice feature,
  // in the event the user has used populated all available pages.
  late final List<ChangeNotifierProvider<PokemonTeam>> pages = List.filled(
    teamCount,
    ChangeNotifierProvider<PokemonTeam>(
      create: (context) => PokemonTeam(),
      child: Consumer<PokemonTeam>(
        builder: (context, pokemon, child) {
          return const TeamPage();
        },
      ),
    ),
  );

  // Update _pageIndex, consequently updating the dot indicatior
  // newIndex is supplied by the PageView widget
  void _updatePageIndex(int newIndex) {
    setState(() {
      _pageIndex = newIndex.toDouble();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Horizontally swipeable team pages
        SizedBox(
          height: SizeConfig.screenHeight * .88,
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            children: pages,
            onPageChanged: _updatePageIndex,
          ),
        ),

        // Dots indicating the current team page
        DotsIndicator(
          dotsCount: teamCount,
          position: _pageIndex,
        )
      ],
    );
  }
}
