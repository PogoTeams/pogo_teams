// Dart
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

// Local
import '../tools/json_tools.dart';

// firestore api
const String host = 'firestore.googleapis.com';
const String commitRequestPath =
    'v1/projects/pogo-teams-host/databases/(default)/documents:commit';
const String cloudDbName = 'pogo-teams-host';

// max number of writes that can be passed to a commit operation
// https://firebase.google.com/docs/firestore/quotas#writes_and_transactions
const int segmentSize = 500;

void cloudPush(String apiKey) async {
  List<dynamic>? cloudWrites =
      await JsonTools.loadJson('bin/json/cloud-writes');
  if (cloudWrites == null) return;

  stdout.writeln(
      'you are about to write ${cloudWrites.length} documents to cloud db : $cloudDbName');
  stdout.write('enter "commit" to commit the transaction\n> ');
  if ('commit' == stdin.readLineSync()) {
    int startIndex = 0;
    int endIndex = 0;
    int segmentCount = 1;
    List<dynamic> segment;

    Uri url = Uri.https(
      host,
      commitRequestPath,
      {'key': apiKey},
    );

    bool success = true;
    while (startIndex < cloudWrites.length - 1) {
      endIndex = min(startIndex + segmentSize, cloudWrites.length - 1);
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
