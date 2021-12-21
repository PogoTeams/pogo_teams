// Local Imports
import 'masters/gamemaster.dart';

/*
-------------------------------------------------------------------- @PogoTeams
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

// Used to specify the /test directory when testing a new update
String pathPrefix = '/';

// The earliest timestamp (used for initial app start up)
const String earliestTimestamp = '2021-01-01 00:00:00.00';

// Global gamemaster object
// This will be populated in the startup loading screen
GameMaster gamemaster = GameMaster.empty();
