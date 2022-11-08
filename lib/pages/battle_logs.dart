// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../modules/ui/sizing.dart';
import '../game_objects/cup.dart';
import '../widgets/dropdowns/cup_dropdown.dart';
import '../modules/data/gamemaster.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class BattleLogs extends StatefulWidget {
  const BattleLogs({Key? key}) : super(key: key);

  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<BattleLogs> {
  late Cup cup;

  void _onCupChanged(String? newCupId) {
    if (newCupId == null) return;

    setState(() {
      cup = Gamemaster().getCupById(newCupId);
    });
  }

  Widget _buildDropdowns() {
    return Padding(
      padding: EdgeInsets.only(
        left: Sizing.blockSizeHorizontal * 1.0,
        right: Sizing.blockSizeHorizontal * 1.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dropdown for pvp cup selection
          CupDropdown(
            cup: cup,
            onCupChanged: _onCupChanged,
            width: Sizing.screenWidth * .7,
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedBattles() {
    return Container();
  }

  // Setup the input controller
  @override
  void initState() {
    super.initState();

    cup = Gamemaster().cups.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.blockSizeVertical * 2.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Dropdowns for selecting a cup and a category
          _buildDropdowns(),

          // Logged battles list
          _buildLoggedBattles(),
        ],
      ),
    );
  }
}
