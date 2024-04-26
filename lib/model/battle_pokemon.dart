// Dart
import 'dart:math';

// Local
import 'pokemon.dart';
import 'pokemon_base.dart';
import 'move.dart';
import 'pokemon_stats.dart';
import '../modules/stats.dart';
import '../modules/globals.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All data related to a battle is managed by this abstraction. This is used
exclusively for battle simulations.
-------------------------------------------------------------------------------
*/

// Pokemon instance for simulating battles
class BattlePokemon extends PokemonBase {
  BattlePokemon({
    required super.dex,
    required super.pokemonId,
    required super.name,
    required super.typing,
    required super.stats,
    super.eliteFastMoveIds,
    super.eliteChargeMoveIds,
    super.thirdMoveCost,
    super.shadow,
    required super.form,
    required super.familyId,
    required super.released,
    super.tags,
    super.littleCupIVs,
    super.greatLeagueIVs,
    super.ultraLeagueIVs,
    this.cp = 0,
    this.currentRating = 0,
    this.currentHp = 0,
    this.currentShields = 0,
    this.cooldown = 0,
    this.energy = 0,
    this.chargeTDO = 0,
    this.chargeEnergyDelta = 0,
    this.prioritizeMoveAlignment = false,
  });

  factory BattlePokemon.fromPokemon(PokemonBase other) {
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
      ..battleFastMoves
          .addAll(other.getFastMoves().map((move) => FastMove.from(move)))
      ..battleChargeMoves
          .addAll(other.getChargeMoves().map((move) => ChargeMove.from(move)));
  }

  factory BattlePokemon.fromCupPokemon(CupPokemon other) {
    return BattlePokemon.fromPokemon(other.getBase())
      ..selectedBattleFastMove = other.getSelectedFastMove()
      ..selectedBattleChargeMoves = other.getSelectedChargeMoves();
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
      ..selectedBattleFastMove = other.selectedBattleFastMove
      ..selectedBattleChargeMoves = other.selectedBattleChargeMoves
      ..maxHp = other.maxHp
      .._atkBuffStage = other._atkBuffStage
      .._defBuffStage = other._defBuffStage;

    if (nextDecidedChargeMove != null) {
      copy.nextDecidedChargeMove = nextDecidedChargeMove;
    }

    return copy;
  }

  static Future<BattlePokemon> fromPokemonAsync(PokemonBase other) async {
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
      ..battleFastMoves.addAll(
          (await other.getFastMovesAsync()).map((move) => FastMove.from(move)))
      ..battleChargeMoves.addAll((await other.getChargeMovesAsync())
          .map((move) => ChargeMove.from(move)));
  }

  static Future<BattlePokemon> fromCupPokemonAsync(CupPokemon other) async {
    return (await BattlePokemon.fromPokemonAsync(await other.getBaseAsync()))
      ..selectedBattleFastMove = await other.getSelectedFastMoveAsync()
      ..selectedBattleChargeMoves = await other.getSelectedChargeMovesAsync();
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

  List<FastMove> battleFastMoves = [];
  List<ChargeMove> battleChargeMoves = [];

  FastMove selectedBattleFastMove = FastMove.none;
  List<ChargeMove> selectedBattleChargeMoves = List.filled(2, ChargeMove.none);
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

  List<Move> moveset() =>
      [selectedBattleFastMove, ...selectedBattleChargeMoves];

  void useShield() {
    currentShields -= 1;
  }

  void applyFastMoveDamage(BattlePokemon opponent) {
    energy += selectedBattleFastMove.energyDelta;
    opponent.recieveDamage(selectedBattleFastMove.damage);
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
    cooldown = selectedBattleFastMove.duration + modifier;
  }

  void initializeMoveset(
    BattlePokemon opponent, {
    FastMove? selectedFastMoveOverride,
    List<ChargeMove>? selectedChargeMoveOverrides,
  }) {
    if (battleFastMoves.isEmpty || battleChargeMoves.isEmpty) return;

    // Find the charge move with highest damage per energy
    battleChargeMoves.sort((move1, move2) => (move1.dpe() > move2.dpe()
        ? -1
        : ((move2.dpe() > move1.dpe()) ? 1 : 0)));
    num highestDpe = battleChargeMoves.first.dpe();

    _sortByRating(battleChargeMoves);
    ChargeMove highestRated = battleChargeMoves.first;

    // For moves that have a strictly better preference, sharply reduce usage
    num ratingsSum = highestRated.rating;

    for (var i = 1; i < battleChargeMoves.length; i++) {
      for (var n = 0; n < i; n++) {
        if ((battleChargeMoves[i].type == battleChargeMoves[n].type) &&
            (battleChargeMoves[i].energyDelta >=
                battleChargeMoves[n].energyDelta) &&
            (battleChargeMoves[i].dpe() / battleChargeMoves[n].dpe() < 1.3)) {
          battleChargeMoves[i].rating *= .5;
          break;
        }
      }

      ratingsSum += battleChargeMoves[i].rating;
    }

    if (ratingsSum > 0) {
      for (var move in battleChargeMoves) {
        move.calculateEffectiveDamage(this, opponent);

        // Normalize move rating
        move.rating = ((move.rating / ratingsSum) * 100).round().toDouble();
      }
    }

    _sortByRating(battleChargeMoves);
    highestRated = battleChargeMoves.first;

    ratingsSum = 0;
    num baseline = Move.calculateCycleDpt(FastMove.none, highestRated);

    for (var move in battleFastMoves) {
      move.calculateEffectiveDamage(this, opponent);

      num cycleDpt = Move.calculateCycleDpt(move, highestRated);
      cycleDpt = max(cycleDpt - baseline, .1);

      move.rating =
          cycleDpt * pow(move.rating, max(highestDpe - 1, 1)).toDouble();
      ratingsSum += move.rating;
    }

    if (ratingsSum > 0) {
      // Normalize move rating
      for (var move in battleFastMoves) {
        move.rating = ((move.rating / ratingsSum) * 100).round().toDouble();
      }
    }

    _sortByRating(battleFastMoves);

    if (selectedFastMoveOverride == null) {
      selectedBattleFastMove = battleFastMoves.first;
    } else {
      selectedBattleFastMove = battleFastMoves
          .firstWhere((move) => move.moveId == selectedFastMoveOverride.moveId);
    }

    if (selectedChargeMoveOverrides == null) {
      selectedBattleChargeMoves.first = battleChargeMoves[0];
      if (battleChargeMoves.length > 1) {
        selectedBattleChargeMoves.last = battleChargeMoves[1];
      }
    } else {
      selectedBattleChargeMoves.first = battleChargeMoves.firstWhere(
          (move) => move.moveId == selectedChargeMoveOverrides.first.moveId);

      if (battleChargeMoves.length > 1 &&
          selectedChargeMoveOverrides.length > 1) {
        selectedBattleChargeMoves.last = battleChargeMoves.firstWhere(
            (move) => move.moveId == selectedChargeMoveOverrides.last.moveId);
      }
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
    final fast = selectedBattleFastMove.type.offenseEffectiveness();
    final c1 = selectedBattleChargeMoves[0].type.offenseEffectiveness();
    List<double> c2;

    if ((selectedBattleChargeMoves.last.isNone())) {
      c2 = List.filled(Globals.typeCount, 0.0);
    } else {
      c2 = selectedBattleChargeMoves[1].type.offenseEffectiveness();
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
