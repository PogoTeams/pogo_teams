// Dart
import 'dart:io';

// Local
import '../tools/json_tools.dart';

List<dynamic> cloudWrites = [];

void mapSnapshotToCloudWrites() async {
  final Map<String, dynamic>? snapshot =
      await JsonTools.loadJson('bin/json/niantic-snapshot-diff');
  if (snapshot == null) return;

  List<dynamic> snapshotFastMoves = snapshot['fastMoves'];
  List<dynamic> snapshotChargeMoves = snapshot['chargeMoves'];
  List<dynamic> snapshotPokemon = snapshot['pokemon'];

  for (var fastMove in snapshotFastMoves) {
    cloudWrites.add(<String, dynamic>{
      'update': {
        'name':
            'projects/pogo-teams-host/databases/(default)/documents/fastMoves/${fastMove['moveId']}',
        'fields': _mapFields(fastMove)
      }
    });
  }

  for (var chargeMove in snapshotChargeMoves) {
    cloudWrites.add(<String, dynamic>{
      'update': {
        'name':
            'projects/pogo-teams-host/databases/(default)/documents/chargeMoves/${chargeMove['moveId']}',
        'fields': _mapFields(chargeMove)
      }
    });
  }

  for (var pokemon in snapshotPokemon) {
    cloudWrites.add(<String, dynamic>{
      'update': {
        'name':
            'projects/pogo-teams-host/databases/(default)/documents/pokemon/${pokemon['pokemonId']}',
        'fields': _mapFields(pokemon)
      }
    });
  }

  final String timestampedFilename = 'cloud-writes ${JsonTools.timestamp()}';
  await JsonTools.writeJson(cloudWrites, 'bin/json/cloud-writes',
      copyFilename: 'bin/json/history/$timestampedFilename');

  stdout.writeln();
  stdout.writeln('-' * timestampedFilename.length);
  stdout.writeln(timestampedFilename);
  stdout.writeln('-' * timestampedFilename.length);
  stdout.writeln('cloud writes : ${cloudWrites.length}');
  stdout.writeln();
}

Map<String, dynamic> _mapFields(Map srcMap) {
  Map<String, dynamic> fields = {};
  for (var entry in srcMap.entries) {
    if (entry.value is Map) {
      fields[entry.key] = {
        _firestoreTypeKey(entry.value): {'fields': _mapFields(entry.value)}
      };
    } else if (entry.value is List && entry.value.runtimeType != String) {
      fields[entry.key] = {
        _firestoreTypeKey(entry.value): {
          'values': _mapFieldsFromList(entry.value)
        }
      };
    } else {
      fields[entry.key] = {_firestoreTypeKey(entry.value): entry.value};
    }
  }
  return fields;
}

List<dynamic> _mapFieldsFromList(List<dynamic> srcList) {
  List<dynamic> values = [];
  for (var item in srcList) {
    if (item is Map) {
      values.add({
        _firestoreTypeKey(item): {'fields': _mapFields(item)}
      });
    } else if (item is List) {
      values.add({
        _firestoreTypeKey(item): {'values': _mapFieldsFromList(item)}
      });
    } else {
      values.add({_firestoreTypeKey(item): item});
    }
  }
  return values;
}

String _firestoreTypeKey(dynamic value) {
  switch (value.runtimeType) {
    case String:
      return 'stringValue';
    case int:
      return 'integerValue';
    case double:
      return 'doubleValue';
    case List:
      return 'arrayValue';
    case bool:
      return 'booleanValue';
    default:
      if (value is Map) {
        return 'mapValue';
      }
      throw Exception(
          'cloud-writes: runtime type not supported -> ${value.runtimeType}');
  }
}

/* Option to store pokemon moves as reference type in cloud db
bool _isPokemonMoveKey(String key) {
  return key == 'fastMoves' ||
      key == 'chargeMoves' ||
      key == 'eliteFastMoves' ||
      key == 'eliteChargeMoves';
}

List<Map<String, dynamic>>? _mapPokemonMoves(
    List<dynamic> moves, String collectionName) {
  return moves
      .map((move) => {
            'referenceValue':
                'projects/pogo-teams-host/databases/(default)/documents/$collectionName/$move'
          })
      .toList();
}
*/
