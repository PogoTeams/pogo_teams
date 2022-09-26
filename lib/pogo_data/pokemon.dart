// Dart
import 'dart:math';

// Local
import 'typing.dart';
import 'move.dart';
import 'stats.dart';
import '../modules/stats.dart';
import '../modules/pokemon_types.dart';
import '../modules/gamemaster.dart';
import '../modules/globals.dart';

class Pokemon {
  Pokemon({
    required this.dex,
    required this.pokemonId,
    required this.name,
    required this.typing,
    required this.stats,
    required this.fastMoves,
    required this.chargeMoves,
    required this.eliteFastMoveIds,
    required this.eliteChargeMoveIds,
    required this.thirdMoveCost,
    required this.shadow,
    required this.form,
    required this.familyId,
    required this.evolutions,
    required this.tempEvolutions,
    required this.released,
    required this.tags,
    required this.littleCupIVs,
    required this.greatLeagueIVs,
    required this.ultraLeagueIVs,
  });

  factory Pokemon.fromJson(
    Map<String, dynamic> json, {
    bool isShadow = false,
  }) {
    List<String> moveIds;

    List<FastMove> fastMoves = [];
    if (json.containsKey('fastMoves')) {
      moveIds = List<String>.from(json['fastMoves']);
      fastMoves = Gamemaster.fastMoves
          .where((FastMove move) => moveIds.contains(move.moveId))
          .toList();
    } else {
      fastMoves = [];
    }

    List<ChargeMove> chargeMoves = [];
    if (json.containsKey('chargeMoves')) {
      moveIds = List<String>.from(json['chargeMoves']);
      chargeMoves = Gamemaster.chargeMoves
          .where((ChargeMove move) => moveIds.contains(move.moveId))
          .toList();
    } else {
      chargeMoves = [];
    }

    List<String>? eliteFastMoveIds;
    if (json.containsKey('eliteFastMoves')) {
      eliteFastMoveIds = List<String>.from(json['eliteFastMoves']);
      fastMoves.addAll(Gamemaster.fastMoves
          .where((FastMove move) => eliteFastMoveIds!.contains(move.moveId))
          .toList());
    }

    List<String>? eliteChargeMoveIds;
    if (json.containsKey('eliteChargeMoves')) {
      eliteChargeMoveIds = List<String>.from(json['eliteChargeMoves']);
      chargeMoves.addAll(Gamemaster.chargeMoves
          .where((ChargeMove move) => eliteChargeMoveIds!.contains(move.moveId))
          .toList());
    }

    if (json.containsKey('shadow') && json['shadow']['released'] && !isShadow) {
      String purifiedChargeMove =
          json['shadow']['purifiedChargeMove'] as String;
      chargeMoves.add(Gamemaster.chargeMoves
          .firstWhere((move) => move.moveId == purifiedChargeMove));
    }

    List<String> tags = [];
    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);
    }

    if (isShadow) {
      tags.add('shadow');
    }

    return Pokemon(
      dex: json['dex'] as int,
      pokemonId: (isShadow ? json['shadow']['pokemonId'] : json['pokemonId'])
          as String,
      name: json['name'] as String,
      typing: PokemonTyping.fromJson(json['typing']),
      stats: json.containsKey('stats')
          ? BaseStats.fromJson(json['stats'])
          : BaseStats.empty(),
      fastMoves: fastMoves,
      chargeMoves: chargeMoves,
      eliteFastMoveIds: eliteFastMoveIds,
      eliteChargeMoveIds: eliteChargeMoveIds,
      thirdMoveCost: json.containsKey('thirdMoveCost')
          ? ThirdMoveCost.fromJson(json['thirdMoveCost'])
          : null,
      shadow:
          json.containsKey('shadow') ? Shadow.fromJson(json['shadow']) : null,
      form: json['form'] as String,
      familyId: json['familyId'] as String,
      evolutions: json.containsKey('evolutions')
          ? List<Map<String, dynamic>>.from(json['evolutions'])
              .map((evolutionJson) => Evolution.fromJson(evolutionJson))
              .toList()
          : null,
      tempEvolutions: json.containsKey('tempEvolutions')
          ? List<Map<String, dynamic>>.from(json['tempEvolutions'])
              .map((tempEvoJson) => TempEvolution.fromJson(tempEvoJson))
              .toList()
          : null,
      released:
          (isShadow ? json['shadow']['released'] : json['released']) as bool,
      tags: tags.isEmpty ? null : tags,
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
    List<String> moveIds;

    List<FastMove> fastMoves = [];
    if (json.containsKey('fastMoves')) {
      moveIds = List<String>.from(json['fastMoves']);
      fastMoves = Gamemaster.fastMoves
          .where((FastMove move) => moveIds.contains(move.moveId))
          .toList();
    } else {
      fastMoves = [];
    }

    List<ChargeMove> chargeMoves = [];
    if (json.containsKey('chargeMoves')) {
      moveIds = List<String>.from(json['chargeMoves']);
      chargeMoves = Gamemaster.chargeMoves
          .where((ChargeMove move) => moveIds.contains(move.moveId))
          .toList();
    } else {
      chargeMoves = [];
    }

    List<String>? eliteFastMoveIds;
    if (json.containsKey('eliteFastMoves')) {
      eliteFastMoveIds = List<String>.from(json['eliteFastMoves']);
      fastMoves.addAll(Gamemaster.fastMoves
          .where((FastMove move) => eliteFastMoveIds!.contains(move.moveId))
          .toList());
    }

    List<String>? eliteChargeMoveIds;
    if (json.containsKey('eliteChargeMoves')) {
      eliteChargeMoveIds = List<String>.from(json['eliteChargeMoves']);
      chargeMoves.addAll(Gamemaster.chargeMoves
          .where((ChargeMove move) => eliteChargeMoveIds!.contains(move.moveId))
          .toList());
    }

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
          ? BaseStats.fromJson(json['stats'])
          : BaseStats.empty(),
      fastMoves: fastMoves,
      chargeMoves: chargeMoves,
      eliteFastMoveIds: eliteFastMoveIds,
      eliteChargeMoveIds: eliteChargeMoveIds,
      thirdMoveCost: json.containsKey('thirdMoveCost')
          ? ThirdMoveCost.fromJson(json['thirdMoveCost'])
          : null,
      shadow: null,
      form: json['form'] as String,
      familyId: json['familyId'] as String,
      evolutions: null,
      tempEvolutions: null,
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

  final int dex;
  final String pokemonId;
  final String name;
  final PokemonTyping typing;
  final BaseStats stats;
  final List<FastMove> fastMoves;
  final List<ChargeMove> chargeMoves;
  final List<String>? eliteFastMoveIds;
  final List<String>? eliteChargeMoveIds;
  final ThirdMoveCost? thirdMoveCost;
  final Shadow? shadow;
  final String form;
  final String familyId;
  final List<Evolution>? evolutions;
  final List<TempEvolution>? tempEvolutions;
  final bool released;
  final List<String>? tags;
  final IVs? littleCupIVs;
  final IVs? greatLeagueIVs;
  final IVs? ultraLeagueIVs;

  // Form a string that describes this Pokemon's typing
  String get typeString => typing.toString();

  num get statsProduct => stats.atk * stats.def * stats.hp;

  // Get the type effectiveness of this Pokemon, factoring in current moveset
  List<double> get defenseEffectiveness => typing.defenseEffectiveness;

  // Get a list of all fast move names
  List<String> get fastMoveNames =>
      fastMoves.map((FastMove move) => move.name).toList();

  // Get a list of all charge move names
  List<String> get chargeMoveNames =>
      chargeMoves.map<String>((ChargeMove move) => move.name).toList();

  bool get isShadow => tags?.contains('shadow') ?? false;
  bool get isMega => tags?.contains('mega') ?? false;

  // Get the total attack, defense and hp stats
  // stat total = base stat + iv stat
  List<num> getStatTotals(List<num> ivs) {
    return [
      stats.atk + ivs[1],
      stats.def + ivs[2],
      stats.hp + ivs[3],
    ];
  }
}

class ThirdMoveCost {
  ThirdMoveCost({
    required this.stardust,
    required this.candy,
  });

  factory ThirdMoveCost.fromJson(Map<String, dynamic> json) {
    return ThirdMoveCost(
      stardust: json['stardust'] ?? 0,
      candy: json['candy'] as int,
    );
  }

  final int stardust;
  final int candy;
}

class Shadow {
  Shadow({
    required this.pokemonId,
    required this.purificationStardust,
    required this.purificationCandy,
    required this.purifiedChargeMove,
    required this.shadowChargeMove,
    required this.released,
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

  final String pokemonId;
  final int purificationStardust;
  final int purificationCandy;
  final String purifiedChargeMove;
  final String shadowChargeMove;
  final bool released;
}

class Evolution {
  Evolution({
    required this.pokemonId,
    required this.candyCost,
    required this.form,
    required this.purifiedEvolutionCost,
  });

  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(
      pokemonId: json['pokemonId'] as String,
      candyCost: json['candyCost'] as int,
      form: json['form'] as String?,
      purifiedEvolutionCost: json['purifiedEvolutionCost'] as int?,
    );
  }

  final String pokemonId;
  final int candyCost;
  final String? form;
  final int? purifiedEvolutionCost;
}

class TempEvolution {
  TempEvolution({
    required this.tempEvolutionId,
    required this.typing,
    required this.stats,
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

  final String tempEvolutionId;
  final PokemonTyping typing;
  final BaseStats stats;
  final bool released;
}

// Pokemon instance for simulating battles
class BattlePokemon extends Pokemon {
  BattlePokemon({
    required dex,
    required pokemonId,
    required name,
    required typing,
    required baseStats,
    required fastMoves,
    required chargeMoves,
    required eliteFastMoves,
    required eliteChargeMoves,
    required thirdMoveCost,
    required shadow,
    required isShadow,
    required form,
    required familyId,
    required evolutions,
    required tempEvolutions,
    required released,
    required tags,
    required littleCupIVs,
    required greatLeagueIVs,
    required ultraLeagueIVs,
  }) : super(
          dex: dex,
          pokemonId: pokemonId,
          name: name,
          typing: typing,
          stats: baseStats,
          fastMoves: fastMoves,
          chargeMoves: chargeMoves,
          eliteFastMoveIds: eliteFastMoves,
          eliteChargeMoveIds: eliteChargeMoves,
          thirdMoveCost: thirdMoveCost,
          shadow: shadow,
          form: form,
          familyId: familyId,
          evolutions: evolutions,
          tempEvolutions: tempEvolutions,
          released: released,
          tags: tags,
          littleCupIVs: littleCupIVs,
          greatLeagueIVs: greatLeagueIVs,
          ultraLeagueIVs: ultraLeagueIVs,
        );

  static BattlePokemon fromPokemon(Pokemon other) {
    return BattlePokemon(
      dex: other.dex,
      pokemonId: other.pokemonId,
      name: other.name,
      typing: other.typing,
      baseStats: other.stats,
      fastMoves: List<FastMove>.from(other.fastMoves)
          .map((move) => FastMove.from(move))
          .toList(),
      chargeMoves: List<ChargeMove>.from(other.chargeMoves)
          .map((move) => ChargeMove.from(move))
          .toList(),
      eliteFastMoves:
          other.eliteFastMoveIds != null ? other.eliteFastMoveIds! : null,
      eliteChargeMoves:
          other.eliteChargeMoveIds != null ? other.eliteChargeMoveIds! : null,
      thirdMoveCost: other.thirdMoveCost,
      shadow: other.shadow,
      isShadow: other.isShadow,
      form: other.form,
      familyId: other.familyId,
      evolutions: other.evolutions,
      tempEvolutions: other.tempEvolutions,
      released: other.released,
      tags: other.tags,
      littleCupIVs: other.littleCupIVs,
      greatLeagueIVs: other.greatLeagueIVs,
      ultraLeagueIVs: other.ultraLeagueIVs,
    );
  }

  static BattlePokemon from(
    BattlePokemon other, {
    ChargeMove? nextDecidedChargeMove,
    bool prioritizeMoveAlignment = false,
  }) {
    BattlePokemon copy = BattlePokemon(
      dex: other.dex,
      pokemonId: other.pokemonId,
      name: other.name,
      typing: other.typing,
      baseStats: other.stats,
      fastMoves: other.fastMoves,
      chargeMoves: other.chargeMoves,
      eliteFastMoves:
          other.eliteFastMoveIds != null ? other.eliteFastMoveIds! : null,
      eliteChargeMoves:
          other.eliteChargeMoveIds != null ? other.eliteChargeMoveIds! : null,
      thirdMoveCost: other.thirdMoveCost,
      shadow: other.shadow,
      isShadow: other.isShadow,
      form: other.form,
      familyId: other.familyId,
      evolutions: other.evolutions,
      tempEvolutions: other.tempEvolutions,
      released: other.released,
      tags: other.tags,
      littleCupIVs: other.littleCupIVs,
      greatLeagueIVs: other.greatLeagueIVs,
      ultraLeagueIVs: other.ultraLeagueIVs,
    );

    copy.ivs = other.ivs;
    copy.cp = other.cp;
    copy.maxHp = other.maxHp;
    copy.currentHp = other.currentHp;
    copy.currentShields = other.currentShields;
    copy.cooldown = other.cooldown;
    copy.energy = other.energy;
    copy.chargeTDO = other.chargeTDO;
    copy.chargeEnergyDelta = other.chargeEnergyDelta;

    copy.selectedFastMove = other.selectedFastMove;
    copy.selectedChargeMoves = other.selectedChargeMoves;

    if (nextDecidedChargeMove != null) {
      copy.nextDecidedChargeMove = nextDecidedChargeMove;
    }

    copy.prioritizeMoveAlignment = prioritizeMoveAlignment;

    return copy;
  }

  FastMove selectedFastMove = FastMove.none;
  List<ChargeMove> selectedChargeMoves = List.filled(2, ChargeMove.none);
  ChargeMove nextDecidedChargeMove = ChargeMove.none;

  late final num maxHp;
  IVs ivs = IVs.empty();
  num cp = 0;
  num currentHp = 0.0;
  int currentShields = 0;
  int cooldown = 0;
  num energy = 0;
  num chargeTDO = 0;
  num chargeEnergyDelta = 0;
  num rating = 0;
  bool prioritizeMoveAlignment = false;

  // The damage output per energy spent in a battle
  num get chargeDPE =>
      (chargeEnergyDelta == 0 ? 0 : chargeTDO / chargeEnergyDelta).abs();

  num get currentHpRatio => currentHp / maxHp;
  num get damageRecievedRatio => (maxHp - currentHp) / maxHp;

  // Go through the moveset typing, accumulate the best type effectiveness
  List<double> get offenseCoverage {
    List<double> offenseCoverage = [];
    final fast = selectedFastMove.type.getOffenseEffectiveness();
    final c1 = selectedChargeMoves.first.type.getOffenseEffectiveness();
    List<double> c2;

    if ((selectedChargeMoves.last.isNone())) {
      c2 = List.filled(Globals.typeCount, 0.0);
    } else {
      c2 = selectedChargeMoves.last.type.getOffenseEffectiveness();
    }

    for (int i = 0; i < Globals.typeCount; ++i) {
      offenseCoverage
          .add([fast[i], c1[i], c2[i]].reduce((v1, v2) => (v1 > v2 ? v1 : v2)));
    }

    return offenseCoverage;
  }

  double getOffenseEffectivenessFromTyping(PokemonTyping typing) {
    List<double> coverage = offenseCoverage;
    if (typing.isMonoType()) {
      return coverage[PokemonTypes.typeIndexMap[typing.typeA.typeId]!];
    }

    return coverage[PokemonTypes.typeIndexMap[typing.typeA.typeId]!] *
        coverage[PokemonTypes.typeIndexMap[typing.typeB?.typeId]!];
  }

  bool get hasShield {
    return currentShields != 0;
  }

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
  void initialize(int cpCap) {
    switch (cpCap) {
      case 500:
        ivs = littleCupIVs!;
        break;
      case 1500:
        ivs = greatLeagueIVs!;
        break;
      case 2500:
        ivs = ultraLeagueIVs!;
        break;
    }

    // Calculate maxCp
    cp = Stats.calculateCP(stats, ivs);

    // Calculate battle hp (stamina)
    maxHp = Stats.calculateMaxHp(stats, ivs);
  }

  // Bring that bar back
  void resetHp() {
    currentHp = maxHp;
  }

  void resetCooldown({int modifier = 0}) {
    cooldown = selectedFastMove.duration + modifier;
  }

  void selectMoveset(BattlePokemon opponent) {
    if (chargeMoves.isEmpty || fastMoves.isEmpty) return;

    // Find the charge move with highest damage per energy
    chargeMoves.sort((move1, move2) =>
        (move1.dpe > move2.dpe ? -1 : ((move2.dpe > move1.dpe) ? 1 : 0)));
    num highestDpe = chargeMoves.first.dpe;

    _sortByRating(chargeMoves);
    ChargeMove highestRated = chargeMoves.first;

    // For moves that have a strictly better preference, sharply reduce usage
    num ratingsSum = highestRated.rating;

    for (var i = 1; i < chargeMoves.length; i++) {
      for (var n = 0; n < i; n++) {
        if ((chargeMoves[i].type == chargeMoves[n].type) &&
            (chargeMoves[i].energyDelta >= chargeMoves[n].energyDelta) &&
            (chargeMoves[i].dpe / chargeMoves[n].dpe < 1.3)) {
          chargeMoves[i].rating *= .5;
          break;
        }
      }

      ratingsSum += chargeMoves[i].rating;
    }

    if (ratingsSum > 0) {
      for (var move in chargeMoves) {
        move.initializeEffectiveDamage(this, opponent);

        // Normalize move rating
        move.rating = ((move.rating / ratingsSum) * 100).round();
      }
    }

    _sortByRating(chargeMoves);
    highestRated = chargeMoves.first;

    ratingsSum = 0;
    num baseline = Move.calculateCycleDpt(FastMove.none, highestRated);

    for (var move in fastMoves) {
      move.initializeEffectiveDamage(this, opponent);

      num cycleDpt = Move.calculateCycleDpt(move, highestRated);
      cycleDpt = max(cycleDpt - baseline, .1);

      move.rating = cycleDpt * pow(move.rating, max(highestDpe - 1, 1));
      ratingsSum += move.rating;
    }

    if (ratingsSum > 0) {
      // Normalize move rating
      for (var move in fastMoves) {
        move.rating = ((move.rating / ratingsSum) * 100).round();
      }
    }

    _sortByRating(fastMoves);

    selectedFastMove = fastMoves.first;
    selectedChargeMoves.first = chargeMoves[0];
    if (chargeMoves.length > 1) {
      selectedChargeMoves.last = chargeMoves[1];
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
    final fast = selectedFastMove.type.getOffenseEffectiveness();
    final c1 = selectedChargeMoves[0].type.getOffenseEffectiveness();
    List<double> c2;

    if ((selectedChargeMoves[1].moveId == 'NONE')) {
      c2 = List.filled(Globals.typeCount, 0.0);
    } else {
      c2 = selectedChargeMoves[1].type.getOffenseEffectiveness();
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
    return (stats.atk + ivs.atk) *
        Stats.getCpMultiplier(ivs.level) *
        (isShadow ? Stats.shadowAtkMultiplier : 1);
  }

  num get effectiveDefense {
    return (stats.def + ivs.def) *
        Stats.getCpMultiplier(ivs.level) *
        (isShadow ? Stats.shadowDefMultiplier : 1);
  }
}
