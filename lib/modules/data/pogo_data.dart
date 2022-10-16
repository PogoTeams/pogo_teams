// Dart
import 'dart:convert';

// Package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

// Local
import 'gamemaster.dart';
import '../../firebase_options.dart';
import '../../game_objects/pokemon.dart';
import '../../game_objects/pokemon_typing.dart';
import '../../game_objects/ratings.dart';
import '../../game_objects/cup.dart';
import '../ui/pogo_colors.dart';

class PogoData {
  static late final Box localPogoData;
  static late final FirebaseFirestore cloudPogoData;
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Hive.initFlutter();

    localPogoData = await Hive.openBox('pogoData');
    cloudPogoData = FirebaseFirestore.instance;

    await loadPogoData();
  }

  static Future<void> loadPogoData() async {
    final Box localVersionTimestampsBox =
        await Hive.openBox('versionTimestamps');
    Map<String, Map<String, dynamic>> localVersionTimestamps = {};
    localVersionTimestamps['pogo'] = Map<String, dynamic>.from(
        localVersionTimestampsBox.get('pogo', defaultValue: {}));
    localVersionTimestamps['rankings'] = Map<String, dynamic>.from(
        localVersionTimestampsBox.get('rankings', defaultValue: {}));

    await cloudPogoData
        .collection('versionTimestamps')
        .get()
        .then((event) async {
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
            _refreshCache(timestampEntry.key);
          } else if (doc.id == 'pogo') {
            _loadGamemasterCollection(
              timestampEntry.key,
              List<Map<String, dynamic>>.from(jsonDecode(
                  localPogoData.get(timestampEntry.key, defaultValue: ''))),
            );
          }
        }
      }
    });

    for (var timestampEntry in localVersionTimestamps.entries) {
      await localVersionTimestampsBox.put(
        timestampEntry.key,
        timestampEntry.value,
      );
    }
    localVersionTimestampsBox.close();
  }

  static void _refreshCache(String collectionName) async {
    await cloudPogoData.collection(collectionName).get().then((event) async {
      final List<Map<String, dynamic>> json =
          event.docs.map((doc) => doc.data()).toList();
      await localPogoData.put(collectionName, jsonEncode(json));
      _loadGamemasterCollection(collectionName, json);
    });
  }

  static void _loadGamemasterCollection(
      String collectionName, List<Map<String, dynamic>> json) {
    switch (collectionName) {
      case 'fastMoves':
        Gamemaster.loadFastMoves(json);
        break;
      case 'chargeMoves':
        Gamemaster.loadChargeMoves(json);
        break;
      case 'pokemon':
        Gamemaster.loadPokemon(json);
        break;
      case 'cups':
        Gamemaster.loadCups(json);
        for (var cupEntry in json) {
          PogoColors.addCupColor(cupEntry['cupId'], cupEntry['uiColor']);
        }
        break;
    }
  }

  static Future<List<RankedPokemon>> getRankedPokemonList(
    Cup cup,
    String rankingsCategory,
  ) async {
    List<RankedPokemon> rankedPokemon = [];
    await cloudPogoData
        .collection('cups/${cup.cupId}/rankings')
        .get()
        .then((event) {
      List<Map<String, dynamic>> rankingsJson =
          event.docs.map((doc) => doc.data()).toList();
      localPogoData.put('cups/${cup.cupId}/rankings', rankingsJson);

      for (var json in rankingsJson) {
        String? pokemonId = json['pokemonId'];
        String fastMoveId = json['idealMoveset']['fastMove'] as String;
        List<String> chargeMoveIds =
            List<String>.from(json['idealMoveset']['chargeMoves']);

        if (pokemonId != null && Gamemaster.pokemonMap.containsKey(pokemonId)) {
          Pokemon pokemon = Gamemaster.pokemonMap[json['pokemonId']]!;
          rankedPokemon.add(
            RankedPokemon.fromPokemon(
              pokemon,
              pokemon.getIvs(cup.cp),
              Ratings.fromJson(json['ratings']),
              Gamemaster.getFastMoveById(fastMoveId),
              [
                Gamemaster.getChargeMoveById(chargeMoveIds.first),
                Gamemaster.getChargeMoveById(chargeMoveIds.last),
              ],
            ),
          );
        }
      }
    });

    sortRankedPokemonList(rankedPokemon, rankingsCategory);
    return rankedPokemon;
  }

  static void sortRankedPokemonList(
    List<RankedPokemon> list,
    String rankingsCategory,
  ) {
    switch (rankingsCategory) {
      case 'overall':
        for (var rankedPokemon in list) {
          rankedPokemon.currentRating = rankedPokemon.ratings.overall;
        }
        break;
      case 'lead':
        for (var rankedPokemon in list) {
          rankedPokemon.currentRating = rankedPokemon.ratings.lead;
        }
        break;
      case 'switch':
        for (var rankedPokemon in list) {
          rankedPokemon.currentRating = rankedPokemon.ratings.switchRating;
        }
        break;
      case 'closer':
        for (var rankedPokemon in list) {
          rankedPokemon.currentRating = rankedPokemon.ratings.closer;
        }
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
    String rankingsCategory, {
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
