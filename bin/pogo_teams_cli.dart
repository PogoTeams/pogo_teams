// Local
import 'package:pogo_teams/mapping/niantic_snapshot.dart';
import 'package:pogo_teams/mapping/cloud_writes.dart';
import 'package:pogo_teams/cloud/cloud_push.dart';
import 'package:pogo_teams/rankers/rankers.dart';
import 'package:pogo_teams/mapping/mapping_tools.dart';

/*
-------------------------------------------------------------------- @PogoTeams
niantic-snapshot -> data/niantic-snapshot.json
Maps a Niantic data source (niantic.json) to a snapshot of all fields used by
Pogo Teams (snapshot.json).

cloud-writes -> data/cloud-writes.json
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
    case 'cloud-writes':
      mapSnapshotToCloudWrites();
      break;
    case 'cloud-push':
      cloudPush();
      break;
    case 'alternate-forms':
      buildAlternateFormsList();
      break;
    case 'pvpoke-released':
      buildPvpokeReleasedList();
      break;
    case 'validate-snapshot':
      validateSnapshot();
      break;
    case 'generate-rankings':
      generatePokemonRankings();
      break;
  }
}
