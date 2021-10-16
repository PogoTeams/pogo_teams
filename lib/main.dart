import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'pokemon_search.dart';
import 'pogo_data.dart';

void main() async {
  // Create the gamemaster reference
  final gamemaster = await generateGameMaster();

  //DEBUG
  //gamemaster.display();

  // Initialize the base widget PogoData containing all Pokemon GO data
  // Set the application PogoTeamsApp as this widget's child
  runApp(PogoData(gamemaster: gamemaster, child: const PogoTeamsApp()));
}

Future<GameMaster> generateGameMaster() async {
  // Ensure the application layer is built so gamemaster.json can be parsed
  WidgetsFlutterBinding.ensureInitialized();

  // Load the JSON string
  final String gmString = await rootBundle.loadString('assets/gamemaster.json');
  // Decode to a map
  final Map<String, dynamic> gmJson = jsonDecode(gmString);
  return GameMaster.fromJson(gmJson);
}
