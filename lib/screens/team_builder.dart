// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../screens/team_analysis.dart';
import 'team_info.dart';
import '../configs/size_config.dart';
import '../widgets/pokemon_team.dart';
import '../widgets/footer_buttons.dart';
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
  // The number of editable teams available to the user
  int teamCount = 5;

  // The index cooresponding to the currently display page
  int _selectedIndex = 0;

  // For handling the swipeable pages
  late final TabController _controller;

  // A list of pokemon teams and a list of their respective pages
  late final List<PokemonTeam> _teams;
  late final List<TeamPage> _pages;

  // Push the team analysis screen onto the navigator stack.
  // The pokemon team changes there will be reflected in newTeam
  void _onAnalyzePressed() async {
    final PokemonTeam selectedTeam = _teams[_selectedIndex];

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
    final PokemonTeam selectedTeam = _teams[_selectedIndex];

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

  // Setup the team list, and page list that cooresponds to each team
  void _initializeLists() {
    _teams = [
      PokemonTeam(),
      PokemonTeam(),
      PokemonTeam(),
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
    _controller = TabController(length: teamCount, vsync: this);

    // Upon controller updating, update the local index
    // This is used to access the Pokemon Team currently displayed
    _controller.addListener(() {
      _selectedIndex = _controller.index;
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Horizontally swipeable team pages
        SizedBox(
          height: SizeConfig.screenHeight * 0.79,
          child: TabBarView(
            controller: _controller,
            children: _pages,
          ),
        ),

        TabPageSelector(
          controller: _controller,
          indicatorSize: SizeConfig.blockSizeHorizontal * 3.0,
        ),

        // Spacer
        SizedBox(height: SizeConfig.blockSizeVertical * 2.0),

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
