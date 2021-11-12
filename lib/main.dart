// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'pogo_teams_app.dart';
import 'data/globals.dart' as globals;
import 'data/masters/gamemaster.dart';

void main() async {
  // Global gamemaster reference setup
  // All Pokemon GO related data is in the gamemaster
  globals.gamemaster = await GameMaster.generateGameMaster();
  globals.gamemaster.initializeRankings();

  runApp(const PogoTeamsApp());
}
