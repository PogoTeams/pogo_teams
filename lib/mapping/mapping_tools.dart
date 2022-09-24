// Dart
import 'dart:io';

// Local
import '../tools/json_tools.dart';

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

void buildPvpokeReleasedList() async {
  List<dynamic>? pvpokePokemon =
      await JsonTools.loadJson('bin/json/pvpoke-pokemon');
  if (pvpokePokemon == null) return;
  List<dynamic> pvpokeReleasedPokemonIds = [];
  void checkReleased(pokemon) {
    dynamic released = pokemon['released'] ?? false;
    if (released.runtimeType == String && released == 'true' || released) {
      pvpokeReleasedPokemonIds.add(pokemon['speciesId']);
    }
  }

  pvpokePokemon.forEach(checkReleased);

  await JsonTools.writeJson(
      pvpokeReleasedPokemonIds, 'bin/json/pvpoke-released');
}
