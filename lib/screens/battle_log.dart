// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package Imports
import 'package:dots_indicator/dots_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pogo_teams/widgets/buttons/gradient_button.dart';

// Local Imports
import 'team_builder_search.dart';
import '../configs/size_config.dart';
import '../widgets/dropdowns/cup_dropdown.dart';
import '../widgets/pogo_drawer.dart';
import '../widgets/teams_list.dart';
import '../data/cup.dart';
import '../data/pokemon/pokemon_team.dart';
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

  late Cup cup;
  late int teamCount;
  List<PokemonTeam> teams = [];

  // Fade in animation on page startup
  late final AnimationController _animController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _animController,
    curve: Curves.easeIn,
  );

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
              onClear: _onClear,
              onEdit: _onEdit,
            ),
          ],
        ),
      ),
    );
  }

  // Build the header options for the log screen
  Widget _buildHeader() {
    return Row(
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
    );
  }

  void _onAddTeam() async {
    final newTeam = await Navigator.push(
      context,
      MaterialPageRoute<List<Pokemon?>>(builder: (BuildContext context) {
        return TeamBuilderSearch(cup: cup);
      }),
    );

    // Add a new team to the list
    setState(() {
      PokemonTeam newPokemonTeam = PokemonTeam();
      newPokemonTeam.readFromStorage(teamCount, _storage);

      // If a team was built in the initial search screen
      if (newTeam != null) {
        newPokemonTeam.setTeam(newTeam);
      }

      teams.add(newPokemonTeam);
      ++teamCount;
    });
  }

  void _onEdit(List<Pokemon?> teamToEdit) async {
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
        teamToEdit = newTeam;
      });
    }
  }

  void _onCupChanged(String? newCup) {
    if (newCup == null) return;

    setState(() {
      cup = globals.gamemaster.cups.firstWhere((cup) => cup.title == newCup);
    });
  }

  // When a team is cleared from the list, invoke a rebuild
  void _onClear() async {
    setState(() {
      --teamCount;
    });

    await _storage.setItem('teamCount', teamCount);
  }

  // Initialize data values with local storage
  void _initializeData() {
    cup = globals.gamemaster.cups[0];
    teamCount = _storage.getItem('teamCount') ?? 0;

    for (int i = 0; i < teamCount; ++i) {
      teams.add(PokemonTeam());
      teams[i].readFromStorage(i, _storage);
    }
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
