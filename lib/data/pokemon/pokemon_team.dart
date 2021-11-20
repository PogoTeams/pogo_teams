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
  // The list of 3 pokemon references that make up the team
  List<Pokemon?> team = List.filled(3, null, growable: true);

  // A list of this pokemon team's net effectiveness
  List<double> effectiveness = List.generate(
    globals.typeCount,
    (index) => 0.0,
  );

  // The selected PVP cup for this team
  // Defaults to Great League
  Cup cup = globals.gamemaster.cups[0];

  void setTeam(List<Pokemon?> newTeam) {
    team = newTeam;
  }

  // Set the specified Pokemon in the team by the specified index
  void setPokemon(int index, Pokemon? pokemon) {
    team[index] = pokemon;
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

    for (int i = 0; i < 3 && !added; ++i) {
      if (team[i] == null) {
        team[i] = newPokemon;
        added = true;
      }
    }
  }

  // True if the Pokemon ref is null at the given index
  bool isNull(int index) {
    return team[index] == null;
  }

  // True if there are no Pokemon on the team
  bool isEmpty() {
    return (team[0] == null && team[1] == null && team[2] == null);
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
      growable: true,
    );
  }

  // Update the type effectiveness of this Pokemon team
  // Called whenever the team is changed
  void _updateEffectiveness() {
    effectiveness = TypeMaster.getNetEffectiveness(getPokemonTeam());
  }
}
