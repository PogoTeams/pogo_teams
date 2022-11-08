// Local Imports
import 'package:pogo_teams/game_objects/opponent_teams.dart';

import 'pokemon.dart';
import 'cup.dart';
import '../modules/data/pokemon_types.dart';
import '../modules/data/gamemaster.dart';
import '../modules/data/globals.dart';
import '../enums/battle_outcome.dart';

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
  PokemonTeam();

  String? id;
  int sortOrder = 0;

  // If true, the team cannot be removed or changed
  bool locked = false;

  // The list of 3 pokemon references that make up the team
  List<Pokemon?> pokemonTeam = List.filled(3, null);

  // A list of this pokemon team's net effectiveness
  List<double> effectiveness = List.generate(
    Globals.typeCount,
    (index) => 0.0,
  );

  // The selected PVP cup for this team
  // Defaults to Great League
  Cup _cup = Gamemaster().cups.first;
  Cup get cup => _cup;
  set cup(Cup value) {
    _cup = value;

    // initialize IVs to recommendation whenever the team's cup is set
    for (Pokemon? pokemon in pokemonTeam) {
      if (pokemon != null) {
        pokemon.initializeStats(cup.cp);
      }
    }
  }

  // Switch to a different cup with the specified cupTitle
  void setCupById(String cupId) {
    cup = Gamemaster().cups.firstWhere((cup) => cup.cupId == cupId,
        orElse: () => Gamemaster().cups.first);
  }

  // Make a copy of the newTeam, keeping the size of the original team
  void setPokemonTeam(List<Pokemon?> newPokemonTeam) {
    pokemonTeam = List.generate(
        pokemonTeam.length,
        (index) =>
            index < newPokemonTeam.length ? newPokemonTeam[index] : null);

    _updateEffectiveness();
  }

  // Set the specified Pokemon in the team by the specified index
  void setPokemon(int index, Pokemon? pokemon) {
    if (pokemon == null) {
      pokemonTeam[index] = null;
    } else {
      pokemonTeam[index] = Pokemon.from(pokemon);
    }

    _updateEffectiveness();
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
  }

  // Build and return a json serializable list of the Pokemon Team
  List<Map<String, dynamic>> _pokemonTeamToJson() {
    List<Map<String, dynamic>> teamJson = List.empty(growable: true);

    for (int i = 0; i < pokemonTeam.length; ++i) {
      if (pokemonTeam[i] != null) {
        teamJson.add(pokemonTeam[i]!.toUserTeamJson(i));
      }
    }

    return teamJson;
  }
}

// A user's team
class UserPokemonTeam extends PokemonTeam {
  UserPokemonTeam();

  factory UserPokemonTeam.fromJson(Map<String, dynamic> json) {
    List<Pokemon?> pokemonTeam =
        List<Pokemon?>.filled(json['teamSize'] as int, null);

    for (Map<String, dynamic> pokemonEntry
        in List<Map<String, dynamic>>.from(json['pokemonTeam'])) {
      final pokemonIndex = pokemonEntry['pokemonIndex'] as int;
      pokemonTeam[pokemonIndex] = Pokemon.fromTeamJson(pokemonEntry);
    }

    return UserPokemonTeam()
      ..cup = Gamemaster().getCupById(json['cup'] as String)
      ..locked = json['locked'] as bool
      ..sortOrder = json['sortOrder'] as int
      ..winRate = json['winRate'] as double
      ..pokemonTeam = pokemonTeam;
  }

  Map<String, dynamic> toJson() {
    return {
      'cup': cup.cupId,
      'locked': locked,
      'sortOrder': sortOrder,
      'teamSize': pokemonTeam.length,
      'winRate': winRate,
      'pokemonTeam': _pokemonTeamToJson(),
    };
  }

  // Copy over the cup, and Pokemon team
  void fromBuilderCopy(UserPokemonTeam other) {
    cup = other.cup;
    winRate = other.winRate;
    setTeamSize(other.pokemonTeam.length);
    setPokemonTeam(other.pokemonTeam);
  }

  // Make a copy of other, but with no save to db callback
  // This is used in team editing, to allow for a confirm to save working copy
  static UserPokemonTeam builderCopy(UserPokemonTeam other) {
    return UserPokemonTeam()
      ..locked = other.locked
      ..cup = other.cup
      ..winRate = other.winRate
      ..setTeamSize(other.pokemonTeam.length)
      ..setPokemonTeam(other.pokemonTeam);
  }

  // A list of logged opponent teams on this team
  // The user can report wins, ties, and losses given this list
  List<OpponentPokemonTeam> logs = List.empty(growable: true);

  double winRate = 0.0;
  String get winRateString => winRate.toStringAsFixed(2);

  void setLogAt(int index, OpponentPokemonTeam newLog) {
    logs[index] = newLog;
  }

  void removeLogAt(int index) {
    logs.removeAt(index);
  }

  // Calculate the average win rate for this Pokemon Team
  // Return a string representation for display
  void updateWinRate(OpponentPokemonTeams logs) {
    winRate = 0.0;

    if (logs.length != 0) {
      for (OpponentPokemonTeam log in logs.teamsList) {
        if (log.isWin()) ++winRate;
      }

      winRate = 100 * winRate / logs.length;
    }
  }
}

// A logged opponent team
class OpponentPokemonTeam extends PokemonTeam {
  OpponentPokemonTeam() {
    locked = true;
  }

  factory OpponentPokemonTeam.fromJson(Map<String, dynamic> json) {
    int teamSize = json['teamSize'] as int;
    List<Pokemon?> pokemonTeam = List<Pokemon?>.filled(teamSize, null);

    for (Map<String, dynamic> pokemonEntry
        in List<Map<String, dynamic>>.from(json['pokemonTeam'])) {
      final pokemonIndex = pokemonEntry['pokemonIndex'] as int;
      pokemonTeam[pokemonIndex] = Pokemon.fromTeamJson(pokemonEntry);
    }

    return OpponentPokemonTeam()
      ..sortOrder = json['sortOrder'] as int
      ..userTeamId = json['userTeamId'] as String
      ..cup = Gamemaster().getCupById(json['cupId'] as String)
      ..battleOutcome = fromOutcomeName(json['battleOutcome'] as String)
      ..locked = json['locked'] as bool
      ..setPokemonTeam(pokemonTeam);
  }

  static BattleOutcome fromOutcomeName(String name) {
    switch (name) {
      case 'win':
        return BattleOutcome.win;
      case 'loss':
        return BattleOutcome.loss;
      case 'tie':
        return BattleOutcome.tie;
      default:
        return BattleOutcome.win;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'sortOrder': sortOrder,
      'userTeamId': userTeamId,
      'cupId': cup.cupId,
      'teamSize': pokemonTeam.length,
      'battleOutcome': battleOutcome.name,
      'locked': locked,
      'pokemonTeam': _pokemonTeamToJson()
    };
  }

  // Make a copy of other, but with no save to db callback
  // This is used in team editing, to allow for a confirm to save working copy
  static OpponentPokemonTeam builderCopy(OpponentPokemonTeam other) {
    return OpponentPokemonTeam()
      ..sortOrder = other.sortOrder
      ..userTeamId = other.userTeamId
      ..cup = other.cup
      ..battleOutcome = other.battleOutcome
      ..locked = other.locked
      ..setPokemonTeam(other.pokemonTeam);
  }

  // Copy over the winLossKey, and Pokemon team
  // Saves to db in PokemonTeam
  void fromBuilderCopy(OpponentPokemonTeam other) {
    sortOrder = other.sortOrder;
    userTeamId = other.userTeamId;
    cup = other.cup;
    battleOutcome = other.battleOutcome;
    setTeamSize(other.pokemonTeam.length);
    setPokemonTeam(other.pokemonTeam);
  }

  String userTeamId = '';

  // For logging opponent teams, this value can either be :
  // Win
  // Tie
  // Loss
  BattleOutcome battleOutcome = BattleOutcome.win;

  bool isWin() {
    return battleOutcome == BattleOutcome.win;
  }
}
