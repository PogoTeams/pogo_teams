// Flutter Imports
import 'package:flutter/foundation.dart';

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
  List<Pokemon?> team = List.filled(3, null);

  // A list of this pokemon team's net effectiveness
  List<double> effectiveness = List.generate(
    globals.typeCount,
    (index) => 0.0,
  );

  // The selected PVP cup for this team
  // Defaults to Great League
  Cup cup = globals.gamemaster.cups[0];

  // Make a copy of the newTeam, keeping the size of the original team
  void setTeam(List<Pokemon?> newTeam) {
    team = List.generate(
        team.length, (index) => index < newTeam.length ? newTeam[index] : null);

    _updateEffectiveness();
  }

  // Set the specified Pokemon in the team by the specified index
  void setPokemon(int index, Pokemon? pokemon) {
    if (pokemon == null) {
      team[index] = null;
    } else {
      team[index] = Pokemon.from(pokemon);
    }
    _updateEffectiveness();
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
    if (added) {
      _updateEffectiveness();
    }
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
  }

  // Change the size of the team
  // This is useful for custom cups such as any Silph Cup that uses 6 Pokemon
  void setTeamSize(int newSize) {
    team = List<Pokemon?>.generate(
      newSize,
      (index) => index < team.length ? team[index] : null,
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

    team.forEach(_clearPokemon);
    cup = globals.gamemaster.cups[0];
  }
}

class PokemonTeams with ChangeNotifier {
  List<PokemonTeam> pokemonTeams = List.empty(growable: true);

  // Manual notify
  void notify() => notifyListeners();

  // Add a new empty team
  void addTeam() {
    pokemonTeams.add(PokemonTeam());
    notifyListeners();
  }

  // Remove a team at the specified index
  void removeTeamAt(int index) {
    pokemonTeams.removeAt(index);
    notifyListeners();
  }
}
