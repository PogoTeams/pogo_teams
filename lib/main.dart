import 'package:flutter/material.dart';
import 'data/globals.dart' as globals;
import 'app_root.dart';

void main() async {
  // Global gamemaster reference setup
  // All Pokemon GO related data is in the gamemaster
  globals.gamemaster = await globals.generateGameMaster();

  runApp(const PogoTeamsApp());
}
