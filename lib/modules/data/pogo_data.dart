// Dart
import 'dart:convert';

// Package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

// Local
import 'gamemaster.dart';
import '../../enums/pokemon_filters.dart';
import '../../tools/pair.dart';
import '../../firebase_options.dart';
import '../../game_objects/pokemon.dart';
import '../../game_objects/pokemon_typing.dart';
import '../../game_objects/ratings.dart';
import '../../game_objects/cup.dart';
import '../ui/pogo_colors.dart';

enum CacheType { pogoData, rankings }

class PogoData {
  static late final Box localPogoData;
  static late final Box localRankings;
  static late final FirebaseFirestore cloudPogoData;

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Hive.initFlutter();

    localPogoData = await Hive.openBox('pogo');
    localRankings = await Hive.openBox('rankings');
    cloudPogoData = FirebaseFirestore.instance;
  }

  static Stream<Pair<String, double>> loadPogoData() async* {
    final Box localVersionTimestampsBox =
        await Hive.openBox('versionTimestamps');
    Map<String, Map<String, dynamic>> localVersionTimestamps = {};
    localVersionTimestamps['pogo'] = Map<String, dynamic>.from(
        localVersionTimestampsBox.get('pogo', defaultValue: {}));
    localVersionTimestamps['rankings'] = Map<String, dynamic>.from(
        localVersionTimestampsBox.get('rankings', defaultValue: {}));

    yield Pair(a: 'loading...', b: .1);

    QuerySnapshot<Map<String, dynamic>> event =
        await cloudPogoData.collection('versionTimestamps').get();

    double progress = 0;
    for (var doc in event.docs) {
      for (var timestampEntry in doc.data().entries) {
        DateTime? localTimestamp;
        if (localVersionTimestamps.containsKey(doc.id)) {
          localTimestamp = DateTime.tryParse(
              localVersionTimestamps[doc.id]![timestampEntry.key] ?? '');
        }

        DateTime cloudTimestamp = DateTime.parse(timestampEntry.value);

        if (!localPogoData.containsKey(timestampEntry.key) ||
            localTimestamp == null ||
            localTimestamp != cloudTimestamp) {
          localVersionTimestamps[doc.id]![timestampEntry.key] =
              timestampEntry.value.toString();
          switch (doc.id) {
            case 'pogo':
              _refreshCache(timestampEntry.key, CacheType.pogoData);
              break;
            case 'rankings':
              _refreshCache(timestampEntry.key, CacheType.rankings);
              break;
          }
        } else if (doc.id == 'pogo') {
          _loadGamemasterCollection(
            timestampEntry.key,
            List<Map<String, dynamic>>.from(jsonDecode(
                localPogoData.get(timestampEntry.key, defaultValue: ''))),
          );
        }

        progress += 1;
        yield Pair(a: 'loading...', b: progress / event.docs.length);
      }
    }

    for (var timestampEntry in localVersionTimestamps.entries) {
      await localVersionTimestampsBox.put(
        timestampEntry.key,
        timestampEntry.value,
      );
    }
    localVersionTimestampsBox.close();
  }

  static void _refreshCache(
    String collectionName,
    CacheType cache,
  ) async {
    switch (cache) {
      case CacheType.pogoData:
        await cloudPogoData
            .collection(collectionName)
            .get()
            .then((event) async {
          final List<Map<String, dynamic>> json =
              event.docs.map((doc) => doc.data()).toList();
          await localPogoData.put(collectionName, jsonEncode(json));
          _loadGamemasterCollection(collectionName, json);
        });
        break;
      case CacheType.rankings:
        await cloudPogoData
            .collection('cups')
            .doc(collectionName)
            .collection('rankings')
            .get()
            .then((event) async {
          final List<Map<String, dynamic>> json =
              event.docs.map((doc) => doc.data()).toList();
          await localRankings.put(collectionName, jsonEncode(json));
        });
        break;
    }
  }

  static void _loadGamemasterCollection(
      String collectionName, List<Map<String, dynamic>> json) {
    switch (collectionName) {
      case 'fastMoves':
        Gamemaster().loadFastMoves(json);
        break;
      case 'chargeMoves':
        Gamemaster().loadChargeMoves(json);
        break;
      case 'pokemon':
        Gamemaster().loadPokemon(json);
        break;
      case 'cups':
        Gamemaster().loadCups(json);
        for (var cupEntry in json) {
          PogoColors.addCupColor(cupEntry['cupId'], cupEntry['uiColor']);
        }
        break;
    }
  }

  static Future<List<RankedPokemon>> getRankedPokemonList(
    Cup cup,
    PokemonFilters rankingsCategory,
  ) async {
    List<RankedPokemon> rankedPokemon = [];
    for (var json in List<Map<String, dynamic>>.from(
        jsonDecode(await localRankings.get(cup.cupId)))) {
      String fastMoveId = json['idealMoveset']['fastMove'] as String;
      List<String> chargeMoveIds =
          List<String>.from(json['idealMoveset']['chargeMoves']);

      Pokemon pokemon = Gamemaster().pokemonMap[json['pokemonId']]!;
      rankedPokemon.add(
        RankedPokemon.fromPokemon(
          pokemon,
          pokemon.getIvs(cup.cp),
          Ratings.fromJson(json['ratings']),
          Gamemaster().getFastMoveById(fastMoveId),
          [
            Gamemaster().getChargeMoveById(chargeMoveIds.first),
            Gamemaster().getChargeMoveById(chargeMoveIds.last),
          ],
        ),
      );
    }

    sortRankedPokemonList(rankedPokemon, rankingsCategory);
    return rankedPokemon;
  }

  static void sortRankedPokemonList(
    List<RankedPokemon> list,
    PokemonFilters rankingsCategory,
  ) {
    switch (rankingsCategory) {
      case PokemonFilters.overall:
        for (var rankedPokemon in list) {
          rankedPokemon.currentRating = rankedPokemon.ratings.overall;
        }
        break;
      case PokemonFilters.leads:
        for (var rankedPokemon in list) {
          rankedPokemon.currentRating = rankedPokemon.ratings.lead;
        }
        break;
      case PokemonFilters.switches:
        for (var rankedPokemon in list) {
          rankedPokemon.currentRating = rankedPokemon.ratings.switchRating;
        }
        break;
      case PokemonFilters.closers:
        for (var rankedPokemon in list) {
          rankedPokemon.currentRating = rankedPokemon.ratings.closer;
        }
        break;
      default:
        break;
    }

    list.sort((pokemon1, pokemon2) =>
        (pokemon2.currentRating - pokemon1.currentRating).toInt());
  }

  // Get a list of Pokemon that contain one of the specified types
  // The rankings category
  // The list length will be up to the limit
  static Future<List<Pokemon>> getFilteredRankedPokemonList(
    Cup cup,
    List<PokemonType> types,
    PokemonFilters rankingsCategory, {
    int limit = 20,
  }) async {
    List<Pokemon> rankedList =
        await getRankedPokemonList(cup, rankingsCategory);

    // Filter the list to Pokemon that have one of the types in their typing
    // or their selected moveset
    rankedList = rankedList
        .where((pokemon) =>
            pokemon.hasType(types) || pokemon.hasSelectedMovesetType(types))
        .toList();

    // There weren't enough Pokemon in this cup to satisfy the filtered limit
    if (rankedList.length < limit) {
      return rankedList;
    }

    return rankedList.getRange(0, limit).toList();
  }
}
