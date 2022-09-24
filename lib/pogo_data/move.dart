// Dart
import 'dart:math';

// Local
import 'typing.dart';
import 'pokemon.dart';
import '../../../modules/types.dart';
import '../../../modules/debug_cli.dart';
import '../../../modules/stats.dart';

/*
------------------------- D A M A G E - F O R M U L A -------------------------
FLOOR(0.5 * POWER * (SELF_ATK / OPP_DEF) * STAB * EFFECTIVENESS * BONUS) + 1
-------------------------------------------------------------------------------
SELF_ATK   : atk stat + atk iv
OPP_DEF    : def stat + def iv
BONUS      : 1.3 (hard-coded bonus for PVP)
*/

class Move {
  Move({
    required this.moveId,
    required this.name,
    required this.type,
    required this.power,
    required this.energyDelta,
  });

  final String moveId;
  final String name;
  final Type type;
  final num power;
  final num energyDelta;

  num rating = 0;
  num damage = 0;

  bool isSameMove(Move other) {
    return moveId == other.moveId;
  }

  void initializeEffectiveDamage(BattlePokemon owner, BattlePokemon opponent) {
    num stab = 1;

    // Stab
    if (owner.typing.contains(type)) {
      stab = 1.2;
    }

    // Effectiveness
    num effectiveness = opponent.typing.getEffectivenessFromType(type);

    damage = (.5 *
                power *
                (owner.effectiveAttack / opponent.effectiveDefense) *
                stab *
                effectiveness *
                StatsModule.pvpDamageBonusMultiplier)
            .floor() +
        1;
  }

  bool isNone() {
    return moveId == 'none';
  }

  // Calculate cycle damage per turn given a fast move paired with
  // the given charge move
  static num calculateCycleDpt(FastMove fastMove, ChargeMove chargeMove) {
    if (chargeMove.energyDelta == 0) return 1.0;

    // Calculate multiple cycles to avoid issues with overflow energy
    final cycleFastMoves = 150 / fastMove.energyDelta;
    final cycleTime = (cycleFastMoves * fastMove.duration) + 1;
    final cycleDamage = (cycleFastMoves * fastMove.power) +
        (chargeMove.power * ((150 / chargeMove.energyDelta.abs()) - 1)) +
        1; // Emulate TDO with a shield
    final cycleDPT = cycleDamage / cycleTime;

    return cycleDPT;
  }
}

class FastMove extends Move {
  FastMove({
    required moveId,
    required name,
    required type,
    required power,
    required energyDelta,
    required this.duration,
  }) : super(
          moveId: moveId,
          name: name,
          type: type,
          power: power,
          energyDelta: energyDelta,
        ) {
    _calculateBaseRating();
  }

  static FastMove from(FastMove other) {
    return FastMove(
      moveId: other.moveId,
      name: other.name,
      type: other.type,
      power: other.power,
      energyDelta: other.energyDelta,
      duration: other.duration,
    );
  }

  factory FastMove.fromJson(Map<String, dynamic> json) {
    return FastMove(
      moveId: json['moveId'] as String,
      name: json['name'] as String,
      type: TypeModule.typeMap[json['type'] as String]!,
      power: json['power'] as num,
      energyDelta: json['energyDelta'] as num,
      duration: json['duration'] as int,
    );
  }

  static final FastMove none = FastMove(
    moveId: 'none',
    name: 'None',
    type: Type.none,
    power: 1,
    energyDelta: 12,
    duration: 4,
  );

  final int duration;

  // Damage per turn
  num get dpt {
    return power / duration;
  }

  // Energy gain per turn
  num get ept {
    return energyDelta / duration;
  }

  void _calculateBaseRating() {
    rating = pow(dpt * pow(ept, 4), .2);
  }

  void debugPrint() {
    DebugCLI.print(name, 'dpt: $dpt  ept: $ept  rating: $rating');
  }
}

class ChargeMove extends Move {
  ChargeMove({
    required moveId,
    required name,
    required type,
    required power,
    required energyDelta,
    required this.buffs,
  }) : super(
          moveId: moveId,
          name: name,
          type: type,
          power: power,
          energyDelta: energyDelta,
        ) {
    _calculateBaseRating();
  }

  static ChargeMove from(ChargeMove other) {
    return ChargeMove(
      moveId: other.moveId,
      name: other.name,
      type: other.type,
      power: other.power,
      energyDelta: other.energyDelta,
      buffs: other.buffs,
    );
  }

  factory ChargeMove.fromJson(Map<String, dynamic> json) {
    return ChargeMove(
      moveId: json['moveId'] as String,
      name: json['name'] as String,
      type: TypeModule.typeMap[json['type'] as String]!,
      power: json['power'] as num,
      energyDelta: json['energyDelta'] as num,
      buffs:
          json.containsKey('buffs') ? MoveBuffs.fromJson(json['buffs']) : null,
    );
  }

  static final ChargeMove none = ChargeMove(
    moveId: 'none',
    name: 'None',
    type: Type.none,
    power: 0,
    energyDelta: 0,
    buffs: null,
  );

  final MoveBuffs? buffs;

  // Damage per energy
  num get dpe {
    if (energyDelta == 0) return 1.0;
    return pow(power, 2) / pow(energyDelta, 4);
  }

  void _calculateBaseRating() {
    rating = dpe * (buffs == null ? 1 : pow(buffs!.buffMultiplier, 2));
  }

  void debugPrint() {
    DebugCLI.print(name, 'dpe : $dpe  rating : $rating');
  }
}

class MoveBuffs {
  MoveBuffs({
    required this.chance,
    required this.selfAttack,
    required this.selfDefense,
    required this.opponentAttack,
    required this.opponentDefense,
  });

  factory MoveBuffs.fromJson(Map<String, dynamic> json) {
    return MoveBuffs(
      chance: json['chance'] as num,
      selfAttack: json['selfAttack'] as num?,
      selfDefense: json['selfDefense'] as num?,
      opponentAttack: json['opponentAttack'] as num?,
      opponentDefense: json['opponentDefense'] as num?,
    );
  }

  final num chance;
  final num? selfAttack;
  final num? selfDefense;
  final num? opponentAttack;
  final num? opponentDefense;

  // Calculate a multiplier based on :
  // - Opponent buff
  // - Owner buff
  // - Apply chance
  num get buffMultiplier {
    num multiplier = chance;
    multiplier *= _buffMultiplier(selfAttack, false);
    multiplier *= _buffMultiplier(opponentAttack, true);
    multiplier *= _buffMultiplier(opponentDefense, true);
    return 1 + ((multiplier - 1) * chance);
  }

  num _buffMultiplier(num? buff, bool targetOpponent) {
    if (buff == null) return 1;

    num multiplier = 1;
    if (targetOpponent) {
      if (buff > 0) {
        multiplier *= 1 / ((4 + buff) / 4);
      } else {
        multiplier *= 1 / (4 / (4 - buff));
      }
    } else {
      if (buff > 0) {
        multiplier *= ((4 + buff) / 4);
      } else {
        multiplier *= (4 / (4 - buff));
      }
    }

    return multiplier;
  }
}
