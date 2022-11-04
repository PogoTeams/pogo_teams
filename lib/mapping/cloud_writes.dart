// Dart
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

// Local
import '../tools/json_tools.dart';

class CloudWrites {
  // firestore api
  static const String host = 'firestore.googleapis.com';
  static const String commitRequestPath =
      'v1/projects/pogo-teams-host/databases/(default)/documents:commit';
  static const String cloudDbName = 'pogo-teams-host';

  // max number of writes that can be passed to a commit operation
  // https://firebase.google.com/docs/firestore/quotas#writes_and_transactions
  static const int segmentSize = 500;

  static List<dynamic> cloudWrites = [];

  static Future<void> mapSnapshotDiffToCloudWrites(
      {bool writeJson = true}) async {
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

    if (snapshotFastMoves.isNotEmpty) {
      _addVersionTimestamp('pogo', 'fastMoves');
    }
    if (snapshotChargeMoves.isNotEmpty) {
      _addVersionTimestamp('pogo', 'chargeMoves');
    }
    if (snapshotPokemon.isNotEmpty) {
      _addVersionTimestamp('pogo', 'pokemon');
    }

    if (writeJson) _writeCloudWritesJson();
  }

  static Future<void> mapCupsToCloudWrites({bool writeJson = true}) async {
    List<dynamic>? cupsJsonList =
        await JsonTools.loadJson('bin/json/live_lists/cups');
    if (cupsJsonList == null) return;

    for (var cupEntry in cupsJsonList) {
      cloudWrites.add(<String, dynamic>{
        'update': {
          'name':
              'projects/pogo-teams-host/databases/(default)/documents/cups/${cupEntry['cupId']}',
          'fields': _mapFields(cupEntry)
        }
      });
    }

    _addVersionTimestamp('pogo', 'cups');

    if (writeJson) _writeCloudWritesJson();
  }

  static Future<void> mapRankingsToCloudWrites({bool writeJson = true}) async {
    List<dynamic>? cupsJsonList =
        await JsonTools.loadJson('bin/json/live_lists/cups');
    if (cupsJsonList == null) return;

    List<String> cupIds = cupsJsonList
        .map<String>((cupJson) => cupJson['cupId'] as String)
        .toList();

    for (String id in cupIds) {
      List<dynamic>? rankingsJson =
          await JsonTools.loadJson('bin/json/rankings/$id');
      if (rankingsJson != null) {
        for (var rankingsEntry in rankingsJson) {
          cloudWrites.add(<String, dynamic>{
            'update': {
              'name':
                  'projects/pogo-teams-host/databases/(default)/documents/cups/$id/rankings/${rankingsEntry['pokemonId']}',
              'fields': _mapFields(rankingsEntry),
            }
          });
        }

        _addVersionTimestamp('rankings', id);
      }
    }

    if (writeJson) _writeCloudWritesJson();
  }

  static void mapAllCloudWrites() async {
    await mapSnapshotDiffToCloudWrites(writeJson: false);
    await mapCupsToCloudWrites(writeJson: false);
    await mapRankingsToCloudWrites(writeJson: false);
    _writeCloudWritesJson();
  }

  static Map<String, dynamic> _mapFields(Map srcMap) {
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

  static List<dynamic> _mapFieldsFromList(List<dynamic> srcList) {
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

  static String _firestoreTypeKey(dynamic value) {
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

  static void _writeCloudWritesJson() async {
    final String timestampedFilename = 'cloud-writes ${JsonTools.timestamp()}';
    await JsonTools.writeJson(cloudWrites, 'bin/json/cloud-writes');

    stdout.writeln();
    stdout.writeln('-' * timestampedFilename.length);
    stdout.writeln(timestampedFilename);
    stdout.writeln('-' * timestampedFilename.length);
    stdout.writeln('cloud writes : ${cloudWrites.length}');
    stdout.writeln();
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

  static void cloudPush(String apiKey) async {
    List<dynamic>? results = await JsonTools.loadJson('bin/json/cloud-writes');
    if (results == null) return;

    cloudWrites = results;

    stdout.writeln(
        'you are about to write ${cloudWrites.length} documents to cloud db : $cloudDbName');
    stdout.write('enter "commit" to commit the transaction\n> ');
    if ('commit' == stdin.readLineSync()) {
      int startIndex = 0;
      int endIndex = 0;
      int segmentCount = 1;
      List<dynamic> segment;

      Uri url = Uri.https(host, commitRequestPath, <String, dynamic>{
        'key': apiKey,
        'auth': {'uid': 'sean'},
      });

      bool success = true;
      while (startIndex < cloudWrites.length - 1) {
        endIndex = min(startIndex + segmentSize, cloudWrites.length);
        segment = cloudWrites.getRange(startIndex, endIndex).toList();
        String requestBody = jsonEncode(<String, dynamic>{'writes': segment});
        http.Response response = await http.post(url, body: requestBody);

        stdout.writeln();
        stdout.writeln('cloud-push ${'-' * 20}');
        stdout.writeln('write count : ${segment.length}');
        stdout.writeln('write range : ($startIndex, ${endIndex - 1})');
        stdout.writeln('segment $segmentCount status : ${response.statusCode}');
        if (response.statusCode != 200) {
          success = false;
          stdout.writeln('cloud-error: ${response.body}');
        }
        stdout.writeln('-' * 31);
        stdout.writeln();

        startIndex += segmentSize;
        ++segmentCount;
      }

      if (success) {
        Map<String, dynamic>? snapshot =
            await JsonTools.loadJson('bin/json/niantic-snapshot');
        if (snapshot != null) {
          await JsonTools.writeJson(
              snapshot, 'bin/json/latest_snapshot/niantic-snapshot');
          stdout.writeln();
          stdout.writeln('cloud-push successful ${'-' * 9}');
          stdout.writeln('niantic-snapshot written to "latest" directory');
          stdout.writeln();
        }
      }
    } else {
      stdout.writeln('nothing was written to cloud db : $cloudDbName');
    }
  }

  static void _addVersionTimestamp(String documentName, String fieldName) {
    cloudWrites.add(<String, dynamic>{
      'updateMask': {
        'fieldPaths': [fieldName],
      },
      'update': {
        'name':
            'projects/pogo-teams-host/databases/(default)/documents/versionTimestamps/$documentName',
        'fields': {
          fieldName: {'stringValue': DateTime.now().toUtc().toString()}
        }
      }
    });
  }
}
