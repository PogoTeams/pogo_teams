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
  init() async => await _load();

  // Load data from the db
  Future<void> _load() async {
    _box = await Hive.openBox('teams'); // User data

    teamsCount = (_box.get('teamsCount') ?? 0) as int;

    for (int i = 0; i < teamsCount; ++i) {
      _builderTeams.add(UserPokemonTeam(save: () => _save(i)));
      _builderTeams[i].fromJson(_box.getAt(i));
      _save(i);
    }
  }

  late final Box _box;
  final List<UserPokemonTeam> _builderTeams = List.empty(growable: true);
  int teamsCount = 0;

  // Getter
  UserPokemonTeam operator [](int index) => _builderTeams[index];

  // Add a new empty team
  void addTeam() async {
    final teamIndex = teamsCount;
    _builderTeams.add(UserPokemonTeam(save: () => _save(teamIndex)));
    ++teamsCount;

    await _box.put('teamsCount', teamsCount);
    await _box.put('team_${teamsCount - 1}', _builderTeams.last.toJson());
  }

  // Remove a team at the specified index
  void removeTeamAt(int index) async {
    _builderTeams.removeAt(index);

    // Adjust the team callbacks to follow with their new respective index
    for (int i = index; i < _builderTeams.length; ++i) {
      _builderTeams[i].save = () => _save(i);
    }

    --teamsCount;

    await _box.put('teamsCount', teamsCount);
    await _box.delete('team_$index');
  }

  // Save the team at specified index
  void _save(int index) async =>
      await _box.put('team_$index', _builderTeams[index].toJson());

  // Close the db
  void close() async => await _box.close();
}
