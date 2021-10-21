import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'app_root.dart';

void main() async {
  globals.gamemaster = await globals.generateGameMaster();

  // Initialize the base widget PogoData containing all Pokemon GO data
  // Set the application PogoTeamsApp as this widget's child
  runApp(const PogoTeamsApp());
}
