// Local Imports
import 'pokemon.dart';
import 'cup.dart';
import 'tag.dart';
import '../modules/pokemon_types.dart';
import '../modules/pogo_repository.dart';
import '../enums/battle_outcome.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A Pokemon team can be a User Pokemon Team or an Opponent Pokemon Team. These
abstractions manage the data that a user creates and modifies in the app.
-------------------------------------------------------------------------------
*/

// The data model for a Pokemon PVP Team
// Every team page manages one instance of this class
class PokemonTeam {
  PokemonTeam({required this.cup});

  int id = -1;

  DateTime? dateCreated;
  bool locked = false;
  int get teamSize => pokemonTeam.length;

  // The selected PVP cup for this team
  Cup cup;

  // The list of pokemon managed by this team
  List<UserPokemon?> pokemonTeam = List<UserPokemon?>.filled(3, null);

  Tag? tag;

  Tag? getTag() {
    return tag;
  }

  void setTag(Tag newTag) {
    tag = newTag;
  }

  // A list of this pokemon team's net effectiveness
  List<double> getTeamTypeffectiveness() {
    return PokemonTypes.getNetEffectiveness(getNonNullPokemonList());
  }

  List<UserPokemon> getNonNullPokemonList() {
    return pokemonTeam.whereType<UserPokemon>().toList();
  }

  Future<void> saveSync() async {
    //await pokemonTeam.save();
    //if (cup.value != null) await cup.save();
  }

  // Switch to a different cup with the specified cupTitle
  void setCup(Cup newCup) {
    cup = newCup;
    for (UserPokemon? pokemon in pokemonTeam) {
      if (pokemon != null) {
        pokemon.initializeStats(cup.cp);
      }
    }
  }

  UserPokemon? getPokemon(int index) {
    if (index < 0 || index > pokemonTeam.length) return null;
    return pokemonTeam[index];
  }

  void removePokemon(int index) {
    if (index < 0 || index > pokemonTeam.length) return;
    pokemonTeam[index] = null;
  }

  // Add newPokemon if there is free space in the team
  bool tryAddPokemon(UserPokemon newPokemon) {
    for (int i = 0; i < teamSize; ++i) {
      if (pokemonTeam[i] == null) {
        newPokemon.teamIndex = i;
        pokemonTeam[i] = newPokemon;
        return true;
      }
    }

    return false;
  }

  void setPokemonAt(int index, UserPokemon newPokemon) {
    if (index < 0 || index > teamSize) return;
    newPokemon.teamIndex = index;
    pokemonTeam[index] = newPokemon;
  }

  void setTeamSize(int newSize) {
    if (teamSize == newSize) return;

    List<UserPokemon?> newTeam = List.filled(newSize, null);
    for (int i = 0; i < newSize; ++i) {
      newTeam[i] = pokemonTeam[i];
    }

    pokemonTeam = newTeam;
  }

  // True if there are no Pokemon on the team
  bool isEmpty() => getNonNullPokemonList().isEmpty;

  // True if one of the team refs is null
  bool hasSpace() {
    return teamSize > getNonNullPokemonList().length;
  }

  // The size of the Pokemon team (1 - 3)
  int getSize() => getNonNullPokemonList().length;

  // Toggle a lock on this team
  // When a team is locked, the team cannot be changed or removed
  void toggleLock() {
    locked = !locked;
  }

  // Build and return a json serializable list of the Pokemon Team
  List<Map<String, dynamic>> _pokemonTeamToJson() {
    return pokemonTeam
        .whereType<UserPokemon>()
        .map((pokemon) => pokemon.toJson())
        .toList();
  }

  static List<UserPokemon> _pokemonTeamFromJson(
    List<Map<String, dynamic>> jsonArray,
    PogoRepository pogoRepository,
  ) {
    List<UserPokemon> pokemonTeam = [];

    for (var json in jsonArray) {
      final UserPokemon pokemon = UserPokemon.fromJson(json);
      pokemon.base = pogoRepository.getPokemonById(json['pokemonId'] as String);
      pokemonTeam.add(pokemon);
    }

    return pokemonTeam;
  }
}

// A user's team
class UserPokemonTeam extends PokemonTeam {
  UserPokemonTeam({required super.cup});

  factory UserPokemonTeam.fromJson(
    Map<String, dynamic> json,
    PogoRepository pogoRepository,
  ) {
    final userPokemonTeam =
        UserPokemonTeam(cup: pogoRepository.getCupById(json['cup'] as String))
          ..id = json['id'] as int
          ..dateCreated = DateTime.tryParse(json['dateCreated'] ?? '')
          ..locked = json['locked'] as bool
          ..setTeamSize(json['teamSize'] as int)
          ..pokemonTeam = PokemonTeam._pokemonTeamFromJson(
            List<Map<String, dynamic>>.from(json['pokemonTeam']),
            pogoRepository,
          );

    if (json.containsKey('tag')) {
      userPokemonTeam.tag = pogoRepository.getTagByName(json['tag']);
    }

    for (var opponentJson in json['opponents']) {
      userPokemonTeam.opponents.add(
        OpponentPokemonTeam.fromJson(opponentJson, pogoRepository),
      );
    }

    return userPokemonTeam;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'dateCreated': dateCreated.toString(),
      'locked': locked,
      'teamSize': teamSize,
      'cup': cup.cupId,
      'pokemonTeam': _pokemonTeamToJson(),
      'opponents': _opponentsToJson(),
    };

    if (getTag() != null) {
      json['tag'] = tag!.name;
    }

    return json;
  }

  List<Map<String, dynamic>> _opponentsToJson() {
    return getOpponents().map((opponent) => opponent.toJson()).toList();
  }

  // A list of logged opponent teams on this team
  // The user can report wins, ties, and losses given this list
  final List<OpponentPokemonTeam> opponents =
      List<OpponentPokemonTeam>.empty(growable: true);

  List<OpponentPokemonTeam> getOpponents() {
    return opponents;
  }

  // Calculate the average win rate for this Pokemon Team
  // Return a string representation for display
  String getWinRate() {
    double winRate = 0.0;

    if (getOpponents().isNotEmpty) {
      for (OpponentPokemonTeam log in getOpponents()) {
        if (log.isWin()) ++winRate;
      }

      winRate = 100 * winRate / getOpponents().length;
    }

    return winRate.toStringAsFixed(0);
  }
}

// A logged opponent team
class OpponentPokemonTeam extends PokemonTeam {
  OpponentPokemonTeam({required super.cup}) {
    locked = true;
  }

  factory OpponentPokemonTeam.fromJson(
    Map<String, dynamic> json,
    PogoRepository pogoRepository,
  ) {
    final userPokemonTeam = OpponentPokemonTeam(
        cup: pogoRepository.getCupById(json['cup'] as String))
      ..id = json['id'] as int
      ..dateCreated = DateTime.tryParse(json['dateCreated'] ?? '')
      ..locked = json['locked'] as bool
      ..setTeamSize(json['teamSize'] as int)
      ..battleOutcome = _fromOutcomeName(json['battleOutcome'])
      ..pokemonTeam = PokemonTeam._pokemonTeamFromJson(
        json['pokemonTeam'],
        pogoRepository,
      );

    return userPokemonTeam;
  }

  static BattleOutcome _fromOutcomeName(String name) {
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
    final json = {
      'id': id,
      'dateCreated': dateCreated.toString(),
      'locked': locked,
      'teamSize': teamSize,
      'battleOutcome': battleOutcome.name,
      'cup': cup.cupId,
      'pokemonTeam': _pokemonTeamToJson(),
    };

    if (getTag() != null) {
      json['tag'] = tag!.name;
    }

    return json;
  }

  // For logging opponent teams, this value can either be :
  // Win
  // Loss
  // Tie
  BattleOutcome battleOutcome = BattleOutcome.win;

  bool isWin() {
    return battleOutcome == BattleOutcome.win;
  }
}
