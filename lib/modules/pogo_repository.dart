// Dart
import 'dart:convert';

// Packages
import 'package:hive/hive.dart';

// Local
import '../enums/rankings_categories.dart';
import '../model/pokemon_base.dart';
import '../model/pokemon.dart';
import '../model/pokemon_typing.dart';
import '../model/move.dart';
import '../model/cup.dart';
import '../model/tag.dart';
import '../model/pokemon_team.dart';
import 'cups.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All database interaction is managed by this module.
-------------------------------------------------------------------------------
*/

class PogoRepository {
  Map<String, FastMove> fastMoves = {};
  Map<String, ChargeMove> chargeMoves = {};
  Map<String, Cup> cups = {};
  Map<String, PokemonBase> basePokemon = {};
  Map<int, UserPokemonTeam> userPokemonTeams = {};
  Map<int, OpponentPokemonTeam> opponentPokemonTeams = {};
  Map<String, Tag> tags = {};

  late Box _userPokemonTeamsBox;
  late Box _opponentPokemonTeamsBox;
  late Box _tagsBox;

  Future<void> init() async {
    _userPokemonTeamsBox = await Hive.openBox('userPokemonTeams');
    _opponentPokemonTeamsBox = await Hive.openBox('opponentPokemonTeams');
    _tagsBox = await Hive.openBox('tags');
  }

  Future<void> clear() async {
    fastMoves.clear();
    chargeMoves.clear();
    cups.clear();
    basePokemon.clear();
    userPokemonTeams.clear();
    opponentPokemonTeams.clear();
    tags.clear();

    await Future.wait([
      _userPokemonTeamsBox.clear(),
      _opponentPokemonTeamsBox.clear(),
      _tagsBox.clear(),
    ]);
  }

  // --------------------------------------------------------------------------
  // JSON Initialization
  // --------------------------------------------------------------------------

  Future<void> buildDataSourceFromJson(
    Map<String, dynamic> pogoDataSourceJson,
    Map<String, dynamic> rankingsJson,
  ) async {
    // Load Pogo data collections
    await loadFastMoves(pogoDataSourceJson['fastMoves']);
    await loadChargeMoves(pogoDataSourceJson['chargeMoves']);
    await loadPokemon(pogoDataSourceJson['pokemon']);
    await loadCups(pogoDataSourceJson['cups'], rankingsJson);
  }

  Future<void> loadFastMoves(List<dynamic> fastMovesJson) async {
    for (var json in List<Map<String, dynamic>>.from(fastMovesJson)) {
      fastMoves[json['moveId']] = FastMove.fromJson(json);
    }
  }

  Future<void> loadChargeMoves(List<dynamic> chargeMovesJson) async {
    for (var json in List<Map<String, dynamic>>.from(chargeMovesJson)) {
      chargeMoves[json['moveId']] = ChargeMove.fromJson(json);
    }
  }

  Future<void> loadPokemon(List<dynamic> pokemonJson) async {
    for (var pokemonEntry in List<Map<String, dynamic>>.from(pokemonJson)) {
      await _processPokemonEntry(pokemonEntry);
    }
  }

  Future<void> _processPokemonEntry(Map<String, dynamic> pokemonEntry) async {
    // Standard Pokemon entries
    PokemonBase pokemon = PokemonBase.fromJson(pokemonEntry, this);
    List<Evolution>? evolutions;

    if (pokemonEntry.containsKey('evolutions')) {
      evolutions = List<Map<String, dynamic>>.from(pokemonEntry['evolutions'])
          .map<Evolution>((evolutionJson) => Evolution.fromJson(evolutionJson))
          .toList();

      pokemon.evolutions.addAll(evolutions);
    }

    if (pokemonEntry.containsKey('tempEvolutions')) {
      final evolutions =
          List<Map<String, dynamic>>.from(pokemonEntry['tempEvolutions'])
              .map<TempEvolution>(
                  (evolutionJson) => TempEvolution.fromJson(evolutionJson))
              .toList();

      pokemon.tempEvolutions.addAll(evolutions);
    }

    basePokemon[pokemon.pokemonId] = pokemon;

    // Shadow entries
    if (pokemonEntry.containsKey('shadow')) {
      PokemonBase shadowPokemon =
          PokemonBase.fromJson(pokemonEntry, this, shadowForm: true);

      if (evolutions != null) {
        shadowPokemon.evolutions.addAll(evolutions);
      }

      basePokemon[shadowPokemon.pokemonId] = shadowPokemon;
    }

    // Temporary evolution entries
    if (pokemonEntry.containsKey('tempEvolutions')) {
      for (var overrideJson
          in List<Map<String, dynamic>>.from(pokemonEntry['tempEvolutions'])) {
        PokemonBase tempEvoPokemon = PokemonBase.tempEvolutionFromJson(
          pokemonEntry,
          overrideJson,
        );

        tempEvoPokemon.fastMoves.addAll(pokemon.fastMoves);
        tempEvoPokemon.chargeMoves.addAll(pokemon.chargeMoves);

        basePokemon[tempEvoPokemon.pokemonId] = tempEvoPokemon;
      }
    }
  }

  Future<void> loadCups(
    List<dynamic> cupsJson,
    Map<String, dynamic> rankingsJson,
  ) async {
    for (var cupEntry in List<Map<String, dynamic>>.from(cupsJson)) {
      if (rankingsJson.containsKey(cupEntry['cupId'])) {
        cupEntry['rankings'] = rankingsJson[cupEntry['cupId']];
        final Cup cup = Cup.fromJson(cupEntry, this);
        cups[cup.cupId] = cup;
      }
    }
  }

  // --------------------------------------------------------------------------
  // Import / Export
  // --------------------------------------------------------------------------

  Future<Map<String, dynamic>> exportUserDataToJson() async {
    final Map<String, dynamic> userDataJson = {};
    final List<Map<String, dynamic>> teamsJson = [];
    final List<Map<String, dynamic>> tagsJson = [];

    for (var team in userPokemonTeams.values) {
      teamsJson.add(team.toJson());
    }

    for (var tag in tags.values) {
      tagsJson.add(tag.toJson());
    }

    userDataJson['teams'] = teamsJson;
    userDataJson['tags'] = tagsJson;
    return userDataJson;
  }

  Future<void> importUserDataFromJson(Map<String, dynamic> json) async {
    for (var tagEntry in json['tags']) {
      putTag(Tag.fromJson(jsonDecode(tagEntry)));
    }

    for (var teamEntry in json['teams']) {
      final team = UserPokemonTeam.fromJson(jsonDecode(teamEntry), this);

      for (var opponentEntry
          in List<Map<String, dynamic>>.from(teamEntry['opponents'])) {
        final opponent = OpponentPokemonTeam.fromJson(opponentEntry, this);

        if (opponentEntry.containsKey('tag')) {
          opponent.tag = tags[teamEntry['tag']];
        }

        team.opponents.add(opponent);
      }

      if (teamEntry.containsKey('tag')) {
        team.tag = tags[teamEntry['tag']];
      }
    }
  }

  // --------------------------------------------------------------------------
  // Data Access
  // --------------------------------------------------------------------------

  FastMove getFastMoveById(String moveId) {
    return fastMoves[moveId] ?? FastMove.none;
  }

  ChargeMove getChargeMoveById(String moveId) {
    return chargeMoves[moveId] ?? ChargeMove.none;
  }

  List<PokemonBase> getPokemon() {
    return basePokemon.values.toList();
  }

  PokemonBase getPokemonById(String pokemonId) {
    return basePokemon[pokemonId] ?? PokemonBase.missingNo();
  }

  List<Cup> getCups() {
    return cups.values.toList();
  }

  Cup getCupById(String cupId) {
    return cups[cupId] ?? cups.values.first;
  }

  Tag? getTagByName(String tagName) {
    return tags[tagName];
  }

  List<Tag> getTags() {
    return tags.values.toList();
  }

  bool tagNameExists(String tagName) {
    return tags.containsKey(tagName);
  }

  void putTag(Tag tag) {
    tags[tag.name] = tag;
  }

  void deleteTag(String tagName) async {
    tags.remove(tagName);
  }

  List<PokemonBase> getCupFilteredPokemonList(Cup cup) {
    List<PokemonBase> pokemon = getPokemon();

    return pokemon.where((pkmn) {
      return pkmn.released &&
          pkmn.fastMoves.isNotEmpty &&
          pkmn.chargeMoves.isNotEmpty &&
          cup.pokemonIsAllowed(pkmn) &&
          !Cups.isBanned(pkmn, cup.cp);
    }).toList();
  }

  // Get a list of Pokemon that contain one of the specified types
  // The rankings category
  // The list length will be up to the limit
  List<CupPokemon> getCupPokemon(
    Cup cup,
    List<PokemonType> types,
    RankingsCategories rankingsCategory, {
    int limit = 20,
  }) {
    List<CupPokemon> rankedList = cup.getCupPokemonList(rankingsCategory);

    // Filter the list to Pokemon that have one of the types in their typing
    // or their selected moveset
    rankedList = rankedList
        .where((pokemon) =>
            pokemon.getBase().hasType(types) ||
            pokemon.hasSelectedMovesetType(types))
        .toList();

    // There weren't enough Pokemon in this cup to satisfy the filtered limit
    if (rankedList.length < limit) {
      return rankedList;
    }

    return rankedList.getRange(0, limit).toList();
  }

  Future loadUserData() async {
    for (var key in _tagsBox.keys) {
      final json =
          Map<String, dynamic>.from(jsonDecode(await _tagsBox.get(key)));
      final tag = Tag.fromJson(json);
      tags[tag.name] = tag;
    }

    for (var key in _userPokemonTeamsBox.keys) {
      final json = Map<String, dynamic>.from(
          jsonDecode(await _userPokemonTeamsBox.get(key)));
      final team = UserPokemonTeam.fromJson(json, this);
      userPokemonTeams[team.id] = team;
    }

    for (var key in _opponentPokemonTeamsBox.keys) {
      final json = Map<String, dynamic>.from(
          jsonDecode(await _opponentPokemonTeamsBox.get(key)));
      final team = OpponentPokemonTeam.fromJson(json, this);
      opponentPokemonTeams[team.id] = team;
    }
  }

  UserPokemonTeam getUserTeam(int id) {
    return userPokemonTeams[id] ?? UserPokemonTeam(cup: getCups().first);
  }

  List<UserPokemonTeam> getUserTeams({Tag? tag}) {
    if (tag == null) return userPokemonTeams.values.toList();
    return userPokemonTeams.values
        .where((team) => team.tag?.name == tag.name)
        .toList();
  }

  List<OpponentPokemonTeam> getOpponentTeams({Tag? tag}) {
    if (tag == null) return opponentPokemonTeams.values.toList();
    return opponentPokemonTeams.values
        .where((team) => team.tag?.name == tag.name)
        .toList();
  }

  void putPokemonTeam(PokemonTeam team) {
    if (team.runtimeType == UserPokemonTeam) {
      if (team.id == -1) team.id = userPokemonTeams.length + 1;
      userPokemonTeams[team.id] = (team as UserPokemonTeam);
      _userPokemonTeamsBox.put(team.id, jsonEncode(team.toJson()));
    } else if (team.runtimeType == OpponentPokemonTeam) {
      if (team.id == -1) team.id = opponentPokemonTeams.length + 1;
      opponentPokemonTeams[team.id] = (team as OpponentPokemonTeam);
      _opponentPokemonTeamsBox.put(team.id, jsonEncode(team.toJson()));
    }
  }

  void deleteUserPokemonTeam(UserPokemonTeam userTeam) {
    for (OpponentPokemonTeam opponentTeam in userTeam.opponents) {
      deleteOpponentPokemonTeam(opponentTeam);
    }

    userPokemonTeams.remove(userTeam.id);
    _userPokemonTeamsBox.delete(userTeam.id);
  }

  void deleteOpponentPokemonTeam(OpponentPokemonTeam opponentPokemonTeam) {
    opponentPokemonTeams.remove(opponentPokemonTeam.id);
    _opponentPokemonTeamsBox.delete(opponentPokemonTeam.id);
  }

  Future<void> clearUserData() async {
    tags.clear();
    userPokemonTeams.clear();
    opponentPokemonTeams.clear();
  }
}
