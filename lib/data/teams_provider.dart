// Flutter Imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package Imports
import 'package:hive/hive.dart';

// Local Imports
import 'pokemon/pokemon_team.dart';

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class TeamsProvider with ChangeNotifier {
  void init() {
    _box = Hive.box('teams');
    _load();
  }

  void _load() {
    teamsCount = (_box.get('teamsCount') ?? 0) as int;

    for (int i = 0; i < teamsCount; ++i) {
      builderTeams.add(UserPokemonTeam(save: () => _save(i)));
      builderTeams[i].fromJson(_box.getAt(i));
      _save(i);
    }
  }

  void _save(int index) async {
    await _box.put('team_$index', builderTeams[index].toJson());
  }

  late Box _box;
  List<UserPokemonTeam> builderTeams = List.empty(growable: true);
  int teamsCount = 0;

  @override
  void dispose() async {
    await _box.close();
    super.dispose();
  }

  // Manual notify
  void notify() => notifyListeners();

  // Add a new empty team
  void addTeam() async {
    final teamIndex = teamsCount;
    builderTeams.add(UserPokemonTeam(save: () => _save(teamIndex)));
    ++teamsCount;

    await _box.put('teamsCount', teamsCount);
    await _box.put('team_${teamsCount - 1}', builderTeams.last.toJson());

    notifyListeners();
  }

  void setTeamAt(int index, UserPokemonTeam team) async {
    builderTeams[index] = team;

    notifyListeners();
  }

  // Remove a team at the specified index
  void removeTeamAt(int index) async {
    builderTeams.removeAt(index);
    --teamsCount;
    await _box.put('teamsCount', teamsCount);
    await _box.delete('team_$index');

    notifyListeners();
  }
}
