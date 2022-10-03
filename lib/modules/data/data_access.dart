// Package
import 'package:cloud_firestore/cloud_firestore.dart';

// Local
import 'gamemaster.dart';
import '../../pogo_data/pokemon.dart';
import '../../pogo_data/pokemon_typing.dart';
import '../../pogo_data/ratings.dart';
import '../../pogo_data/cup.dart';
import '../ui/pogo_colors.dart';

class DataAccess {
  static Future<void> loadGamemaster() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection('fastMoves').get().then((event) {
      Gamemaster.loadFastMoves(event.docs.map((doc) => doc.data()).toList());
    });

    await db.collection('chargeMoves').get().then((event) {
      Gamemaster.loadChargeMoves(event.docs.map((doc) => doc.data()).toList());
    });

    await db.collection('pokemon').get().then((event) {
      Gamemaster.loadPokemon(event.docs.map((doc) => doc.data()).toList());
    });

    await db.collection('cups').get().then((event) {
      final List<Map<String, dynamic>> cupsJson =
          event.docs.map((doc) => doc.data()).toList();
      Gamemaster.loadCups(cupsJson);

      for (var cupEntry in cupsJson) {
        PogoColors.addCupColor(cupEntry['cupId'], cupEntry['uiColor']);
      }
    });
  }

  static Future<List<RankedPokemon>> getRankedPokemonList(
    Cup cup,
    String rankingsCategory,
  ) async {
    List<RankedPokemon> rankedPokemon = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('cups/${cup.cupId}/rankings').get().then((event) {
      for (var doc in event.docs) {
        Map<String, dynamic> json = doc.data();
        String? pokemonId = json['pokemonId'];
        String fastMoveId = json['idealMoveset']['fastMove'] as String;
        List<String> chargeMoveIds =
            List<String>.from(json['idealMoveset']['chargeMoves']);

        if (pokemonId != null && Gamemaster.pokemonMap.containsKey(pokemonId)) {
          Pokemon pokemon = Gamemaster.pokemonMap[json['pokemonId']]!;
          rankedPokemon.add(RankedPokemon.fromPokemon(
            pokemon,
            pokemon.getIvs(cup.cp),
            Ratings.fromJson(json['ratings']),
            Gamemaster.fastMoves
                .firstWhere((move) => move.moveId == fastMoveId),
            Gamemaster.chargeMoves
                .where((move) => chargeMoveIds.contains(move.moveId))
                .toList(),
          ));
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
    int Function(RankedPokemon, RankedPokemon) sort;
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
