// Package Imports
import 'package:hive/hive.dart';

// Local Imports
import 'pokemon/pokemon_team.dart';

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class UserTeams {
  init() async => await _load();

  Future<void> _load() async {
    _box = await Hive.openBox('teams'); // User data

    teamsCount = (_box.get('teamsCount') ?? 0) as int;

    for (int i = 0; i < teamsCount; ++i) {
      _builderTeams.add(UserPokemonTeam(save: () => _save(i)));
      _builderTeams[i].fromJson(_box.getAt(i));
      _save(i);
    }
  }

  UserPokemonTeam operator [](int index) => _builderTeams[index];

  void operator []=(int index, UserPokemonTeam other) async =>
      _builderTeams[index].fromBuilderCopy(other);

  late final Box _box;
  final List<UserPokemonTeam> _builderTeams = List.empty(growable: true);
  int teamsCount = 0;

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
    --teamsCount;

    await _box.put('teamsCount', teamsCount);
    await _box.delete('team_$index');
  }

  void _save(int index) async {
    await _box.put('team_$index', _builderTeams[index].toJson());
  }

  void close() async => await _box.close();
}
