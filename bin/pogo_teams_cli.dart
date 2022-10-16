// Dart
import 'dart:io';

// Local
import 'package:pogo_teams/mapping/niantic_snapshot.dart';
import 'package:pogo_teams/mapping/cloud_writes.dart';
import 'package:pogo_teams/mapping/mapping_tools.dart';
import 'package:pogo_teams/ranker/ranker_main.dart';

/*
-------------------------------------------------------------------- @PogoTeams
niantic-snapshot -> data/niantic-snapshot.json
Maps a Niantic data source (niantic.json) to a snapshot of all fields used by
Pogo Teams (snapshot.json).

snapshot-cloud-writes / rankings-cloudwrites -> data/cloud-writes.json
Maps the snapshot to the firestore commit operation's 'writes' field
(cloud-writes.json).

cloud-push
Commits all writes specified in cloud-writes.json to the firestore cloud db.

alternate-forms
Scans a Niantic data source (niantic.json) for all 'form' fields that are
not suffixed with '_NORMAL'.
-------------------------------------------------------------------------------
*/

void main(List<String> arguments) async {
  if (arguments.isEmpty) return;

  switch (arguments[0]) {
    case 'niantic-snapshot':
      mapNianticToSnapshot();
      break;
    case 'snapshot-cloud-writes':
      CloudWrites.mapSnapshotDiffToCloudWrites();
      break;
    case 'cups-cloud-writes':
      CloudWrites.mapCupsToCloudWrites();
      break;
    case 'rankings-cloud-writes':
      CloudWrites.mapRankingsToCloudWrites();
      break;
    case 'cloud-writes-all':
      CloudWrites.mapAllCloudWrites();
      break;
    case 'cloud-push':
      if (arguments.length > 1) {
        CloudWrites.cloudPush(arguments[1]);
      } else {
        stderr.writeln('cloud-push: no api key was specified');
      }
      break;
    case 'alternate-forms':
      buildAlternateFormsList();
      break;
    case 'pvpoke-released':
      buildPvpokeReleasedIdsList();
      break;
    case 'snapshot-released':
      buildSnapshotReleasedIdsList();
      break;
    case 'validate-snapshot':
      validateSnapshot();
      break;
    case 'generate-rankings':
      generatePokemonRankings();
      break;
    case 'test-generate-rankings':
      if (arguments.length > 3) {
        int cp = int.tryParse(arguments[3]) ?? 1500;
        generatePokemonRankingsTest(
          arguments[1],
          arguments[2],
          cp,
        );
      }
      break;
  }
}
