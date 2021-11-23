// Package Imports
import 'package:localstorage/localstorage.dart';

// Local Imports
import '../masters/type_master.dart';
import 'pokemon.dart';
import '../cup.dart';
import '../globals.dart' as globals;

/*
-------------------------------------------------------------------------------
The Pokemon Team data model contains a list of 3 nullable Pokemon references
and a Cup reference. This collection represents a single Pokemon PVP Team.
This Pokemon Team can then be used to compute various information throughout
the app.
-------------------------------------------------------------------------------
*/

// The data model for a Pokemon PVP Team
// Every team page manages one instance of this class
class PokemonTeam {
  late final LocalStorage _storage;

  // The list of 3 pokemon references that make up the team
  List<Pokemon?> team = List.filled(3, null);

  // A list of this pokemon team's net effectiveness
  List<double> effectiveness = List.generate(
    globals.typeCount,
    (index) => 0.0,
  );

  // The selected PVP cup for this team
  // Defaults to Great League
  Cup cup = globals.gamemaster.cups[0];

  int _teamIndex = 0;

  // Make a copy of the newTeam, keeping the size of the original team
  void setTeam(List<Pokemon?> newTeam) {
    team = List.generate(
        team.length, (index) => index < newTeam.length ? newTeam[index] : null);
    _updateEffectiveness();
    _saveToStorage();
  }

  // Set the specified Pokemon in the team by the specified index
  void setPokemon(int index, Pokemon? pokemon) {
    team[index] = pokemon;
    _updateEffectiveness();
    _saveToStorage();
  }

  // Get the list of non-null Pokemon
  List<Pokemon> getPokemonTeam() {
    return team.whereType<Pokemon>().toList();
  }

  // Get the Pokemon ref at the given index
  Pokemon getPokemon(int index) {
    return team[index] as Pokemon;
  }

  // Add newPokemon if there is free space in the team
  void addPokemon(Pokemon newPokemon) {
    bool added = false;

    for (int i = 0; i < team.length && !added; ++i) {
      if (team[i] == null) {
        team[i] = newPokemon;
        added = true;
      }
    }
    _updateEffectiveness();
  }

  // True if the Pokemon ref is null at the given index
  bool isNull(int index) {
    return team[index] == null;
  }

  // True if there are no Pokemon on the team
  bool isEmpty() {
    bool empty = true;
    for (int i = 0; i < team.length && empty; ++i) {
      empty = team[i] == null;
    }

    return empty;
  }

  // True if one of the team refs is null
  bool hasSpace() {
    bool space = false;
    for (int i = 0; i < team.length && !space; ++i) {
      space = team[i] == null;
    }

    return space;
  }

  // The size of the Pokemon team (1 - 3)
  int getSize() {
    return getPokemonTeam().length;
  }

  // Switch to a different cup with the specified cupTitle
  void setCup(String cupTitle) {
    cup = globals.gamemaster.cups.firstWhere((cup) => cup.title == cupTitle);
    _saveToStorage();
  }

  // Change the size of the team
  // This is useful for custom cups such as any Silph Cup that uses 6 Pokemon
  void setTeamSize(int newSize) {
    team = List<Pokemon?>.generate(
      newSize,
      (index) => index < team.length ? team[index] : null,
    );
    _saveToStorage();
  }

  // Update the type effectiveness of this Pokemon team
  // Called whenever the team is changed
  void _updateEffectiveness() {
    effectiveness = TypeMaster.getNetEffectiveness(getPokemonTeam());
  }

  void readFromStorage(int teamIndex, LocalStorage storage) {
    _teamIndex = teamIndex;
    _storage = storage;

    final Map<String, dynamic>? teamJson = _storage.getItem('team_$_teamIndex');

    if (teamJson == null) {
      return;
    }

    // Set the cup from storage
    final cups = globals.gamemaster.cups;
    final cupTitle = (teamJson['cup'] ?? 'Great League') as String;
    cup = cups.firstWhere((c) => c.title == cupTitle);

    final int teamSize = (teamJson['teamSize'] ?? 3) as int;
    team = List.filled(teamSize, null);

    // Set the Pokemon team from storage
    final idMap = globals.gamemaster.pokemonIdMap;
    bool teamReadIn = false;

    for (int i = 0; i < team.length && !teamReadIn; ++i) {
      if (teamJson.containsKey('pokemon_$i')) {
        team[i] = Pokemon.readFromStorage(teamJson['pokemon_$i'], idMap);
      } else {
        teamReadIn = false;
      }
    }

    _updateEffectiveness();
  }

  void _saveToStorage() async {
    Map<String, dynamic> teamJson = {};
    teamJson['cup'] = cup.title;
    teamJson['teamSize'] = team.length;
    for (int i = 0; i < team.length; ++i) {
      if (team[i] != null) {
        teamJson['pokemon_$i'] = team[i]!.toJson();
      }
    }

    await _storage.setItem('team_$_teamIndex', teamJson);
  }
}
