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
  PokemonTeam();

  int id = -1;

  DateTime? dateCreated;
  bool locked = false;
  int teamSize = 3;

  // The list of pokemon managed by this team
  List<UserPokemon> pokemonTeam = List<UserPokemon>.empty(growable: true);

  Tag? tag;

  Tag? getTag() {
    return tag;
  }

  void setTag(Tag newTag) {
    tag = newTag;
  }

  // A list of this pokemon team's net effectiveness
  List<double> getTeamTypeffectiveness() {
    return PokemonTypes.getNetEffectiveness(getOrderedPokemonList());
  }

  // The selected PVP cup for this team
  Cup cup = PogoRepository.getCups().first;

  List<UserPokemon> getPokemonTeam() {
    return pokemonTeam;
  }

  Future<List<UserPokemon>> getPokemonTeamAsync() async {
    return pokemonTeam;
  }

  List<UserPokemon> getOrderedPokemonList() {
    List<UserPokemon> orderedPokemonList = getPokemonTeam().toList();
    orderedPokemonList
        .sort((p1, p2) => (p1.teamIndex ?? 0) - (p2.teamIndex ?? 0));

    return orderedPokemonList;
  }

  Future<List<UserPokemon>> getOrderedPokemonListAsync() async {
    List<UserPokemon> orderedPokemonList =
        (await getPokemonTeamAsync()).toList();
    orderedPokemonList
        .sort((p1, p2) => (p1.teamIndex ?? 0) - (p2.teamIndex ?? 0));

    return orderedPokemonList;
  }

  List<UserPokemon?> getOrderedPokemonListFilled() {
    List<UserPokemon?> orderedPokemonList = List.filled(teamSize, null);

    for (int i = 0; i < teamSize; ++i) {
      orderedPokemonList[i] = getPokemon(i);
    }

    return orderedPokemonList;
  }

  Cup getCup() {
    return cup;
  }

  Future<Cup> getCupAsync() async {
    return cup;
  }

  Future<void> saveSync() async {
    //await getPokemonTeam().save();
    //if (cup.value != null) await cup.save();
  }

  // Switch to a different cup with the specified cupTitle
  void setCupById(String cupId) {
    cup = PogoRepository.getCupById(cupId);
    for (UserPokemon pokemon in getPokemonTeam()) {
      pokemon.initializeStats(getCup().cp);
    }
  }

  UserPokemon? getPokemon(int index) {
    for (var pokemon in getPokemonTeam()) {
      if (pokemon.teamIndex == index) return pokemon;
    }
    return null;
  }

  void removePokemon(int index) {
    getPokemonTeam().removeWhere((p) => p.teamIndex == index);
  }

  // Add newPokemon if there is free space in the team
  bool tryAddPokemon(UserPokemon newPokemon) {
    final List<UserPokemon> pokemonList = getOrderedPokemonList();
    bool added = false;
    for (int i = 0; i < teamSize && !added; ++i) {
      if (pokemonList.indexWhere((pokemon) => pokemon.teamIndex == i) == -1) {
        newPokemon.teamIndex = i;
        pokemonTeam.add(newPokemon);
        added = true;
      }
    }

    return added;
  }

  void setPokemonAt(int index, UserPokemon newPokemon) {
    removePokemon(index);
    newPokemon.teamIndex = index;
    getPokemonTeam().add(newPokemon);
  }

  void setTeamSize(int newSize) {
    if (teamSize == newSize) return;

    getPokemonTeam().where((UserPokemon pokemon) =>
        pokemon.teamIndex == null || pokemon.teamIndex! >= newSize);
    teamSize = newSize;
  }

  // True if there are no Pokemon on the team
  bool isEmpty() => getPokemonTeam().isEmpty;

  // True if one of the team refs is null
  bool hasSpace() {
    return teamSize > getOrderedPokemonList().length;
  }

  // The size of the Pokemon team (1 - 3)
  int getSize() => getPokemonTeam().length;

  // Toggle a lock on this team
  // When a team is locked, the team cannot be changed or removed
  void toggleLock() {
    locked = !locked;
  }

  // Build and return a json serializable list of the Pokemon Team
  List<Map<String, dynamic>> _pokemonTeamToJson() {
    return getPokemonTeam().map((pokemon) => pokemon.toJson()).toList();
  }

  static List<UserPokemon> _pokemonTeamFromJson(
      List<Map<String, dynamic>> jsonArray) {
    List<UserPokemon> pokemonTeam = [];

    for (var json in jsonArray) {
      final UserPokemon pokemon = UserPokemon.fromJson(json);
      pokemon.base = PogoRepository.getPokemonById(json['pokemonId'] as String);
      pokemonTeam.add(pokemon);
    }

    return pokemonTeam;
  }
}

// A user's team
class UserPokemonTeam extends PokemonTeam {
  UserPokemonTeam();

  factory UserPokemonTeam.fromJson(Map<String, dynamic> json) {
    final userPokemonTeam = UserPokemonTeam()
      ..id = json['id'] as int
      ..dateCreated = DateTime.tryParse(json['dateCreated'] ?? '')
      ..locked = json['locked'] as bool
      ..teamSize = json['teamSize'] as int
      ..cup = PogoRepository.getCupById(json['cup'] as String)
      ..pokemonTeam = PokemonTeam._pokemonTeamFromJson(
          List<Map<String, dynamic>>.from(json['pokemonTeam']));

    if (json.containsKey('tag')) {
      userPokemonTeam.tag = PogoRepository.getTagByName(json['tag']);
    }

    for (var opponentJson in json['opponents']) {
      userPokemonTeam.opponents.add(
        OpponentPokemonTeam.fromJson(opponentJson),
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
      'cup': getCup().cupId,
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
  OpponentPokemonTeam() {
    locked = true;
  }

  factory OpponentPokemonTeam.fromJson(Map<String, dynamic> json) {
    final userPokemonTeam = OpponentPokemonTeam()
      ..id = json['id'] as int
      ..dateCreated = DateTime.tryParse(json['dateCreated'] ?? '')
      ..locked = json['locked'] as bool
      ..teamSize = json['teamSize'] as int
      ..battleOutcome = _fromOutcomeName(json['battleOutcome'])
      ..cup = PogoRepository.getCupById(json['cup'] as String)
      ..pokemonTeam = PokemonTeam._pokemonTeamFromJson(json['pokemonTeam']);

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
      'cup': getCup().cupId,
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
