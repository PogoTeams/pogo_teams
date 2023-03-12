// Packages
import 'package:collection/collection.dart';

// Local
import '../tools/json_tools.dart';

/*
-------------------------------------------------------------------- @PogoTeams
An algorithm to determine the differences between two JSON mappings. This is
helpful for determining the new changes introduced by Niantic's latest
gamemaster JSON.
-------------------------------------------------------------------------------
*/

Future<int> generateNianticSnapshotDiff(
    Map<String, dynamic> newSnapshot) async {
  Map<String, dynamic>? oldSnapshot =
      await JsonTools.loadJson('bin/json/latest_snapshot/niantic-snapshot');
  if (oldSnapshot == null ||
      oldSnapshot['fastMoves'] == null ||
      oldSnapshot['chargeMoves'] == null ||
      oldSnapshot['pokemon'] == null) {
    await JsonTools.writeJson(newSnapshot, 'bin/json/niantic-snapshot-diff');
    return newSnapshot['fastMoves'].length +
        newSnapshot['chargeMoves'].length +
        newSnapshot['pokemon'].length;
  }

  List<dynamic> oldFastMoves = oldSnapshot['fastMoves'];
  List<dynamic> oldChargeMoves = oldSnapshot['chargeMoves'];
  List<dynamic> oldPokemon = oldSnapshot['pokemon'];

  List<dynamic> newFastMoves = newSnapshot['fastMoves'];
  List<dynamic> newChargeMoves = newSnapshot['chargeMoves'];
  List<dynamic> newPokemon = newSnapshot['pokemon'];

  List<Map<String, dynamic>> fastMovesDiff =
      _generateDiffs(oldFastMoves, newFastMoves, 'moveId');
  List<Map<String, dynamic>> chargeMovesDiff =
      _generateDiffs(oldChargeMoves, newChargeMoves, 'moveId');
  List<Map<String, dynamic>> pokemonDiff =
      _generateDiffs(oldPokemon, newPokemon, 'pokemonId');

  Map<String, dynamic> diff = {
    'fastMoves': fastMovesDiff,
    'chargeMoves': chargeMovesDiff,
    'pokemon': pokemonDiff
  };
  await JsonTools.writeJson(diff, 'bin/json/niantic-snapshot-diff');
  return diff['fastMoves'].length +
      diff['chargeMoves'].length +
      diff['pokemon'].length;
}

List<Map<String, dynamic>> _generateDiffs(
    List<dynamic> oldMaps, List<dynamic> newMaps, String key) {
  List<Map<String, dynamic>> diffs = [];
  const comparater = DeepCollectionEquality();

  for (var newMap in newMaps) {
    Map<dynamic, dynamic>? oldMap = oldMaps
        .firstWhere((map) => map[key] == newMap[key], orElse: () => null);

    if (oldMap == null) {
      diffs.add(newMap);
    } else if (!comparater.equals(oldMap, newMap)) {
      Map<String, dynamic> diffEntry = {key: newMap[key]};
      newMap = newMap as Map<String, dynamic>;
      for (var newEntry in newMap.entries) {
        if (oldMap[newEntry.key] != newEntry.value) {
          diffEntry[newEntry.key] = newEntry.value;
        }
      }
      diffs.add(diffEntry);
    }
  }
  return diffs;
}
