// Dart
import 'dart:convert';

// Packages
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';

// Local
import 'globals.dart';
import '../enums/rankings_categories.dart';
import '../utils/pair.dart';
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
All Isar database interaction is managed by this module.
-------------------------------------------------------------------------------
*/

class PogoRepository {
  static Map<String, FastMove> fastMoves = {};
  static Map<String, ChargeMove> chargeMoves = {};
  static Map<String, Cup> cups = {};
  static Map<String, PokemonBase> basePokemon = {};
  static Map<int, UserPokemonTeam> userPokemonTeams = {};
  static Map<int, OpponentPokemonTeam> opponentPokemonTeams = {};
  static Map<String, Tag> tags = {};

  static Map<String, dynamic>? _rankingsJsonLookup;

  static late Box _userPokemonTeamsBox;
  static late Box _opponentPokemonTeamsBox;
  static late Box _tagsBox;

  static Future<void> init() async {
    _userPokemonTeamsBox = await Hive.openBox('userPokemonTeams');
    _opponentPokemonTeamsBox = await Hive.openBox('opponentPokemonTeams');
    _tagsBox = await Hive.openBox('tags');
    //await clearUserData();
  }

  static Future<void> clear() async {
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
  // Pogo Data Source Synchronization
  // --------------------------------------------------------------------------

  static Stream<Pair<String, double>> loadPogoData(
      {bool forceUpdate = false}) async* {
    String loadMessagePrefix = ''; // For indicating testing

    String pathPrefix = '/';

    // TRUE FOR TESTING ONLY
    if (Globals.testing) {
      pathPrefix += 'test/';
      loadMessagePrefix = '[ TEST ]  ';
    }

    Box localSettings = await Hive.openBox('pogoSettings');

    // Implicitly invoke an app update via HTTPS
    if (forceUpdate) {
      await localSettings.put('timestamp', Globals.earliestTimestamp);
    }

    String message = loadMessagePrefix; // Message above progress bar

    final client = RetryClient(Client());

    try {
      // If an update is available
      // make an http request for the new data
      if (await _updateAvailable(localSettings, client, pathPrefix)) {
        message = '${loadMessagePrefix}Syncing Pogo Data...';

        // Retrieve gamemaster
        String response = await client.read(Uri.https(Globals.pogoBucketDomain,
            '${Globals.pogoDataSourcePath}${pathPrefix}pogo_data_source.json'));

        yield Pair(a: message, b: .5);
        // If request was successful, load in the new gamemaster,
        final Map<String, dynamic> pogoDataSourceJson =
            Map<String, dynamic>.from(jsonDecode(response));

        yield Pair(a: message, b: .6);
        message = '${loadMessagePrefix}Syncing Rankings...';

        await downloadRankings(
          client,
          pathPrefix,
          List<Map<String, dynamic>>.from(pogoDataSourceJson['cups']),
        );

        yield Pair(a: message, b: .7);

        message = '${loadMessagePrefix}Syncing Local Data...';
        await rebuildFromJson(pogoDataSourceJson);
        await loadUserData();

        yield Pair(a: message, b: .9);
      }
    }

    // If HTTP request or json decoding fails
    catch (error) {
      message = '${loadMessagePrefix}Update Failed...';
      await Future.delayed(
          const Duration(seconds: Globals.minLoadDisplaySeconds));
      yield Pair(a: message, b: .9);
    } finally {
      client.close();
      localSettings.close();
    }

    yield Pair(a: message, b: 1.0);
  }

  static Future<bool> _updateAvailable(
      Box localSettings, Client client, String pathPrefix) async {
    bool updateAvailable = false;

    // Retrieve local timestamp
    final String timestampString =
        localSettings.get('timestamp') ?? Globals.earliestTimestamp;
    DateTime localTimeStamp = DateTime.parse(timestampString);

    // Retrieve server timestamp
    String response = await client.read(Uri.https(Globals.pogoBucketDomain,
        '${Globals.pogoDataSourcePath}${pathPrefix}timestamp.txt'));

    // If request is successful, compare timestamps to determine update
    final latestTimestamp = DateTime.tryParse(response);

    if (latestTimestamp != null &&
        !localTimeStamp.isAtSameMomentAs(latestTimestamp)) {
      updateAvailable = true;
      localTimeStamp = latestTimestamp;
    }

    // Store the timestamp in the local db
    await localSettings.put('timestamp', localTimeStamp.toString());

    return updateAvailable;
  }

  static Future<void> downloadRankings(
    Client client,
    String pathPrefix,
    List<Map<String, dynamic>> cupsJsonList,
  ) async {
    _rankingsJsonLookup ??= {};
    for (Map<String, dynamic> cupEntry in cupsJsonList) {
      if (cupEntry.containsKey('cupId')) {
        String cupId = cupEntry['cupId'];
        try {
          String response = await client.read(Uri.https(
              Globals.pogoBucketDomain,
              '${Globals.pogoDataSourcePath}${pathPrefix}rankings/$cupId.json'));
          _rankingsJsonLookup![cupId] = jsonDecode(response);
        } catch (e) {
          // ignore: avoid_print
          print(e);
        }
      }
    }
  }

  // --------------------------------------------------------------------------
  // JSON Initialization
  // --------------------------------------------------------------------------

  static Future<void> rebuildFromJson(Map<String, dynamic> json) async {
    // Load Pogo data collections
    await loadFastMoves(json['fastMoves']);
    await loadChargeMoves(json['chargeMoves']);
    await loadPokemon(json['pokemon']);
    await loadCups(json['cups']);
  }

  static Future<void> loadFastMoves(List<dynamic> fastMovesJson) async {
    for (var json in List<Map<String, dynamic>>.from(fastMovesJson)) {
      fastMoves[json['moveId']] = FastMove.fromJson(json);
    }
  }

  static Future<void> loadChargeMoves(List<dynamic> chargeMovesJson) async {
    for (var json in List<Map<String, dynamic>>.from(chargeMovesJson)) {
      chargeMoves[json['moveId']] = ChargeMove.fromJson(json);
    }
  }

  static Future<void> loadPokemon(List<dynamic> pokemonJson) async {
    for (var pokemonEntry in List<Map<String, dynamic>>.from(pokemonJson)) {
      await _processPokemonEntry(pokemonEntry);
    }
  }

  static Future<void> _processPokemonEntry(
      Map<String, dynamic> pokemonEntry) async {
    // Standard Pokemon entries
    PokemonBase pokemon = PokemonBase.fromJson(pokemonEntry);
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
          PokemonBase.fromJson(pokemonEntry, shadowForm: true);

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

  static Future<void> loadCups(List<dynamic> cupsJson) async {
    if (_rankingsJsonLookup == null) return;

    for (var cupEntry in List<Map<String, dynamic>>.from(cupsJson)) {
      if (_rankingsJsonLookup!.containsKey(cupEntry['cupId'])) {
        cupEntry['rankings'] = _rankingsJsonLookup![cupEntry['cupId']];
        final Cup cup = Cup.fromJson(cupEntry);
        cups[cup.cupId] = cup;
      }
    }
  }

  // --------------------------------------------------------------------------
  // Import / Export
  // --------------------------------------------------------------------------

  static Future<Map<String, dynamic>> exportUserDataToJson() async {
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

  static Future<void> importUserDataFromJson(Map<String, dynamic> json) async {
    for (var tagEntry in json['tags']) {
      putTag(Tag.fromJson(jsonDecode(tagEntry)));
    }

    for (var teamEntry in json['teams']) {
      final team = UserPokemonTeam.fromJson(jsonDecode(teamEntry));

      for (var opponentEntry
          in List<Map<String, dynamic>>.from(teamEntry['opponents'])) {
        final opponent = OpponentPokemonTeam.fromJson(opponentEntry);

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

  static FastMove getFastMoveById(String moveId) {
    return fastMoves[moveId] ?? FastMove.none;
  }

  static ChargeMove getChargeMoveById(String moveId) {
    return chargeMoves[moveId] ?? ChargeMove.none;
  }

  static List<PokemonBase> getPokemon() {
    return basePokemon.values.toList();
  }

  static PokemonBase getPokemonById(String pokemonId) {
    return basePokemon[pokemonId] ?? PokemonBase.missingNo();
  }

  static List<Cup> getCups() {
    return cups.values.toList();
  }

  static Cup getCupById(String cupId) {
    return cups[cupId] ?? cups.values.first;
  }

  static Tag? getTagByName(String tagName) {
    return tags[tagName];
  }

  static List<Tag> getTags() {
    return tags.values.toList();
  }

  static bool tagNameExists(String tagName) {
    return tags.containsKey(tagName);
  }

  static void putTag(Tag tag) {
    tags[tag.name] = tag;
  }

  static void deleteTag(String tagName) async {
    tags.remove(tagName);
  }

  static List<PokemonBase> getCupFilteredPokemonList(Cup cup) {
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
  static List<CupPokemon> getCupPokemon(
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

  static Future loadUserData() async {
    for (var key in _tagsBox.keys) {
      final json =
          Map<String, dynamic>.from(jsonDecode(await _tagsBox.get(key)));
      final tag = Tag.fromJson(json);
      tags[tag.name] = tag;
    }

    for (var key in _userPokemonTeamsBox.keys) {
      final json = Map<String, dynamic>.from(
          jsonDecode(await _userPokemonTeamsBox.get(key)));
      final team = UserPokemonTeam.fromJson(json);
      userPokemonTeams[team.id] = team;
    }

    for (var key in _opponentPokemonTeamsBox.keys) {
      final json = Map<String, dynamic>.from(
          jsonDecode(await _opponentPokemonTeamsBox.get(key)));
      final team = OpponentPokemonTeam.fromJson(json);
      opponentPokemonTeams[team.id] = team;
    }
  }

  static UserPokemonTeam getUserTeam(int id) {
    return userPokemonTeams[id] ?? UserPokemonTeam();
  }

  static List<UserPokemonTeam> getUserTeams({Tag? tag}) {
    if (tag == null) return userPokemonTeams.values.toList();
    return userPokemonTeams.values
        .where((team) => team.tag?.name == tag.name)
        .toList();
  }

  static List<OpponentPokemonTeam> getOpponentTeams({Tag? tag}) {
    if (tag == null) return opponentPokemonTeams.values.toList();
    return opponentPokemonTeams.values
        .where((team) => team.tag?.name == tag.name)
        .toList();
  }

  static void putPokemonTeam(PokemonTeam team) {
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

  static void deleteUserPokemonTeam(UserPokemonTeam userTeam) {
    for (OpponentPokemonTeam opponentTeam in userTeam.opponents) {
      deleteOpponentPokemonTeam(opponentTeam.id);
    }

    userPokemonTeams.remove(userTeam.id);
    _userPokemonTeamsBox.delete(userTeam.id);
  }

  static void deleteOpponentPokemonTeam(int id) {
    opponentPokemonTeams.remove(id);
    _opponentPokemonTeamsBox.delete(id);
  }

  static Future<void> clearUserData() async {
    _tagsBox.clear();
    _userPokemonTeamsBox.clear();
    _opponentPokemonTeamsBox.clear();
  }
}
