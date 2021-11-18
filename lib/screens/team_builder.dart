// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:dots_indicator/dots_indicator.dart';

// Local Imports
import 'team_info.dart';
import '../screens/team_analysis.dart';
import '../configs/size_config.dart';
import '../data/pokemon/pokemon_team.dart';
import '../data/pokemon/pokemon.dart';
import '../widgets/buttons/footer_buttons.dart';
import '../widgets/team_page.dart';

/*
-------------------------------------------------------------------------------
From this screen, the user can select up to 3 Pokemon for a single PVP team.
The user can build multiple teams via a horizontally swipeable PageView, which
currently supports up to 5 teams. This would ideally be dynamically lengthed.
They can specify the PVP cup for that team, and meta-relevant information
on the Pokemon currently on the team will update in realtime. The user can
navigate to the Anaysis or TeamInfo Info screen via footer buttons.
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

    return const Scaffold(
      body: SafeArea(
        child: TeamsPages(),
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

class _TeamsPagesState extends State<TeamsPages>
    with SingleTickerProviderStateMixin {
  final int maxTeamCount = 15;
  final int minTeamCount = 3;

  // A flag to set whether the max page allocations has been met
  bool maxed = false;

  // The number of editable teams available to the user
  late int teamCount = minTeamCount;

  // The index cooresponding to the currently display page
  int _pageIndex = 0;

  // For handling the swipeable pages
  final PageController _controller = PageController(
    initialPage: 0,
    keepPage: true,
  );

  // A list of pokemon teams and a list of their respective pages
  late List<PokemonTeam> _teams;
  late List<TeamPage> _pages;

  // Push the team analysis screen onto the navigator stack.
  // The pokemon team changes there will be reflected in newTeam
  void _onAnalyzePressed() async {
    final PokemonTeam selectedTeam = _teams[_pageIndex];

    // If the team is empty, no action will be taken
    if (selectedTeam.isEmpty()) return;

    // TODO update the new team
    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<List<Pokemon?>>(
        builder: (BuildContext context) {
          return TeamAnalysis(
            team: selectedTeam,
          );
        },
      ),
    );
  }

  // Push the TeamInfo screen onto the navigator stack
  void _onTeamInfoPressed() {
    final PokemonTeam selectedTeam = _teams[_pageIndex];

    // If the team is empty, no action will be taken
    if (selectedTeam.isEmpty()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return TeamInfo(pokemonTeam: selectedTeam.getPokemonTeam());
        },
      ),
    );
  }

  // Called when a dot in the dot indicator is tapped
  // The PageView will animate to the cooresponding page
  void _jumpToPage(int index) {
    setState(() {
      if (_controller.hasClients) {
        _controller.animateToPage(index,
            duration: const Duration(seconds: 1), curve: Curves.easeInOut);
      }
    });
  }

  // Conditionally build the teams list
  // There can be any where from 2 to maxTeamCount teams
  void _onPageChanged(int index) {
    // Attempting to go past the allocated page list which is null
    if (index > maxTeamCount - 1) return;

    setState(() {
      // If moving to the last page in the list
      if (index == teamCount - 1) {
        _pageIndex = index;

        // set a maxed flag to render the last dot
        maxed = (!maxed ? teamCount == maxTeamCount : maxed);

        // If max not reached, increment team count
        if (!maxed) ++teamCount;
      } else {
        _pageIndex = index;
      }
    });
  }

  // Edge cases for displaying the number of dots in the dot indicator
  int _getDotCount() {
    return (teamCount == maxTeamCount && maxed ? maxTeamCount : teamCount - 1);
  }

  // Setup the team list, and page list that cooresponds to each team
  void _initializeLists() {
    _teams = List.generate(maxTeamCount, (index) => PokemonTeam());
    _pages = List.generate(
      maxTeamCount,
      (index) => TeamPage(
        key: UniqueKey(),
        pokemonTeam: _teams[index],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _initializeLists();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Horizontally swipeable team pages
        SizedBox(
          height: SizeConfig.screenHeight * 0.79,
          child: PageView(
            controller: _controller,
            onPageChanged: _onPageChanged,
            children: _pages,
          ),
        ),

        // Show dots indicator if there is more than 1 team
        Container(
          padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2.0),
          child: DotsIndicator(
            dotsCount: _getDotCount(),
            position: _pageIndex.toDouble(),
            axis: Axis.horizontal,
            decorator: DotsDecorator(
              activeColor: Colors.white,
              color: Colors.grey,
              spacing: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 1.5,
                right: SizeConfig.blockSizeHorizontal * 1.5,
              ),
            ),
            onTap: (pos) {
              _jumpToPage(pos.toInt());
            },
          ),
        ),

        // Buttons at the bottom of the screen
        // These will navigate to a new page
        FooterButtons(
          onAnalyzePressed: _onAnalyzePressed,
          onTeamInfoPressed: _onTeamInfoPressed,
        ),
      ],
    );
  }
}
