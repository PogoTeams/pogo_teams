// Flutter Imports
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:dots_indicator/dots_indicator.dart';

// Local Imports
import '../screens/team_analysis.dart';
import 'team_info.dart';
import '../configs/size_config.dart';
import '../widgets/pokemon_team.dart';
import '../widgets/buttons/footer_buttons.dart';
import '../data/pokemon/pokemon.dart';

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
  final int minTeamCount = 2;

  // The number of editable teams available to the user
  late int teamCount = minTeamCount;

  // The index cooresponding to the currently display page
  int _pageIndex = 0;

  // For handling the swipeable pages
  final PageController _controller = PageController(initialPage: 0);

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
            pokemonTeam: selectedTeam.getPokemonTeam(),
            selectedCup: selectedTeam.cup,
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

  void _onPageChanged(int index, {bool jump = false}) {
    // Swiped right
    setState(() {
      /*
      TODO implement jump on tap
      if (jump) {
        _controller.animateToPage(index,
            duration: Duration(milliseconds: 50), curve: Curves.bounceIn);
      }
      */

      if (index > _pageIndex) {
        _pageIndex = index;
        if (teamCount == maxTeamCount || index < teamCount - 1) {
          return;
        }

        ++teamCount;
        _teams.add(PokemonTeam());
        _pages.add(TeamPage(pokemonTeam: _teams[index]));
      }

      // Swiped Left
      else {
        _pageIndex = index;
        if (teamCount == minTeamCount || index == maxTeamCount - minTeamCount) {
          return;
        }

        if (index == teamCount - 3 &&
            _teams.last.isEmpty() &&
            _teams[index].isEmpty()) {
          _teams.removeLast();
          _pages.removeLast();
          --teamCount;
        }
      }
    });
  }

  // Setup the team list, and page list that cooresponds to each team
  void _initializeLists() {
    _teams = [
      PokemonTeam(),
      PokemonTeam(),
    ];

    _pages = _teams.map((team) {
      return TeamPage(
        key: GlobalKey(),
        pokemonTeam: team,
      );
    }).toList();
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
          height: SizeConfig.screenHeight * 0.77,
          child: PageView.builder(
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
        ),

        // Show dots indicator if there is more than 1 team
        Container(
          padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2.0),
          //width: SizeConfig.screenWidth * 0.7,
          child: DotsIndicator(
            dotsCount: teamCount,
            position: _pageIndex.toDouble(),
            axis: Axis.horizontal,
            decorator: const DotsDecorator(
              activeColor: Colors.white,
              color: Colors.grey,
            ),
            /*
            onTap: (pos) {
              _onPageChanged(pos.toInt(), jump: true);
            },
            */
          ),
        ),

        // Buttons at the bottom of the screen
        // These will navigate to a new page
        FooterButtons(
          onAnalyzePressed: _onAnalyzePressed,
          onTeamInfoPressed: _onTeamInfoPressed,
        ),

        //SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
      ],
    );
  }
}
