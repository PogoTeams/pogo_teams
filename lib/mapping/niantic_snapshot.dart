// Dart
import 'dart:io';

// Local
import 'snapshot_diff.dart';
import '../pogo_data/pokemon_stats.dart';
import '../modules/data/stats.dart';
import '../tools/json_tools.dart';

// pattern matching for mapping from Niantic's data source
final RegExp _fastMoveRegex = RegExp(r'COMBAT_.*MOVE_(.*)_FAST');
final RegExp _chargeMoveRegex = RegExp(r'COMBAT_.*MOVE_(.*)');
final RegExp _pokemonRegex = RegExp(r'^V\d{4}_POKEMON_(.*)');
final RegExp _typeRegex = RegExp(r'^POKEMON_TYPE_(.*)');
final RegExp _dexNumberRegex = RegExp(r'^V(\d*)_.*');
final RegExp _tempEvolutionPokemonIdRegex = RegExp(r'^TEMP_EVOLUTION_(.*)');
const List<String> _ignoredFormPhrases = [
  '_2019',
  '_2020',
  '_2021',
  '_2022',
  'raikou_s',
  'entei_s',
  'suicune_s',
  'pyroar_female'
];

List<String> _processedPokemonIds = [];
List<String> _processedPokemonForms = [];
List<String> _releasedPokemonIds = [];

List<dynamic> _fastMovesOutput = [];
List<dynamic> _chargeMovesOutput = [];
List<dynamic> _pokemonOutput = [];

void mapNianticToSnapshot() async {
  final List<dynamic>? nianticGamemaster =
      await JsonTools.loadJson('bin/json/niantic');
  if (nianticGamemaster == null) return;

  // load the list of currently released pokemon
  dynamic result =
      await JsonTools.loadJson('bin/json/live_lists/released-pokemon-ids');
  if (result == null) return;
  _releasedPokemonIds = List<String>.from(result);

  for (var entry in nianticGamemaster) {
    _processGamemasterEntry(entry);
  }

  final List<dynamic>? cups =
      await JsonTools.loadJson('bin/json/live_lists/cups');
  if (cups == null) return;

  // write json file to output folder
  Map<String, List<dynamic>> snapshot = {
    'cups': cups,
    'fastMoves': _fastMovesOutput,
    'chargeMoves': _chargeMovesOutput,
    'pokemon': _pokemonOutput,
  };

  final String timestampedFilename =
      'niantic-snapshot ${JsonTools.timestamp()}';
  await JsonTools.writeJson(snapshot, 'bin/json/niantic-snapshot');
  int diffCount = await generateNianticSnapshotDiff(snapshot);

  stdout.writeln();
  stdout.writeln('-' * timestampedFilename.length);
  stdout.writeln(timestampedFilename);
  stdout.writeln('-' * timestampedFilename.length);
  stdout.writeln('cups         : ${cups.length}');
  stdout.writeln('fast moves   : ${_fastMovesOutput.length}');
  stdout.writeln('charge moves : ${_chargeMovesOutput.length}');
  stdout.writeln('pokemon      : ${_pokemonOutput.length}');
  stdout.writeln('released     : ${_releasedPokemonIds.length}');
  stdout.writeln('diff count   : $diffCount');
  stdout.writeln();
}

void _processGamemasterEntry(dynamic entry) {
  if (entry.containsKey('templateId')) {
    String templateId = entry['templateId'] as String;

    // MOVES ------------------------------------------------------------------
    if (templateId.startsWith("COMBAT_") && templateId.contains('MOVE')) {
      Map<String, dynamic> moveSrc = entry['data']['combatMove'];

      // FAST MOVES -----------------------------------------------------------
      if (templateId.endsWith('_FAST')) {
        _mapFastMove(moveSrc, templateId);
      }

      // CHARGE MOVES ---------------------------------------------------------
      else {
        _mapChargeMove(moveSrc, templateId);
      }
    }

    // POKEMON ----------------------------------------------------------------
    else if (_pokemonRegex.hasMatch(templateId) &&
        !templateId.endsWith('_REVERSION')) {
      Map<String, dynamic> pokemonSrc = entry['data']['pokemonSettings'];
      _mapPokemon(pokemonSrc, templateId);
    }
  }
}

String _getName(String nameSrc) {
  List<String> split = nameSrc.split('_');

  for (int i = 0; i < split.length; ++i) {
    split[i] = split[i][0].toUpperCase() + split[i].substring(1);
  }

  return split.join(' ');
}

String _getType(String typeSrc) {
  return _typeRegex.firstMatch(typeSrc)?.group(1)?.toLowerCase() ?? '';
}

bool _isReleased(String pokemonId) {
  return _releasedPokemonIds.contains(pokemonId);
}

void validateSnapshot() async {
  final Map<String, dynamic>? snapshot =
      await JsonTools.loadJson('bin/json/niantic-snapshot');
  if (snapshot == null) return;

  List<dynamic> pokemon = snapshot['pokemon'];
  List<int> dexNumbers = [];
  for (var pkmn in pokemon) {
    if (!dexNumbers.contains(pkmn['dex'])) {
      dexNumbers.add(pkmn['dex']);
    }
  }
  for (int i = 0; i < dexNumbers.length; ++i) {
    if (i + 1 != dexNumbers[i]) {
      stderr.writeln(
          'validate-dex: dex number out of sequence -> ${dexNumbers[i]}');
    }
  }
}

void _mapFastMove(Map<String, dynamic> fastMoveSrc, String templateId) {
  String? moveId =
      _fastMoveRegex.firstMatch(templateId)?.group(1)?.toLowerCase();

  if (moveId == null) {
    throw Exception(
        'niantic-snapshot: failed to process "moveId" for fast move -> $templateId');
  }

  String name = _getName(moveId);
  String type = _getType(fastMoveSrc['type']);
  num power = fastMoveSrc['power'] ?? 0;
  num energyDelta = fastMoveSrc['energyDelta'] ?? 0;
  int duration = 1 + (fastMoveSrc['durationTurns'] ?? 0) as int;

  _fastMovesOutput.add(<String, dynamic>{
    'moveId': moveId,
    'name': name,
    'type': type,
    'power': power,
    'energyDelta': energyDelta,
    'duration': duration,
  });
}

void _mapChargeMove(Map<String, dynamic> chargeMoveSrc, String templateId) {
  String? moveId =
      _chargeMoveRegex.firstMatch(templateId)?.group(1)?.toLowerCase();

  if (moveId == null) {
    throw Exception(
        'niantic-snapshot: failed to process "moveId" for charge move -> $templateId');
  }

  Map<String, dynamic> chargeMoveEntry = {'moveId': moveId};
  String name = _getName(moveId);
  if (name.startsWith('Weather Ball')) {
    name = 'Weather Ball';
  }
  chargeMoveEntry['name'] = name;
  chargeMoveEntry['type'] = _getType(chargeMoveSrc['type']);
  chargeMoveEntry['power'] = chargeMoveSrc['power'] ?? 0;
  chargeMoveEntry['energyDelta'] = chargeMoveSrc['energyDelta'] ?? 0;
  Map<String, dynamic>? buffsJson = chargeMoveSrc['buffs'];
  Map<String, dynamic>? buffs;

  if (buffsJson != null) {
    if (!buffsJson.containsKey('buffActivationChance')) {
      throw Exception(
          'niantic-snapshot: failed to process "buffActivationChance" -> $templateId');
    }

    buffs = {};
    buffs['chance'] = buffsJson['buffActivationChance'] as num;
    if (buffsJson.containsKey('attackerAttackStatStageChange')) {
      buffs['selfAttack'] = buffsJson['attackerAttackStatStageChange'] as int;
    }
    if (buffsJson.containsKey('attackerDefenseStatStageChange')) {
      buffs['selfDefense'] = buffsJson['attackerDefenseStatStageChange'] as int;
    }
    if (buffsJson.containsKey('targetAttackStatStageChange')) {
      buffs['opponentAttack'] = buffsJson['targetAttackStatStageChange'] as int;
    }
    if (buffsJson.containsKey('targetDefenseStatStageChange')) {
      buffs['opponentDefense'] =
          buffsJson['targetDefenseStatStageChange'] as int;
    }
    if (buffs.isNotEmpty) {
      chargeMoveEntry['buffs'] = buffs;
    } else {
      throw Exception(
          'niantic-snapshot: failed to process "buffs" -> $templateId');
    }
  }

  _chargeMovesOutput.add(chargeMoveEntry);
}

void _mapPokemon(Map<String, dynamic> pokemonSrc, String templateId) {
  Map<String, dynamic> pokemonEntry = {};

  String? dexStr = _dexNumberRegex.firstMatch(templateId)?.group(1);

  if (dexStr == null) {
    throw Exception(
        'niantic-snapshot: failed to retrieve dex number from templateId -> $templateId');
  }

  int dex = int.parse(dexStr);
  pokemonEntry['dex'] = dex;
  pokemonEntry['pokemonId'] = (pokemonSrc['pokemonId'] as String).toLowerCase();
  pokemonEntry['name'] = _getName(pokemonEntry['pokemonId']);

  String form = pokemonSrc['form'] ?? '${pokemonEntry['pokemonId']}_normal';
  form = form.toLowerCase();

  // filter out any un-needed entries matching a set of phrases
  if (_processedPokemonForms.contains(form)) {
    return;
  } else if (pokemonEntry['pokemonId'] == 'pikachu' &&
      form != 'pikachu_normal') {
    return;
  } else if (pokemonEntry['pokemonId'] == 'furfrou' &&
      form != 'furfrou_natural') {
    return;
  } else {
    for (int i = 0; i < _ignoredFormPhrases.length; ++i) {
      if (form.contains(_ignoredFormPhrases[i])) {
        return;
      }
    }
  }

  // attempt to fallback to the pokemon's form as it's id
  if (_processedPokemonIds.contains(pokemonEntry['pokemonId'])) {
    if (!_processedPokemonIds.contains(form) && !form.contains('_normal')) {
      pokemonEntry['pokemonId'] = form;
    } else {
      stdout.writeln(
          'niantic-snapshot: unable to generate unique pokemonId -> $templateId');
      return;
    }
  }

  _processedPokemonForms.add(form);
  _processedPokemonIds.add(pokemonEntry['pokemonId']);

  pokemonEntry['typing'] = <String, String>{
    'typeA': _getType(pokemonSrc['type'])
  };
  if (pokemonSrc.containsKey('type2')) {
    pokemonEntry['typing']['typeB'] = _getType(pokemonSrc['type2']);
  }

  if (pokemonSrc.containsKey('stats') && !pokemonSrc['stats'].isEmpty) {
    pokemonEntry['stats'] = <String, int>{
      'atk': pokemonSrc['stats']['baseAttack'] as int,
      'def': pokemonSrc['stats']['baseDefense'] as int,
      'hp': pokemonSrc['stats']['baseStamina'] as int,
    };
  } else {
    stdout
        .writeln('niantic-snapshot: base stats are unavailable -> $templateId');
  }

  if (pokemonSrc.containsKey('quickMoves')) {
    pokemonEntry['fastMoves'] = List<String>.from(pokemonSrc['quickMoves'])
        .map((move) => move.replaceAll('_FAST', '').toLowerCase())
        .toList();
  }

  if (pokemonSrc.containsKey('cinematicMoves')) {
    pokemonEntry['chargeMoves'] =
        List<String>.from(pokemonSrc['cinematicMoves'])
            .map<String>((move) => move.toLowerCase())
            .toList();
  }

  if (pokemonSrc.containsKey('eliteQuickMove')) {
    pokemonEntry['eliteFastMoves'] =
        List<String>.from(pokemonSrc['eliteQuickMove'])
            .map((move) => move.replaceAll('_FAST', '').toLowerCase())
            .toList();
  }

  if (pokemonSrc.containsKey('eliteCinematicMove')) {
    pokemonEntry['eliteChargeMoves'] =
        List<String>.from(pokemonSrc['eliteCinematicMove'])
            .map<String>((move) => move.toLowerCase())
            .toList();
  }

  if (pokemonSrc.containsKey('thirdMove')) {
    Map<String, int> thirdMoveCost = {};
    if (pokemonSrc['thirdMove'].containsKey('stardustToUnlock')) {
      thirdMoveCost['stardust'] =
          pokemonSrc['thirdMove']['stardustToUnlock'] as int;
    }
    if (pokemonSrc['thirdMove'].containsKey('candyToUnlock')) {
      thirdMoveCost['candy'] = pokemonSrc['thirdMove']['candyToUnlock'] as int;
    }
    pokemonEntry['thirdMoveCost'] = thirdMoveCost;
  }

  if (pokemonSrc.containsKey('shadow')) {
    pokemonEntry['shadow'] = <String, dynamic>{
      'pokemonId': pokemonEntry['pokemonId'] + '_shadow',
      'purificationStardust':
          pokemonSrc['shadow']['purificationStardustNeeded'] as int,
      'purificationCandy':
          pokemonSrc['shadow']['purificationCandyNeeded'] as int,
      'purifiedChargeMove':
          (pokemonSrc['shadow']['purifiedChargeMove'] as String).toLowerCase(),
      'shadowChargeMove':
          (pokemonSrc['shadow']['shadowChargeMove'] as String).toLowerCase(),
    };
    pokemonEntry['shadow']['released'] =
        _isReleased(pokemonEntry['shadow']['pokemonId']);
  }

  pokemonEntry['form'] = form.toLowerCase();

  pokemonEntry['familyId'] = (pokemonSrc['familyId'] as String).toLowerCase();

  if (pokemonSrc.containsKey('evolutionBranch')) {
    List<dynamic> evoSrc = pokemonSrc['evolutionBranch'];
    List<dynamic> evolutions = evoSrc.map((evolution) {
      if (evolution.containsKey('evolution')) {
        Map<String, dynamic> evoEntry = {};
        evoEntry['pokemonId'] =
            (evolution['evolution'] as String).toLowerCase();
        evoEntry['candyCost'] = evolution['candyCost'] as int;
        if (evolution.containsKey('form')) {
          String evoForm = (evolution['form'] as String).toLowerCase();
          // normal formal evolution doesn't need specification
          if (!evoForm.contains('_normal')) {
            evoEntry['form'] = evoForm;
          }
        }
        if (evolution.containsKey('obPurificationEvolutionCandyCost')) {
          evoEntry['purifiedEvolutionCost'] =
              evolution['obPurificationEvolutionCandyCost'] as int;
        }
        return evoEntry;
      }
    }).toList();
    evolutions = evolutions.whereType<Map<String, dynamic>>().toList();
    if (evolutions.isNotEmpty) {
      pokemonEntry['evolutions'] = evolutions;
    }
  }

  if (pokemonSrc.containsKey('tempEvoOverrides')) {
    List<dynamic> evoOverrideSrc = pokemonSrc['tempEvoOverrides'];
    List<dynamic> tempEvolutions = evoOverrideSrc.map((override) {
      if (override.containsKey('tempEvoId')) {
        Map<String, dynamic> overrideEntry = {
          'pokemonId': pokemonEntry['pokemonId'] +
              '_' +
              _tempEvolutionPokemonIdRegex
                  .firstMatch(override['tempEvoId'])
                  ?.group(1)
                  ?.toLowerCase(),
          'tempEvolutionId': (override['tempEvoId'] as String).toLowerCase()
        };

        overrideEntry['typing'] = {
          'typeA': _getType(override['typeOverride1'])
        };
        if (override.containsKey('typeOverride2')) {
          overrideEntry['typing']['typeB'] =
              _getType(override['typeOverride2']);
        }

        overrideEntry['stats'] = <String, int>{
          'atk': override['stats']['baseAttack'] as int,
          'def': override['stats']['baseDefense'] as int,
          'hp': override['stats']['baseStamina'] as int,
        };

        overrideEntry['released'] = _isReleased(overrideEntry['pokemonId']);

        return overrideEntry;
      }
    }).toList();
    tempEvolutions = tempEvolutions.whereType<Map<String, dynamic>>().toList();
    if (tempEvolutions.isNotEmpty) {
      pokemonEntry['tempEvolutions'] = tempEvolutions;
    }
  }
  pokemonEntry['released'] = _isReleased(pokemonEntry['pokemonId']);

  if (pokemonEntry.containsKey('stats') &&
      pokemonEntry['stats'].containsKey('atk') &&
      pokemonEntry['stats'].containsKey('def') &&
      pokemonEntry['stats'].containsKey('hp')) {
    BaseStats stats = BaseStats.fromJson(pokemonEntry['stats']);
    pokemonEntry['littleCupIVs'] = Stats.generateIVSpreads(
      stats,
      500,
    ).first.toJson();
    pokemonEntry['greatLeagueIVs'] = Stats.generateIVSpreads(
      stats,
      1500,
    ).first.toJson();
    pokemonEntry['ultraLeagueIVs'] = Stats.generateIVSpreads(
      stats,
      2500,
    ).first.toJson();
  }

  _pokemonOutput.add(pokemonEntry);
}
