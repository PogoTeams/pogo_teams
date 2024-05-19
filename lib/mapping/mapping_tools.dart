// Dart
import 'dart:io';

// Local
import '../modules/pogo_repository.dart';
import '../utils/json_tools.dart';

/*
-------------------------------------------------------------------- @PogoTeams
JSON mapping and Pogo Teams data source management tools.
-------------------------------------------------------------------------------
*/

void buildAlternateFormsList() async {
  final List<dynamic>? nianticGamemaster =
      await JsonTools.loadJson('bin/json/niantic');
  if (nianticGamemaster == null) return;

  List<String> alternateForms = [];
  Map<String, dynamic> data;
  for (int i = 0; i < nianticGamemaster.length; ++i) {
    data = nianticGamemaster[i]['data'];
    if (data['pokemonSettings'] != null &&
        data['pokemonSettings']['form'] != null &&
        !data['pokemonSettings']['form'].toString().endsWith('_NORMAL')) {
      alternateForms.add(data['pokemonSettings']['form']);
    }
  }

  await JsonTools.writeJson(alternateForms, 'bin/json/alternate-forms');

  stdout.writeln();
  stdout.writeln('alternate-forms ${'-' * 20}');
  stdout.writeln('alternate forms found : ${alternateForms.length}');
  stdout.writeln('-' * 36);
  stdout.writeln();
}

void buildPvpokeReleasedIdsList() async {
  List<dynamic>? pvpokePokemon =
      await JsonTools.loadJson('bin/json/pvpoke-pokemon');
  if (pvpokePokemon == null) return;

  List<dynamic> pvpokeReleasedPokemonIds = [];

  for (var pokemon in pvpokePokemon) {
    dynamic released = pokemon['released'] ?? false;
    if (released.runtimeType == String && released == 'true' || released) {
      pvpokeReleasedPokemonIds.add(pokemon['speciesId']);
    }
  }

  await JsonTools.writeJson(
      pvpokeReleasedPokemonIds, 'bin/json/pvpoke-released');
}

void buildSnapshotReleasedIdsList() async {
  Map<String, dynamic>? snapshot =
      await JsonTools.loadJson('bin/json/niantic-snapshot');
  if (snapshot == null) return;

  final PogoRepository pogoRepository = PogoRepository();
  await pogoRepository.init();
  await pogoRepository.clear();
  await pogoRepository.buildDataSourceFromJson(snapshot, {});

  List<String> snapshotReleasedIds = [];

  for (var pokemon in pogoRepository.getPokemon()) {
    if (pokemon.released) {
      snapshotReleasedIds.add(pokemon.pokemonId);
    }
  }

  await JsonTools.writeJson(
      snapshotReleasedIds, 'bin/json/released-pokemon-ids');
}

Future<void> copyGeneratedBinFiles(String dirPath) async {
  // Pogo data source
  final File pogoDataSource = File('bin/json/niantic-snapshot.json');
  final File file = await pogoDataSource.copy('$dirPath/pogo_data_source.json');

  stdout.writeln();
  stdout.writeln('commit: ${file.uri}');
  int commitCount = 1;

  // Rankings
  final Directory rankingsDir = Directory('bin/json/rankings');
  for (var rankingsFile in rankingsDir.listSync().toList().whereType<File>()) {
    final File copy = await rankingsFile
        .copy('$dirPath/rankings/${rankingsFile.uri.pathSegments.last}');
    stdout.writeln('commit: ${copy.uri}');
    commitCount += 1;
  }

  // Timestamp
  final String commitTimestamp = JsonTools.timestamp(utc: true);
  final File timestampFile = File('$dirPath/timestamp.txt');
  await timestampFile.writeAsString(commitTimestamp);
  stdout.writeln('commit: ${timestampFile.uri}');
  commitCount += 1;

  stdout.writeln();
  stdout.writeln(
      'commit ${'-' * (12 + dirPath.length + commitCount.toString().length)}');
  stdout.writeln('$commitCount files written to: $dirPath');
  stdout.writeln('-' * (19 + dirPath.length + commitCount.toString().length));
  stdout.writeln(commitTimestamp);
  stdout.writeln();
}
