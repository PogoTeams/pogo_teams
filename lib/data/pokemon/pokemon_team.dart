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
  PokemonTeam({
    required this.key,
    required this.index,
  }) {
    readFromStorage();
  }

  final String key;

  // A unique index identifier
  final int index;

  // Local storage to restore team states
  late final LocalStorage storage = LocalStorage('${key}_team_$index.json');

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
    if (added) {
      _updateEffectiveness();
      _saveToStorage();
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

  // Clear and reset all team data
  void clear() async {
    void _clearPokemon(pokemon) => pokemon = null;

    team.forEach(_clearPokemon);
    cup = globals.gamemaster.cups[0];
    await storage.clear();
  }

  // Read in team state from local storage
  void readFromStorage() async {
    await storage.ready;

    // Set the cup from storage
    final cupTitle = (storage.getItem('cup') ?? 'Great League') as String;
    setCup(cupTitle);

    final int teamSize = (storage.getItem('teamSize') ?? 3) as int;
    team = List.filled(teamSize, null);

    final idMap = globals.gamemaster.pokemonIdMap;

    // Read in the Pokemon Team from storage
    for (int i = 0; i < team.length; ++i) {
      final pokemonJson = storage.getItem('pokemon_$i');

      if (pokemonJson != null) {
        team[i] = Pokemon.readFromStorage(pokemonJson, idMap);
      }
    }

    _updateEffectiveness();
  }

  // Write out the team state to local storage
  void _saveToStorage() async {
    await storage.setItem('cup', cup.title);
    await storage.setItem('teamSize', team.length);

    for (int i = 0; i < team.length; ++i) {
      await storage.setItem(
          'pokemon_$i', (team[i] == null ? null : team[i]!.toJson()));
    }
  }
}
