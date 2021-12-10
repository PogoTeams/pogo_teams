// Flutter Imports
import 'package:flutter/foundation.dart';

// Local Imports
import 'pokemon/pokemon_team.dart';

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class TeamsProvider with ChangeNotifier {
  List<PokemonTeam> builderTeams = List.empty(growable: true);

  // Manual notify
  void notify() => notifyListeners();

  // Add a new empty team
  void addTeam() {
    builderTeams.add(PokemonTeam());
    notifyListeners();
  }

  void setTeamAt(int index, PokemonTeam team) {
    builderTeams[index] = team;
    notifyListeners();
  }

  // Remove a team at the specified index
  void removeTeamAt(int index) {
    builderTeams.removeAt(index);
    notifyListeners();
  }
}
