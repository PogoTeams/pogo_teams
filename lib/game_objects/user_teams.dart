// Local Imports
import 'pokemon_team.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All user created teams are managed by this abstraction. All user db operations
are also handled here as well.
-------------------------------------------------------------------------------
*/

class UserTeams {
  final List<UserPokemonTeam> _builderTeams = List.empty(growable: true);
  int teamsCount = 0;

  UserPokemonTeam operator [](int index) => _builderTeams[index];
  int get length => _builderTeams.length;

  // Add a new empty team
  void addTeam(UserPokemonTeam team) {
    team.sortOrder = teamsCount;
    _builderTeams.add(team);
    ++teamsCount;
  }

  void addTeamJson(Map<String, dynamic> teamJson, String id) {
    _builderTeams.add(UserPokemonTeam.fromJson(teamJson)..id = id);
    ++teamsCount;
  }

  // Remove a team at the specified index
  UserPokemonTeam removeTeamAt(int index) {
    --teamsCount;
    return _builderTeams.removeAt(index);
  }
}
