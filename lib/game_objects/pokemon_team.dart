// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'pokemon.dart';
import 'cup.dart';
import '../modules/data/pokemon_types.dart';
import '../modules/data/gamemaster.dart';
import '../modules/data/globals.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The Pokemon Team data model contains a list of 3 nullable Pokemon references
and a Cup reference. This collection represents a single Pokemon PVP Team.
This Pokemon Team can then be used to compute various information throughout
the app.
-------------------------------------------------------------------------------
*/

// The data model for a Pokemon PVP Team
// Every team page manages one instance of this class
class PokemonTeam {
  PokemonTeam({required this.save});

  VoidCallback save;

  // The list of 3 pokemon references that make up the team
  List<Pokemon?> pokemonTeam = List.filled(3, null);

  // If true, the team cannot be removed or changed
  bool locked = false;

  // A list of this pokemon team's net effectiveness
  List<double> effectiveness = List.generate(
    Globals.typeCount,
    (index) => 0.0,
  );

  // Make a copy of the newTeam, keeping the size of the original team
  void setPokemonTeam(List<Pokemon?> newPokemonTeam) {
    pokemonTeam = List.generate(
        pokemonTeam.length,
        (index) =>
            index < newPokemonTeam.length ? newPokemonTeam[index] : null);

    _updateEffectiveness();

    save();
  }

  // Set the specified Pokemon in the team by the specified index
  void setPokemon(int index, Pokemon? pokemon) {
    if (pokemon == null) {
      pokemonTeam[index] = null;
    } else {
      pokemonTeam[index] = Pokemon.from(pokemon);
    }

    _updateEffectiveness();

    save();
  }

  // Get the list of non-null Pokemon
  List<Pokemon> getPokemonTeam() {
    return pokemonTeam.whereType<Pokemon>().toList();
  }

  // Get the Pokemon ref at the given index
  Pokemon getPokemon(int index) {
    return pokemonTeam[index] as Pokemon;
  }

  // Add newPokemon if there is free space in the team
  void addPokemon(Pokemon newPokemon) {
    bool added = false;

    for (int i = 0; i < pokemonTeam.length && !added; ++i) {
      if (pokemonTeam[i] == null) {
        pokemonTeam[i] = newPokemon;
        added = true;
      }
    }

    if (added) {
      _updateEffectiveness();
      save();
    }
  }

  // True if the Pokemon ref is null at the given index
  bool isNull(int index) {
    return pokemonTeam[index] == null;
  }

  // True if there are no Pokemon on the team
  bool isEmpty() {
    bool empty = true;
    for (int i = 0; i < pokemonTeam.length && empty; ++i) {
      empty = pokemonTeam[i] == null;
    }

    return empty;
  }

  // True if one of the team refs is null
  bool hasSpace() {
    bool space = false;
    for (int i = 0; i < pokemonTeam.length && !space; ++i) {
      space = pokemonTeam[i] == null;
    }

    return space;
  }

  // The size of the Pokemon team (1 - 3)
  int getSize() {
    return getPokemonTeam().length;
  }

  // Change the size of the pokemonTeam
  // This is useful for custom cups such as any Silph Cup that uses 6 Pokemon
  void setTeamSize(int newSize) {
    if (pokemonTeam.length == newSize) return;

    pokemonTeam = List<Pokemon?>.generate(
      newSize,
      (index) => index < pokemonTeam.length ? pokemonTeam[index] : null,
    );

    save();
  }

  // Update the type effectiveness of this Pokemon team
  // Called whenever the team is changed
  void _updateEffectiveness() {
    effectiveness = PokemonTypes.getNetEffectiveness(getPokemonTeam());
  }

  // Toggle a lock on this team
  // When a team is locked, the team cannot be changed or removed
  void toggleLock() {
    locked = !locked;

    save();
  }

  void _pokemonTeamFromJson(List<dynamic> teamJson) {
    setTeamSize(teamJson.length);

    /*
    for (int i = 0; i < teamJson.length; ++i) {
      pokemonTeam[i] = Pokemon.fromStateJson(
        teamJson[i]['pokemon_$i'],
        globals.gamemaster.pokemonIdMap,
      );
    }
    */

    _updateEffectiveness();
  }

  // Build and return a json serializable list of the Pokemon Team
  List<Map<String, dynamic>> _pokemonTeamToJson() {
    List<Map<String, dynamic>> teamJson = List.empty(growable: true);

    /*
    for (int i = 0; i < pokemonTeam.length; ++i) {
      if (pokemonTeam[i] == null) {
        teamJson.add({'pokemon_$i': null});
      } else {
        teamJson.add({'pokemon_$i': pokemonTeam[i]!.toStateJson()});
      }
    }
    */

    return teamJson;
  }
}

// A user's team
class UserPokemonTeam extends PokemonTeam {
  UserPokemonTeam({required save}) : super(save: save);

  // Make a copy of other, but with no save to db callback
  // This is used in team editing, to allow for a confirm to save working copy
  static UserPokemonTeam builderCopy(UserPokemonTeam other) {
    final copy = UserPokemonTeam(save: () => {});
    copy.locked = other.locked;
    copy.cup = other.cup;
    copy.logs = List.from(other.logs);
    copy.setTeamSize(other.pokemonTeam.length);
    copy.setPokemonTeam(other.pokemonTeam);

    return copy;
  }

  // Copy over the cup, and Pokemon team
  // Saves to db in PokemonTeam
  void fromBuilderCopy(UserPokemonTeam other) {
    cup = other.cup;
    setTeamSize(other.pokemonTeam.length);
    setPokemonTeam(other.pokemonTeam);
  }

  // The selected PVP cup for this team
  // Defaults to Great League
  Cup cup = Gamemaster.cups[0];

  // A list of logged opponent teams on this team
  // The user can report wins, ties, and losses given this list
  List<LogPokemonTeam> logs = List.empty(growable: true);

  // Switch to a different cup with the specified cupTitle
  void setCup(String cupId) {
    cup = Gamemaster.cups.firstWhere((cup) => cup.cupId == cupId,
        orElse: () => Gamemaster.cups.first);

    save();
  }

  void addLog() {
    logs.add(LogPokemonTeam(save: save));
    logs.last.locked = true;
    logs.last.setTeamSize(pokemonTeam.length);

    save();
  }

  void setLogAt(int index, LogPokemonTeam newLog) {
    logs[index] = newLog;

    save();
  }

  void removeLogAt(int index) {
    logs.removeAt(index);

    save();
  }

  // Calculate the average win rate for this Pokemon Team
  // Return a string representation for display
  String getWinRate() {
    if (logs.isEmpty) return '0.0';

    double winRate = 0.0;

    for (int i = 0; i < logs.length; ++i) {
      if (logs[i].isWin()) ++winRate;
    }

    winRate /= logs.length;

    return (winRate * 100.0).toStringAsFixed(2);
  }

  void fromJson(json) {
    _pokemonTeamFromJson(json['pokemonTeam']);
    locked = json['locked'];

    final cupTitle = json['cup'] ?? 'Great League';
    setCup(cupTitle);

    _logsFromJson(json['logs']);
  }

  void _logsFromJson(logsJson) {
    for (int i = 0; i < logsJson.length; ++i) {
      logs.add(LogPokemonTeam(save: save));
      logs.last.fromJson(logsJson[i]);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'pokemonTeam': _pokemonTeamToJson(),
      'locked': locked,
      'cup': cup.cupId,
      'logs': _logsToJson()
    };
  }

  // Build and return a json serializable list of the logged opponent teams
  List<Map<String, dynamic>> _logsToJson() {
    List<Map<String, dynamic>> logsJson = List.empty(growable: true);

    for (int i = 0; i < logs.length; ++i) {
      logsJson.add(logs[i].toJson());
    }

    return logsJson;
  }
}

// A logged opponent team
class LogPokemonTeam extends PokemonTeam {
  LogPokemonTeam({required save}) : super(save: save);

  // Make a copy of other, but with no save to db callback
  // This is used in team editing, to allow for a confirm to save working copy
  static LogPokemonTeam builderCopy(LogPokemonTeam other) {
    final copy = LogPokemonTeam(save: () => {});
    copy._winLossKey = other._winLossKey;
    copy.locked = other.locked;
    copy.setTeamSize(other.pokemonTeam.length);
    copy.setPokemonTeam(other.pokemonTeam);

    return copy;
  }

  // Copy over the winLossKey, and Pokemon team
  // Saves to db in PokemonTeam
  void fromBuilderCopy(LogPokemonTeam other) {
    _winLossKey = other._winLossKey;
    setTeamSize(other.pokemonTeam.length);
    setPokemonTeam(other.pokemonTeam);
  }

  // For logging opponent teams, this value can either be :
  // Win
  // Tie
  // Loss
  String _winLossKey = 'Win';
  String get winLossKey => _winLossKey;

  void setWinLossKey(String key) {
    _winLossKey = key;

    save();
  }

  bool isWin() {
    return _winLossKey == 'Win';
  }

  void fromJson(json) {
    _winLossKey = json['_winLossKey'] ?? 'Win';
    _pokemonTeamFromJson(json['pokemonTeam']);
    locked = json['locked'] ?? true;
  }

  Map<String, dynamic> toJson() {
    return {
      'winLossKey': _winLossKey,
      'pokemonTeam': _pokemonTeamToJson(),
      'locked': locked
    };
  }
}
