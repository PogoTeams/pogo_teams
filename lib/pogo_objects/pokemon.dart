// Dart
import 'dart:math';

// Packages
import 'package:isar/isar.dart';

// Local
import 'pokemon_typing.dart';
import 'move.dart';
import 'ratings.dart';
import 'pokemon_stats.dart';
import '../modules/data/stats.dart';
import '../modules/data/pokemon_types.dart';
import '../modules/data/globals.dart';

part 'pokemon.g.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

@Collection(accessor: 'pokemon')
class Pokemon {
  Pokemon({
    required this.dex,
    required this.pokemonId,
    required this.name,
    required this.typing,
    required this.stats,
    this.eliteFastMoveIds,
    this.eliteChargeMoveIds,
    this.thirdMoveCost,
    this.shadow,
    required this.form,
    required this.familyId,
    required this.released,
    this.tags,
    this.littleCupIVs,
    this.greatLeagueIVs,
    this.ultraLeagueIVs,
  });

  factory Pokemon.fromJson(
    Map<String, dynamic> json, {
    bool shadowForm = false,
  }) {
    List<String>? tags;
    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);
    }

    if (shadowForm) {
      tags ??= [];
      tags.add('shadow');
    }

    return Pokemon(
      dex: json['dex'] as int,
      pokemonId: (shadowForm ? json['shadow']['pokemonId'] : json['pokemonId'])
          as String,
      name: json['name'] as String,
      typing: PokemonTyping.fromJson(json['typing']),
      stats: json.containsKey('stats')
          ? BaseStats.fromJson(json['stats'])
          : BaseStats(),
      eliteFastMoveIds: json.containsKey('eliteFastMoves')
          ? List<String>.from(json['eliteFastMoves'])
          : null,
      eliteChargeMoveIds: json.containsKey('eliteChargeMove')
          ? List<String>.from(json['eliteChargeMove'])
          : null,
      thirdMoveCost: json.containsKey('thirdMoveCost')
          ? ThirdMoveCost.fromJson(json['thirdMoveCost'])
          : null,
      shadow:
          json.containsKey('shadow') ? Shadow.fromJson(json['shadow']) : null,
      form: json['form'] as String,
      familyId: json['familyId'] as String,
      released:
          (shadowForm ? json['shadow']['released'] : json['released']) as bool,
      tags: tags,
      littleCupIVs: json.containsKey('littlecupsivs')
          ? IVs.fromJson(json['littlecupsivs'])
          : null,
      greatLeagueIVs: json.containsKey('greatLeagueIVs')
          ? IVs.fromJson(json['greatLeagueIVs'])
          : null,
      ultraLeagueIVs: json.containsKey('ultraLeagueIVs')
          ? IVs.fromJson(json['ultraLeagueIVs'])
          : null,
    );
  }

  factory Pokemon.tempEvolutionFromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> overridesJson,
  ) {
    List<String> tags = [];
    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);
    }

    String tempEvolutionId = overridesJson['tempEvolutionId'] as String;
    if (tempEvolutionId.contains('mega')) {
      tags.add('mega');
    }

    return Pokemon(
      dex: json['dex'] as int,
      pokemonId: overridesJson['pokemonId'] as String,
      name: json['name'] as String,
      typing: PokemonTyping.fromJson(overridesJson['typing']),
      stats: overridesJson.containsKey('stats')
          ? BaseStats.fromJson(overridesJson['stats'])
          : BaseStats.fromJson(json['stats']),
      eliteFastMoveIds: json.containsKey('eliteFastMoves')
          ? List<String>.from(json['eliteFastMoves'])
          : null,
      eliteChargeMoveIds: json.containsKey('eliteChargeMove')
          ? List<String>.from(json['eliteChargeMove'])
          : null,
      thirdMoveCost: json.containsKey('thirdMoveCost')
          ? ThirdMoveCost.fromJson(json['thirdMoveCost'])
          : null,
      shadow: null,
      form: json['form'] as String,
      familyId: json['familyId'] as String,
      released: overridesJson['released'] as bool,
      tags: tags,
      littleCupIVs: overridesJson.containsKey('littlecupsivs')
          ? IVs.fromJson(overridesJson['littlecupsivs'])
          : null,
      greatLeagueIVs: overridesJson.containsKey('greatLeagueIVs')
          ? IVs.fromJson(overridesJson['greatLeagueIVs'])
          : null,
      ultraLeagueIVs: overridesJson.containsKey('ultraLeagueIVs')
          ? IVs.fromJson(overridesJson['ultraLeagueIVs'])
          : null,
    );
  }

  factory Pokemon.missingNo() {
    return Pokemon(
      dex: 0,
      pokemonId: 'missingNo',
      name: 'MissingNo.',
      typing: PokemonTyping(),
      stats: BaseStats(),
      form: '',
      familyId: '',
      released: false,
    );
  }

  Id id = Isar.autoIncrement;

  final int dex;
  @Index(unique: true)
  final String pokemonId;
  final String name;
  final PokemonTyping typing;
  final BaseStats stats;
  IsarLinks<FastMove> fastMoves = IsarLinks<FastMove>();
  IsarLinks<ChargeMove> chargeMoves = IsarLinks<ChargeMove>();
  final List<String>? eliteFastMoveIds;
  final List<String>? eliteChargeMoveIds;
  final ThirdMoveCost? thirdMoveCost;
  final Shadow? shadow;
  final String form;
  final String familyId;
  final IsarLinks<Evolution> evolutions = IsarLinks<Evolution>();
  final IsarLinks<TempEvolution> tempEvolutions = IsarLinks<TempEvolution>();
  final bool released;
  final List<String>? tags;
  final IVs? littleCupIVs;
  final IVs? greatLeagueIVs;
  final IVs? ultraLeagueIVs;

  // Form a string that describes this Pokemon's typing
  String typeString() => typing.toString();

  double statsProduct() => (stats.atk * stats.def * stats.hp).toDouble();

  // Get the type effectiveness of this Pokemon, factoring in current moveset
  List<double> defenseEffectiveness() => typing.defenseEffectiveness();

  // Get a list of all fast move names
  List<String> fastMoveNames() =>
      fastMoves.map((FastMove move) => move.name).toList();

  // Get a list of all fast move ids
  List<String> fastMoveIds() =>
      fastMoves.map((FastMove move) => move.moveId).toList();

  // Get a list of all charge move names
  List<String> chargeMoveNames() =>
      chargeMoves.map<String>((ChargeMove move) => move.name).toList();

  // Get a list of all charge move ids
  List<String> chargeMoveIds() =>
      chargeMoves.map<String>((ChargeMove move) => move.moveId).toList();

  bool isShadow() => tags?.contains('shadow') ?? false;
  bool isMega() => tags?.contains('mega') ?? false;
  bool isMonoType() => typing.isMonoType();

  // If the move is an elite move, slap a * on there to make it special
  String getFormattedMoveName(Move move) {
    if (isEliteMove(move)) {
      return '${move.name}*';
    }
    return move.name;
  }

  bool isEliteMove(Move move) {
    if (move is FastMove) {
      return eliteFastMoveIds?.contains(move.moveId) ?? false;
    }
    return eliteChargeMoveIds?.contains(move.moveId) ?? false;
  }

  // True if one of the specified types exists in this Pokemon's typing
  bool hasType(List<PokemonType> types) {
    return typing.containsType(types);
  }

  IVs getIvs(int cpCap) {
    switch (cpCap) {
      case 500:
        return littleCupIVs!;
      case 1500:
        return greatLeagueIVs!;
      case 2500:
        return ultraLeagueIVs!;
      default:
        return IVs.max();
    }
  }
}

@embedded
class ThirdMoveCost {
  ThirdMoveCost({
    this.stardust = 0,
    this.candy = 0,
  });

  factory ThirdMoveCost.fromJson(Map<String, dynamic> json) {
    return ThirdMoveCost(
      stardust: json['stardust'] ?? 0,
      candy: json['candy'] as int,
    );
  }

  int stardust;
  int candy;
}

@embedded
class Shadow {
  Shadow({
    this.pokemonId,
    this.purificationStardust,
    this.purificationCandy,
    this.purifiedChargeMove,
    this.shadowChargeMove,
    this.released,
  });

  factory Shadow.fromJson(Map<String, dynamic> json) {
    return Shadow(
      pokemonId: json['pokemonId'] as String,
      purificationStardust: json['purificationStardust'] as int,
      purificationCandy: json['purificationCandy'] as int,
      purifiedChargeMove: json['purifiedChargeMove'] as String,
      shadowChargeMove: json['shadowChargeMove'] as String,
      released: json['released'] as bool,
    );
  }

  String? pokemonId;
  int? purificationStardust;
  int? purificationCandy;
  String? purifiedChargeMove;
  String? shadowChargeMove;
  bool? released;
}

@Collection(accessor: 'evolutions')
class Evolution {
  Evolution({
    this.pokemonId,
    this.candyCost,
    this.purifiedEvolutionCost,
  });

  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(
      pokemonId: json['pokemonId'] as String,
      candyCost: json['candyCost'] as int,
      purifiedEvolutionCost: json['purifiedEvolutionCost'] as int?,
    );
  }

  Id id = Isar.autoIncrement;

  String? pokemonId;
  int? candyCost;
  int? purifiedEvolutionCost;
}

@Collection(accessor: 'tempEvolutions')
class TempEvolution {
  TempEvolution({
    required this.tempEvolutionId,
    required this.typing,
    this.stats,
    required this.released,
  });

  factory TempEvolution.fromJson(Map<String, dynamic> json) {
    return TempEvolution(
      tempEvolutionId: json['tempEvolutionId'],
      typing: PokemonTyping.fromJson(json['typing']),
      stats: BaseStats.fromJson(json['stats']),
      released: json['released'] as bool,
    );
  }

  Id id = Isar.autoIncrement;

  String? tempEvolutionId;
  PokemonTyping typing;
  BaseStats? stats;
  bool released;
}

@Collection(accessor: 'rankedPokemon')
class RankedPokemon {
  RankedPokemon({
    required this.ratings,
  });

  Id id = Isar.autoIncrement;

  Ratings ratings;
  IsarLink<Pokemon> pokemon = IsarLink<Pokemon>();
  IsarLink<FastMove> selectedFastMove = IsarLink<FastMove>();
  IsarLinks<ChargeMove> selectedChargeMoves = IsarLinks<ChargeMove>();

  List<Move> moveset() =>
      [selectedFastMove.value ?? FastMove.none, ...selectedChargeMoves];

  // True if this Pokemon's selected moveset contains one of the types
  bool hasSelectedMovesetType(List<PokemonType> types) {
    for (PokemonType type in types) {
      if (type.isSameType(selectedFastMove.value!.type) ||
          type.isSameType(selectedChargeMoves.first.type) ||
          type.isSameType(selectedChargeMoves.last.type)) {
        return true;
      }
    }

    return false;
  }
}

// Pokemon instance for simulating battles
class BattlePokemon extends Pokemon {
  BattlePokemon({
    required int dex,
    required String pokemonId,
    required String name,
    required PokemonTyping typing,
    required BaseStats stats,
    List<String>? eliteFastMoveIds,
    List<String>? eliteChargeMoveIds,
    ThirdMoveCost? thirdMoveCost,
    Shadow? shadow,
    required String form,
    required String familyId,
    required bool released,
    List<String>? tags,
    IVs? littleCupIVs,
    IVs? greatLeagueIVs,
    IVs? ultraLeagueIVs,
    this.cp = 0,
    this.currentRating = 0,
    this.currentHp = 0,
    this.currentShields = 0,
    this.cooldown = 0,
    this.energy = 0,
    this.chargeTDO = 0,
    this.chargeEnergyDelta = 0,
    this.prioritizeMoveAlignment = false,
  }) : super(
          dex: dex,
          pokemonId: pokemonId,
          name: name,
          typing: typing,
          stats: stats,
          eliteFastMoveIds: eliteFastMoveIds,
          eliteChargeMoveIds: eliteChargeMoveIds,
          thirdMoveCost: thirdMoveCost,
          shadow: shadow,
          form: form,
          familyId: familyId,
          released: released,
          tags: tags,
          littleCupIVs: littleCupIVs,
          greatLeagueIVs: greatLeagueIVs,
          ultraLeagueIVs: ultraLeagueIVs,
        );

  factory BattlePokemon.fromPokemon(Pokemon other) {
    return BattlePokemon(
      dex: other.dex,
      pokemonId: other.pokemonId,
      name: other.name,
      typing: other.typing,
      stats: other.stats,
      eliteFastMoveIds: other.eliteFastMoveIds,
      eliteChargeMoveIds: other.eliteChargeMoveIds,
      thirdMoveCost: other.thirdMoveCost,
      shadow: other.shadow,
      form: other.form,
      familyId: other.familyId,
      released: other.released,
      tags: other.tags,
      littleCupIVs: other.littleCupIVs,
      greatLeagueIVs: other.greatLeagueIVs,
      ultraLeagueIVs: other.ultraLeagueIVs,
    )
      ..fastMovesList.addAll(other.fastMoves.map((move) => FastMove.from(move)))
      ..chargeMovesList
          .addAll(other.chargeMoves.map((move) => ChargeMove.from(move)));
  }

  factory BattlePokemon.from(
    BattlePokemon other, {
    ChargeMove? nextDecidedChargeMove,
    bool prioritizeMoveAlignment = false,
  }) {
    BattlePokemon copy = BattlePokemon(
      dex: other.dex,
      pokemonId: other.pokemonId,
      name: other.name,
      typing: other.typing,
      stats: other.stats,
      eliteFastMoveIds: other.eliteFastMoveIds,
      eliteChargeMoveIds: other.eliteChargeMoveIds,
      thirdMoveCost: other.thirdMoveCost,
      shadow: other.shadow,
      form: other.form,
      familyId: other.familyId,
      released: other.released,
      tags: other.tags,
      littleCupIVs: other.littleCupIVs,
      greatLeagueIVs: other.greatLeagueIVs,
      ultraLeagueIVs: other.ultraLeagueIVs,
      cp: other.cp,
      currentHp: other.currentHp,
      currentShields: other.currentShields,
      cooldown: other.cooldown,
      energy: other.energy,
      chargeTDO: other.chargeTDO,
      chargeEnergyDelta: other.chargeEnergyDelta,
      prioritizeMoveAlignment: prioritizeMoveAlignment,
    )
      ..selectedFastMove = other.selectedFastMove
      ..selectedChargeMoves = other.selectedChargeMoves
      ..maxHp = other.maxHp
      .._atkBuffStage = other._atkBuffStage
      .._defBuffStage = other._defBuffStage;

    if (nextDecidedChargeMove != null) {
      copy.nextDecidedChargeMove = nextDecidedChargeMove;
    }

    return copy;
  }

  late final num maxHp;
  int cp;
  double currentRating;
  num currentHp;
  int currentShields;
  IVs selectedIVs = IVs();
  int cooldown;
  num energy;
  num chargeTDO;
  num chargeEnergyDelta;
  bool prioritizeMoveAlignment;

  List<FastMove> fastMovesList = [];
  List<ChargeMove> chargeMovesList = [];

  FastMove selectedFastMove = FastMove.none;
  List<ChargeMove> selectedChargeMoves = List.filled(2, ChargeMove.none);
  ChargeMove nextDecidedChargeMove = ChargeMove.none;

  int _atkBuffStage = 4;
  int _defBuffStage = 4;

  // The damage output per energy spent in a battle
  double get chargeDPE =>
      (chargeEnergyDelta == 0 ? 0 : chargeTDO / chargeEnergyDelta)
          .abs()
          .toDouble();

  double get currentHpRatio => currentHp / maxHp;
  double get damageRecievedRatio => (maxHp - currentHp) / maxHp;

  // Attack buff
  num get atkBuff => Stats.getBuffMultiplier(_atkBuffStage);
  void updateAtkBuff(int buff) {
    _atkBuffStage += buff;
    if (buff > 0) {
      _atkBuffStage = min(8, _atkBuffStage);
    } else {
      _atkBuffStage = max(0, _atkBuffStage);
    }
  }

  // Defense buff
  num get defBuff => Stats.getBuffMultiplier(_defBuffStage);
  void updateDefBuff(int buff) {
    _defBuffStage += buff;
    if (buff > 0) {
      _defBuffStage = min(8, _defBuffStage);
    } else {
      _defBuffStage = max(0, _defBuffStage);
    }
  }

  bool get hasShield {
    return currentShields != 0;
  }

  List<Move> moveset() => [selectedFastMove, ...selectedChargeMoves];

  void useShield() {
    currentShields -= 1;
  }

  void applyFastMoveDamage(BattlePokemon opponent) {
    energy += selectedFastMove.energyDelta;
    opponent.recieveDamage(selectedFastMove.damage);
  }

  void applyChargeMoveDamage(BattlePokemon opponent) {
    energy += nextDecidedChargeMove.energyDelta;
    if (opponent.hasShield) {
      opponent.useShield();
    } else {
      chargeTDO += opponent.recieveDamage(nextDecidedChargeMove.damage);
      chargeEnergyDelta += nextDecidedChargeMove.energyDelta;
    }

    if (nextDecidedChargeMove.buffs != null) {
      applyChargeMoveBuff(nextDecidedChargeMove, opponent);
    }
  }

  void applyChargeMoveBuff(ChargeMove chargeMove, BattlePokemon opponent) {
    if (chargeMove.buffs!.selfAttack != null) {
      updateAtkBuff(chargeMove.buffs!.selfAttack!);
    }
    if (chargeMove.buffs!.selfDefense != null) {
      updateDefBuff(chargeMove.buffs!.selfDefense!);
    }
    if (chargeMove.buffs!.opponentAttack != null) {
      opponent.updateAtkBuff(chargeMove.buffs!.opponentAttack!);
    }
    if (chargeMove.buffs!.opponentDefense != null) {
      opponent.updateDefBuff(chargeMove.buffs!.opponentDefense!);
    }
  }

  num recieveDamage(num damage) {
    num prevHp = currentHp;
    currentHp = max(0, currentHp - damage);
    return prevHp - currentHp;
  }

  bool isKO(num damage) {
    return damage >= currentHp;
  }

  // Given a cp cap, give the Pokemon the ideal stats and moveset
  void initializeStats(int cpCap) {
    selectedIVs = getIvs(cpCap);

    // Calculate maxCp
    cp = Stats.calculateCP(stats, selectedIVs);

    // Calculate battle hp (stamina)
    maxHp = Stats.calculateMaxHp(stats, selectedIVs);
  }

  // Bring that bar back
  void resetHp() {
    currentHp = maxHp;
  }

  void resetCooldown({int modifier = 0}) {
    cooldown = selectedFastMove.duration + modifier;
  }

  void selectMoveset(BattlePokemon opponent) {
    if (fastMovesList.isEmpty || chargeMovesList.isEmpty) return;

    // Find the charge move with highest damage per energy
    chargeMovesList.sort((move1, move2) => (move1.dpe() > move2.dpe()
        ? -1
        : ((move2.dpe() > move1.dpe()) ? 1 : 0)));
    num highestDpe = chargeMovesList.first.dpe();

    _sortByRating(chargeMovesList);
    ChargeMove highestRated = chargeMovesList.first;

    // For moves that have a strictly better preference, sharply reduce usage
    num ratingsSum = highestRated.rating;

    for (var i = 1; i < chargeMovesList.length; i++) {
      for (var n = 0; n < i; n++) {
        if ((chargeMovesList[i].type == chargeMovesList[n].type) &&
            (chargeMovesList[i].energyDelta >=
                chargeMovesList[n].energyDelta) &&
            (chargeMovesList[i].dpe() / chargeMovesList[n].dpe() < 1.3)) {
          chargeMovesList[i].rating *= .5;
          break;
        }
      }

      ratingsSum += chargeMovesList[i].rating;
    }

    if (ratingsSum > 0) {
      for (var move in chargeMovesList) {
        move.calculateEffectiveDamage(this, opponent);

        // Normalize move rating
        move.rating = ((move.rating / ratingsSum) * 100).round().toDouble();
      }
    }

    _sortByRating(chargeMovesList);
    highestRated = chargeMovesList.first;

    ratingsSum = 0;
    num baseline = Move.calculateCycleDpt(FastMove.none, highestRated);

    for (var move in fastMovesList) {
      move.calculateEffectiveDamage(this, opponent);

      num cycleDpt = Move.calculateCycleDpt(move, highestRated);
      cycleDpt = max(cycleDpt - baseline, .1);

      move.rating =
          cycleDpt * pow(move.rating, max(highestDpe - 1, 1)).toDouble();
      ratingsSum += move.rating;
    }

    if (ratingsSum > 0) {
      // Normalize move rating
      for (var move in fastMovesList) {
        move.rating = ((move.rating / ratingsSum) * 100).round().toDouble();
      }
    }

    _sortByRating(fastMovesList);

    selectedFastMove = fastMovesList.first;
    selectedChargeMoves.first = chargeMovesList[0];
    if (chargeMovesList.length > 1) {
      selectedChargeMoves.last = chargeMovesList[1];
    }
  }

  void _sortByRating(List<Move> moves) {
    moves.sort((move1, move2) => (move1.rating > move2.rating
        ? -1
        : ((move2.rating > move1.rating) ? 1 : 0)));
  }

  // Go through the moveset typing, accumulate the best type effectiveness
  List<double> getOffenseCoverage() {
    List<double> offenseCoverage = [];
    final fast = selectedFastMove.type.offenseEffectiveness();
    final c1 = selectedChargeMoves[0].type.offenseEffectiveness();
    List<double> c2;

    if ((selectedChargeMoves.last.isNone())) {
      c2 = List.filled(Globals.typeCount, 0.0);
    } else {
      c2 = selectedChargeMoves[1].type.offenseEffectiveness();
    }

    for (int i = 0; i < Globals.typeCount; ++i) {
      offenseCoverage.add(_max(fast[i], c1[i], c2[i]));
    }

    return offenseCoverage;
  }

  // Get the max value among the 3 provided values
  double _max(double v1, double v2, double v3) {
    if (v1 > v2) {
      if (v1 > v3) return v1;
      return v3;
    }

    if (v2 > v3) return v2;
    return v3;
  }

  num get effectiveAttack {
    return atkBuff *
        (stats.atk + selectedIVs.atk) *
        Stats.getCpMultiplier(selectedIVs.level) *
        (isShadow() ? Stats.shadowAtkMultiplier : 1);
  }

  num get effectiveDefense {
    return defBuff *
        (stats.def + selectedIVs.def) *
        Stats.getCpMultiplier(selectedIVs.level) *
        (isShadow() ? Stats.shadowDefMultiplier : 1);
  }
}
