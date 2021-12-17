// Local Imports
import 'masters/gamemaster.dart';

/*
-------------------------------------------------------------------------------
All global variables are managed here. Most notably the gamemaster instance
that models the entire app exists here. It's initialization is handled in
the GameMasters static generateGameMaster function.
-------------------------------------------------------------------------------
*/

// The number of Pokemon types in the game
const int typeCount = 18;

// The current app version
// Displayed at the footer of the app's drawer
const String version = 'v1.0.0';

// Server url for retrieving all updates
const String url = 'pogoteams.github.io';

// The earliest timestamp (used for initial app start up)
const String earliestTimestamp = '2021-01-01 00:00:00.00';

GameMaster gamemaster = GameMaster.empty();
