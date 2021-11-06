import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter/services.dart';
import 'dart:convert';
import 'gamemaster.dart';

// The number of Pokemon types in the game
const typeCount = 18;

// Global reference to all Pokemon GO data
late final GameMaster gamemaster;

// Read in gamemaster.json and populate the global GameMaster object
Future<GameMaster> generateGameMaster() async {
  // Ensure the application layer is built so gamemaster.json can be parsed
  WidgetsFlutterBinding.ensureInitialized();
  // Load the JSON string
  final String gmString = await rootBundle.loadString('data/gamemaster.json');
  // Decode to a map
  final Map<String, dynamic> gmJson = jsonDecode(gmString);

  return GameMaster.fromJson(gmJson);
}
