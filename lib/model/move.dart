// Dart
import 'dart:math';

// Local
import 'pokemon_typing.dart';
import 'battle_pokemon.dart';
import '../modules/stats.dart';
import '../modules/pogo_debugging.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All data related to Pokemon moves are managed here. A move can be a Fast Move
or a Charge Move.
-------------------------------------------------------------------------------

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

  Map<String, dynamic> toJson() {
    return {
      'moveId': moveId,
      'name': name,
      'type': type.typeId,
      'power': power,
      'energyDelta': energyDelta,
    };
  }

  final String moveId;
  final String name;
  final PokemonType type;
  final double power;
  final double energyDelta;

  double rating = 0;

  double damage = 0;

  int usage = 0;

  bool isNone() => moveId == 'none';

  bool isSameMove(Move other) {
    return moveId == other.moveId;
  }

  void calculateEffectiveDamage(BattlePokemon owner, BattlePokemon opponent) {
    double stab = 1;

    // Stab
    if (owner.typing.contains(type)) {
      stab = 1.2;
    }

    // Effectiveness
    double effectiveness =
        opponent.typing.getEffectivenessFromType(type).toDouble();

    damage = (.5 *
                power *
                (owner.effectiveAttack / opponent.effectiveDefense) *
                stab *
                effectiveness *
                Stats.pvpDamageBonusMultiplier)
            .floor() +
        1;
  }

  // Calculate cycle damage per turn given a fast move paired with
  // the given charge move
  static double calculateCycleDpt(FastMove fastMove, ChargeMove chargeMove) {
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
    required super.moveId,
    required super.name,
    required super.type,
    required super.power,
    required super.energyDelta,
    required this.duration,
  }) {
    _calculateBaseRating();
  }

  factory FastMove.from(FastMove other) {
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
      type: PokemonType(typeId: json['type'] as String),
      power: (json['power'] as num).toDouble(),
      energyDelta: (json['energyDelta'] as num).toDouble(),
      duration: json['duration'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['duration'] = duration;
    return json;
  }

  final int duration;

  static final FastMove none = FastMove(
    moveId: 'none',
    name: 'None',
    type: PokemonType.none,
    power: 1,
    energyDelta: 12,
    duration: 4,
  );

  // Damage per turn
  double dpt() {
    return power / duration;
  }

  // Energy gain per turn
  double ept() {
    return energyDelta / duration;
  }

  void _calculateBaseRating() {
    rating = pow(dpt() * pow(ept(), 4), .2).toDouble();
  }

  void debugPrint() {
    PogoDebugging.print(name, 'dpt : $dpt()  ept : $ept()  rating : $rating');
  }
}

class ChargeMove extends Move {
  ChargeMove({
    required super.moveId,
    required super.name,
    required super.type,
    required super.power,
    required super.energyDelta,
    required this.buffs,
  }) {
    _calculateBaseRating();
  }

  factory ChargeMove.from(ChargeMove other) {
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
      type: PokemonType(typeId: json['type'] as String),
      power: (json['power'] as num).toDouble(),
      energyDelta: (json['energyDelta'] as num).toDouble(),
      buffs:
          json.containsKey('buffs') ? MoveBuffs.fromJson(json['buffs']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['buffs'] = buffs?.toJson();
    return json;
  }

  final MoveBuffs? buffs;

  static final ChargeMove none = ChargeMove(
    moveId: 'none',
    name: 'None',
    type: PokemonType.none,
    power: 0,
    energyDelta: 0,
    buffs: null,
  );

  void _calculateBaseRating() {
    rating = dpe() *
        (buffs == null ? 1 : pow(buffs!.buffMultiplier(), 2)).toDouble();
  }

  // Damage per energy
  double dpe() {
    if (energyDelta == 0) return 1.0;
    return pow(power, 2) / pow(energyDelta, 4);
  }

  void debugPrint() {
    PogoDebugging.print(name, 'dpe : $dpe()  rating : $rating');
  }
}

class MoveBuffs {
  MoveBuffs({
    this.chance = 0,
    this.selfAttack,
    this.selfDefense,
    this.opponentAttack,
    this.opponentDefense,
  });

  factory MoveBuffs.fromJson(Map<String, dynamic> json) {
    return MoveBuffs(
      chance: (json['chance'] as num).toDouble(),
      selfAttack: json['selfAttack'] as int?,
      selfDefense: json['selfDefense'] as int?,
      opponentAttack: json['opponentAttack'] as int?,
      opponentDefense: json['opponentDefense'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chance': chance,
      'selfAttack': selfAttack,
      'selfDefense': selfDefense,
      'opponentAttack': opponentAttack,
      'opponentDefense': opponentDefense,
    };
  }

  final double chance;
  final int? selfAttack;
  final int? selfDefense;
  final int? opponentAttack;
  final int? opponentDefense;

  // Calculate a multiplier based on :
  // - Opponent buff
  // - Owner buff
  // - Apply chance
  double buffMultiplier() {
    double multiplier = chance;
    multiplier *= _buffMultiplier(selfAttack, false);
    multiplier *= _buffMultiplier(opponentAttack, true);
    multiplier *= _buffMultiplier(opponentDefense, true);
    return 1 + ((multiplier - 1) * chance);
  }

  double _buffMultiplier(int? buff, bool targetOpponent) {
    if (buff == null) return 1;

    double multiplier = 1;
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
