// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:dots_indicator/dots_indicator.dart';
import 'package:localstorage/localstorage.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/pokemon/pokemon_team.dart';
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
    return const TeamsPages();
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final LocalStorage _storage = LocalStorage('teams_data.json');
  bool initialized = false;

  final int maxTeamCount = 15;
  final int minTeamCount = 3;

  // A flag to set whether the max page allocations has been met
  late bool _maxed = false;

  // The number of editable teams available to the user
  late int teamCount = minTeamCount;

  // The index cooresponding to the currently display page
  late int _pageIndex = 0;

  // For handling the swipeable pages
  late final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  // A list of pokemon teams and a list of their respective pages
  late List<PokemonTeam> _teams;
  late List<TeamPage> _pages;

  // Called when a dot in the dot indicator is tapped
  // The PageView will animate to the cooresponding page
  void _jumpToPage(int index) {
    setState(() {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          index,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
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

        // set a _maxed flag to render the last dot
        if (!_maxed && teamCount == maxTeamCount) {
          _maxed = true;
        } else if (!_maxed) {
          // If max not reached, increment team count
          ++teamCount;
        }
      } else {
        _pageIndex = index;
      }
      _saveToStorage();
    });
  }

  // Edge cases for displaying the number of dots in the dot indicator
  int _getDotCount() {
    return (teamCount == maxTeamCount && _maxed ? maxTeamCount : teamCount - 1);
  }

  // Setup the team list, and page list that cooresponds to each team
  void _initializeLists() {
    _teams = List.generate(maxTeamCount, (index) => PokemonTeam());
    _pages = List.generate(
      maxTeamCount,
      (index) => TeamPage(
        key: UniqueKey(),
        team: _teams[index],
      ),
    );
  }

  void _saveToStorage() async {
    await _storage.setItem('teamCount', teamCount);
  }

  void _clearStorage() async {
    await _storage.clear();

    setState(() {
      teamCount = minTeamCount;
      _saveToStorage();
    });
  }

  @override
  void initState() {
    super.initState();

    _initializeLists();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _storage.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Scaffold(
              body: Center(
                child: LinearProgressIndicator(),
              ),
            );
          }

          if (!initialized) {
            //_clearStorage();
            teamCount = (_storage.getItem('teamCount') ?? minTeamCount) as int;
            _maxed = teamCount == maxTeamCount;

            for (int i = 0; i < maxTeamCount; ++i) {
              _teams[i].readFromStorage(i, _storage);
            }

            initialized = true;
          }

          return Scaffold(
            // Horizontally swipeable team pages
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 1.0,
                  left: SizeConfig.safeBlockHorizontal * .25,
                  right: SizeConfig.safeBlockHorizontal * .25,
                ),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: _pages,
                ),
              ),
            ),

            // Dots indicator
            bottomNavigationBar: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: SizeConfig.screenHeight * .08,
              padding:
                  EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2.0),
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
          );
        });
  }
}
