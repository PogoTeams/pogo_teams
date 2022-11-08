// Local Imports
import 'pokemon_team.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class OpponentPokemonTeams {
  final List<OpponentPokemonTeam> _teamsList = List.empty(growable: true);
  List<OpponentPokemonTeam> get teamsList => _teamsList;

  int teamsCount = 0;

  OpponentPokemonTeam operator [](int index) => _teamsList[index];
  void operator []=(int index, OpponentPokemonTeam value) =>
      _teamsList[index] = value;
  int get length => _teamsList.length;

  // Add a new empty team
  void addTeam(OpponentPokemonTeam team) {
    team.sortOrder = teamsCount;
    _teamsList.add(team);
    ++teamsCount;
  }

  void addTeamJson(Map<String, dynamic> teamJson, String id) {
    _teamsList.add(OpponentPokemonTeam.fromJson(teamJson)..id = id);
    ++teamsCount;
  }

  // Remove a team at the specified index
  OpponentPokemonTeam removeTeamAt(int index) {
    --teamsCount;
    return _teamsList.removeAt(index);
  }
}
