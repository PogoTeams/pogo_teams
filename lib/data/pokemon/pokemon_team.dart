// Local Imports
import 'pokemon.dart';
import '../cup.dart';
import '../masters/type_master.dart';
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
  // The list of 3 pokemon references that make up the team
  List<Pokemon?> pokemonTeam = List.filled(3, null);

  // If true, the team cannot be removed or changed
  bool locked = false;

  // A list of this pokemon team's net effectiveness
  List<double> effectiveness = List.generate(
    globals.typeCount,
    (index) => 0.0,
  );

  // Make a copy of the newTeam, keeping the size of the original team
  void setTeam(List<Pokemon?> newTeam) {
    pokemonTeam = List.generate(pokemonTeam.length,
        (index) => index < newTeam.length ? newTeam[index] : null);

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
    effectiveness = TypeMaster.getNetEffectiveness(getPokemonTeam());
  }

  // Clear and reset all team data
  void clear() {
    void _clearPokemon(pokemon) => pokemon = null;

    pokemonTeam.forEach(_clearPokemon);
  }

  // Toggle a lock on this team
  // When a team is locked, the team cannot be changed or removed
  void toggleLock() => locked = !locked;
}

// A user's team
class UserPokemonTeam extends PokemonTeam {
  // The selected PVP cup for this team
  // Defaults to Great League
  Cup cup = globals.gamemaster.cups[0];

  // A list of logged opponent teams on this team
  // The user can report wins, ties, and losses given this list
  List<LogPokemonTeam> logs = List.empty(growable: true);

  // Switch to a different cup with the specified cupTitle
  void setCup(String cupTitle) {
    cup = globals.gamemaster.cups.firstWhere((cup) => cup.title == cupTitle);
  }

  // Clear and reset all team data
  @override
  void clear() {
    super.clear();
    cup = globals.gamemaster.cups[0];
  }

  void addLog() {
    logs.add(LogPokemonTeam());
    logs.last.locked = true;
    logs.last.setTeamSize(pokemonTeam.length);
  }

  void removeLogAt(int index) {
    logs.removeAt(index);
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
}

// A logged opponent team
class LogPokemonTeam extends PokemonTeam {
  // For logging opponent teams, this value can either be :
  // Win
  // Tie
  // Loss
  String winLossKey = 'Win';

  bool isWin() {
    return winLossKey == 'Win';
  }
}
