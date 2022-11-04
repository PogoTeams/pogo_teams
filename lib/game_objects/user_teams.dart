// Package Imports
import 'package:hive/hive.dart';

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

  // Getter
  UserPokemonTeam operator [](int index) => _builderTeams[index];

  // Add a new empty team
  void addTeam() async {
    final teamIndex = teamsCount;
    _builderTeams.add(UserPokemonTeam());
    ++teamsCount;
  }

  // Remove a team at the specified index
  void removeTeamAt(int index) async {
    _builderTeams.removeAt(index);
    --teamsCount;
  }
}
