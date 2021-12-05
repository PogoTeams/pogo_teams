// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:localstorage/localstorage.dart';
import 'package:pogo_teams/screens/log_analysis.dart';
import 'package:pogo_teams/widgets/buttons/analyze_button.dart';

// Local Imports
import 'team_builder_search.dart';
import '../configs/size_config.dart';
import '../widgets/dropdowns/cup_dropdown.dart';
import '../widgets/pogo_drawer.dart';
import '../widgets/teams_list.dart';
import '../data/cup.dart';
import '../data/pokemon/pokemon.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class BattleLog extends StatefulWidget {
  const BattleLog({Key? key}) : super(key: key);

  @override
  _BattleLogState createState() => _BattleLogState();
}

class _BattleLogState extends State<BattleLog>
    with SingleTickerProviderStateMixin {
  // The local storage for battle logs
  final LocalStorage _storage = LocalStorage('battle_logs.json');
  bool initialized = false;

  late Cup cup;
  late int teamCount;
  List<List<Pokemon?>> teams = List.empty(growable: true);

  // Fade in animation on page startup
  late final AnimationController _animController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _animController,
    curve: Curves.easeIn,
  );

  // Initialize data values with local storage
  void _initializeData() {
    if (!initialized) {
      // Get the cup from locals storage
      final cupTitle = _storage.getItem('cup');
      if (cupTitle == null) {
        cup = globals.gamemaster.cups[0];
      } else {
        cup =
            globals.gamemaster.cups.firstWhere((cup) => cup.title == cupTitle);
      }

      teamCount = _storage.getItem('teamCount') ?? 0;
      final idMap = globals.gamemaster.pokemonIdMap;

      // Initialize all teams from local storage
      for (int i = 0; i < teamCount; ++i) {
        final List<dynamic> jsonList = _storage.getItem('log_team_$i');
        teams.add(List.empty(growable: true));

        for (int k = 0; k < jsonList.length; ++k) {
          teams[i].add(Pokemon.readFromStorage(jsonList[k], idMap));
        }
      }

      initialized = true;
    }
  }

  // Build the scaffold once local storage has been read in
  // A glorious fade in will occur for max cool-ness
  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildScaffoldTitle(),
      ),
      drawer: const PogoDrawer(),
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Battle Log',
          style: TextStyle(
            fontSize: SizeConfig.h2,
            fontStyle: FontStyle.italic,
          ),
        ),

        // Spacer
        SizedBox(
          width: SizeConfig.blockSizeHorizontal * 3.0,
        ),

        Icon(
          Icons.query_stats,
          size: SizeConfig.blockSizeHorizontal * 6.0,
        ),
      ],
    );
  }

  Widget _buildScaffoldBody() {
    // Begin fade in animation
    _animController.forward();

    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 2.0,
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: Column(
          children: [
            _buildHeader(),

            // Spacer
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),

            // The list of opponent teams
            TeamsList(
              teams: teams,
              cupColor: cup.cupColor,
              onTeamCleared: _onTeamCleared,
              onEdit: _onEdit,
            ),
          ],
        ),
      ),
    );
  }

  // Build the header options for the log screen
  Widget _buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnalyzeButton(
          isEmpty: teams.isEmpty,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<Pokemon>(builder: (BuildContext context) {
                return LogAnalysis(
                  teams: teams,
                  cup: cup,
                );
              }),
            );
          },
        ),

        // Spacer
        SizedBox(
          height: SizeConfig.blockSizeVertical * 2.0,
        ),

        // The cup dropdown and add team button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dropdown for pvp cup selection
            CupDropdown(
              cup: cup,
              onCupChanged: _onCupChanged,
              width: SizeConfig.screenWidth * .7,
            ),

            // Add team button
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 20.0,
              child: IconButton(
                icon: const Icon(Icons.add_circle),
                iconSize: SizeConfig.blockSizeHorizontal * 7.0,
                onPressed: _onAddTeam,
                tooltip: 'Log a new team',
              ),
            ),
          ],
        )
      ],
    );
  }

  void _onAddTeam() async {
    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<List<Pokemon?>>(builder: (BuildContext context) {
        return TeamBuilderSearch(cup: cup);
      }),
    );

    if (newTeam == null) return;

    // Add a new team to the list
    setState(() {
      teams.add(newTeam);
      ++teamCount;
    });

    await _storage.setItem('teamCount', teamCount);
    _saveTeamsToStorage();
  }

  void _onEdit(List<Pokemon?> teamToEdit, int index) async {
    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<List<Pokemon?>>(builder: (BuildContext context) {
        if (teamToEdit.isEmpty) {
          return TeamBuilderSearch(cup: cup);
        }

        return TeamBuilderSearch(
          cup: cup,
          team: teamToEdit,
        );
      }),
    );

    if (newTeam != null) {
      setState(() {
        teams[index] = newTeam;
      });

      _saveTeamsToStorage();
    }
  }

  void _saveTeamsToStorage() async {
    for (int i = 0; i < teamCount; ++i) {
      await _storage.setItem('log_team_$i', [
        teams[i][0] == null ? null : teams[i][0]!.toJson(),
        teams[i][1] == null ? null : teams[i][1]!.toJson(),
        teams[i][2] == null ? null : teams[i][2]!.toJson(),
      ]);
    }
  }

  void _onCupChanged(String? newCup) async {
    if (newCup == null) return;

    setState(() {
      cup = globals.gamemaster.cups.firstWhere((cup) => cup.title == newCup);
    });

    await _storage.setItem('cup', newCup);
  }

  // When a team is cleared from the list, invoke a rebuild
  void _onTeamCleared(int index) async {
    teams[index].clear();

    setState(() {
      teams.removeAt(index);
      --teamCount;
    });

    await _storage.setItem('teamCount', teamCount);
  }

  @override
  void dispose() {
    _storage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storage.ready,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // While local storage is linking
        if (snapshot.data == null) {
          return Container();
        }

        // Once local storage is ready, initialize data
        _initializeData();

        // Render the team builder page
        return _buildScaffold(context);
      },
    );
  }
}
