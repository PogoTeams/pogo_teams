// Packages
import 'package:isar/isar.dart';

// Local Imports
import 'pokemon.dart';
import 'cup.dart';
import 'tag.dart';
import '../modules/data/pokemon_types.dart';
import '../modules/data/pogo_data.dart';
import '../enums/battle_outcome.dart';

part 'pokemon_team.g.dart';

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

  Id id = Isar.autoIncrement;
  DateTime? dateCreated;
  bool locked = false;
  int teamSize = 3;

  // The list of pokemon managed by this team
  final IsarLinks<UserPokemon> pokemonTeam = IsarLinks<UserPokemon>();

  final IsarLink<Tag> tag = IsarLink<Tag>();

  Tag? getTag() {
    if (tag.isAttached && tag.value == null || !tag.isLoaded) {
      tag.loadSync();
    }
    return tag.value;
  }

  void setTag(Tag newTag) {
    tag.value = newTag;
  }

  // A list of this pokemon team's net effectiveness
  List<double> getTeamTypeffectiveness() {
    return PokemonTypes.getNetEffectiveness(getOrderedPokemonList());
  }

  // The selected PVP cup for this team
  final IsarLink<Cup> cup = IsarLink<Cup>();

  IsarLinks<UserPokemon> getPokemonTeam() {
    if (pokemonTeam.isAttached && !pokemonTeam.isLoaded) {
      pokemonTeam.loadSync();
    }

    return pokemonTeam;
  }

  Future<IsarLinks<UserPokemon>> getPokemonTeamAsync() async {
    if (pokemonTeam.isAttached && !pokemonTeam.isLoaded) {
      await pokemonTeam.load();
    }

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
    if (cup.isAttached && (cup.value == null || !cup.isLoaded)) {
      cup.loadSync();
    }

    return cup.value ?? PogoData.getCupsSync().first;
  }

  Future<Cup> getCupAsync() async {
    if (cup.isAttached && (cup.value == null || !cup.isLoaded)) {
      await cup.load();
    }

    return cup.value ?? PogoData.getCupsSync().first;
  }

  Future<void> saveSync() async {
    await getPokemonTeam().save();
    if (cup.value != null) await cup.save();
  }

  // Switch to a different cup with the specified cupTitle
  void setCupById(String cupId) {
    cup.value = PogoData.getCupById(cupId);
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
  List<Map<String, dynamic>> _pokemonTeamToExportJson() {
    return getPokemonTeam().map((pokemon) => pokemon.toExportJson()).toList();
  }
}

// A user's team
@Collection(accessor: 'userPokemonTeams')
@Name('userPokemonTeam')
class UserPokemonTeam extends PokemonTeam {
  UserPokemonTeam();

  factory UserPokemonTeam.fromJson(Map<String, dynamic> json) {
    final userPokemonTeam = UserPokemonTeam()
      ..dateCreated = DateTime.tryParse(json['dateCreated'] ?? '')
      ..locked = json['locked'] as bool
      ..teamSize = json['teamSize'] as int
      ..cup.value = PogoData.getCupById(json['cup'] as String);

    return userPokemonTeam;
  }

  Map<String, dynamic> toExportJson() {
    final Map<String, dynamic> json = {
      'dateCreated': dateCreated.toString(),
      'locked': locked,
      'teamSize': teamSize,
      'cup': getCup().cupId,
      'pokemonTeam': _pokemonTeamToExportJson(),
      'opponents': _opponentsToJson(),
    };

    if (getTag() != null) {
      json['tag'] = tag.value!.name;
    }

    return json;
  }

  List<Map<String, dynamic>> _opponentsToJson() {
    return getOpponents().map((opponent) => opponent.toExportJson()).toList();
  }

  // A list of logged opponent teams on this team
  // The user can report wins, ties, and losses given this list
  final IsarLinks<OpponentPokemonTeam> opponents =
      IsarLinks<OpponentPokemonTeam>();

  IsarLinks<OpponentPokemonTeam> getOpponents() {
    if (opponents.isAttached && !opponents.isLoaded) {
      opponents.loadSync();
    }

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
@Collection(accessor: 'opponentPokemonTeams')
class OpponentPokemonTeam extends PokemonTeam {
  OpponentPokemonTeam() {
    locked = true;
  }

  factory OpponentPokemonTeam.fromJson(Map<String, dynamic> json) {
    final userPokemonTeam = OpponentPokemonTeam()
      ..dateCreated = DateTime.tryParse(json['dateCreated'] ?? '')
      ..locked = json['locked'] as bool
      ..teamSize = json['teamSize'] as int
      ..battleOutcome = _fromOutcomeName(json['battleOutcome'])
      ..cup.value = PogoData.getCupById(json['cup'] as String);

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

  Map<String, dynamic> toExportJson() {
    final json = {
      'dateCreated': dateCreated.toString(),
      'locked': locked,
      'teamSize': teamSize,
      'battleOutcome': battleOutcome.name,
      'cup': getCup().cupId,
      'pokemonTeam': _pokemonTeamToExportJson(),
    };

    if (getTag() != null) {
      json['tag'] = tag.value!.name;
    }

    return json;
  }

  // For logging opponent teams, this value can either be :
  // Win
  // Loss
  // Tie
  @Enumerated(EnumType.ordinal)
  BattleOutcome battleOutcome = BattleOutcome.win;

  bool isWin() {
    return battleOutcome == BattleOutcome.win;
  }
}
