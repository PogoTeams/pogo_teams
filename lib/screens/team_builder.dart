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
import '../widgets/confirmation_dialog.dart';
import '../widgets/pogo_drawer.dart';

/*
-------------------------------------------------------------------------------
This screen allows the user to build up to 15 teams in a horizontally
swipeable PageView. Team analysis, and additional team building tools are
built for each page via TeamPage.
-------------------------------------------------------------------------------
*/

class TeamBuilder extends StatefulWidget {
  const TeamBuilder({Key? key}) : super(key: key);

  @override
  _TeamBuilderState createState() => _TeamBuilderState();
}

class _TeamBuilderState extends State<TeamBuilder>
    with SingleTickerProviderStateMixin {
  // Local storage for data persistance across app sessions
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
  late final PageController _pageController;

  // A list of pokemon teams and a list of their respective pages
  late List<PokemonTeam> _teams;
  late List<TeamPage> _pages;

  late final AnimationController _animController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _animController,
    curve: Curves.easeIn,
  );

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
    await _storage.setItem('pageIndex', _pageIndex);
  }

  void _clearStorage() async {
    await _storage.clear();
  }

  // Initialize all data once the local storage has been linked
  void _initializeData() {
    if (!initialized) {
      teamCount = (_storage.getItem('teamCount') ?? minTeamCount) as int;
      _pageIndex = (_storage.getItem('pageIndex') ?? 0) as int;
      _pageController = PageController(initialPage: _pageIndex, keepPage: true);
      _maxed = teamCount == maxTeamCount;

      for (int i = 0; i < maxTeamCount; ++i) {
        _teams[i].readFromStorage(i, _storage);
      }

      initialized = true;
    }
  }

  // The dots indicator on the scaffold footer
  Widget _buildDotsIndicator(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: SizeConfig.screenHeight * .07,
      padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2.0),
      child: DotsIndicator(
        dotsCount: _getDotCount(),
        position: _pageIndex.toDouble(),
        axis: Axis.horizontal,
        decorator: DotsDecorator(
          activeColor: Colors.white,
          color: Colors.grey,
          spacing: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 1.7,
            right: SizeConfig.blockSizeHorizontal * 1.7,
          ),
        ),
        onTap: (pos) {
          _jumpToPage(pos.toInt());
        },
      ),
    );
  }

  // Build the scaffold once local storage has been read in
  // A glorious fade in will occur for max cool-ness
  Widget _buildScaffold(BuildContext context) {
    // Begin fade in animation
    _animController.forward();

    return Scaffold(
      appBar: AppBar(
        title: _buildScaffoldTitle(),
      ),
      drawer: PogoDrawer(
        onClearAll: _onRemoveAllTeamsPressed,
      ),
      body: _buildScaffoldBody(),
      bottomNavigationBar: _buildDotsIndicator(context),
    );
  }

  Widget _buildScaffoldTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Team Builder',
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
          Icons.build_circle,
          size: SizeConfig.blockSizeHorizontal * 6.0,
        ),
      ],
    );
  }

  Widget _buildScaffoldBody() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 2.0,
        ),
        child: FadeTransition(
          opacity: _animation,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _pages,
          ),
        ),
      ),
    );
  }

  // Callback for remove all teams in the app drawer
  // Confirm that the user wants to remove all teams, then do the deed
  void _onRemoveAllTeamsPressed() async {
    bool clearAll = await confirmationDialog(context);

    if (clearAll) _clearAllData();
  }

  // Re-initialize, and clear all data / storage
  void _clearAllData() async {
    // Reinitialize the lists
    _initializeLists();

    // Clear the local storage
    _clearStorage();

    // Pop from the drawer
    Navigator.pop(context);

    // Animate to the first page in the team builder
    //_jumpToPage(0);
    if (_pageController.hasClients) {
      await _pageController.animateToPage(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }

    // Set defaults
    setState(() {
      teamCount = minTeamCount;
      _pageIndex = 0;
      _maxed = false;

      // Relink the storage to the new teams
      for (int i = 0; i < maxTeamCount; ++i) {
        _teams[i].readFromStorage(i, _storage);
      }
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
    _animController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize media queries
    SizeConfig().init(context);

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
