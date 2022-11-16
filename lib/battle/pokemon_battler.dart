// Local
import '../pogo_objects/pokemon.dart';
import 'battle_result.dart';
import '../modules/data/globals.dart';
import '../modules/data/debug_cli.dart';
import '../enums/battle_outcome.dart';

class PokemonBattler {
  static const List<int> shieldScenarios = [0, 1, 2];

  static void resetPokemon(
    BattlePokemon self,
    BattlePokemon opponent,
  ) {
    self.resetHp();
    opponent.resetHp();
    self.resetCooldown();
    opponent.resetCooldown();
  }

  static BattleResult battle(
    BattlePokemon self,
    BattlePokemon opponent, {
    int turn = 1,
    bool makeTimeline = false,
  }) {
    return _closestMatchup(_allBattleCombinations(
          self,
          opponent,
          turn,
          makeTimeline ? [] : null,
        )) ??
        BattleResult(
          self: self,
          opponent: opponent,
          timeline: [],
        );
  }

  static List<BattleResult> _battle(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
    List<BattleTurnSnapshot>? timeline,
  ) {
    if (_battleComplete(self, opponent, turn)) {
      return [
        BattleResult(
          self: self,
          opponent: opponent,
          timeline: timeline,
        )
      ];
    }

    while (!_battleComplete(self, opponent, turn)) {
      self.cooldown -= 1;
      opponent.cooldown -= 1;

      if (_chargeMoveSequenceBoth(self, opponent)) {
        _chargeMoveSequenceTieBreak(self, opponent);

        timeline?.add(BattleTurnSnapshot(
          turn: turn,
          self: self,
          opponent: opponent,
          description: 'Charge move tie break\n'
              '${self.name} atk : ${self.effectiveAttack}\n'
              '${opponent.name} atk : ${opponent.effectiveAttack}',
        ));

        return _allBattleCombinations(self, opponent, turn + 1, timeline);
      } else {
        if (_chargeMoveSequenceReady(self, opponent.cooldown)) {
          _chargeMoveSequence(self, opponent);

          timeline?.add(BattleTurnSnapshot(
            turn: turn,
            self: self,
            opponent: opponent,
            description: '${self.name} used ${self.nextDecidedChargeMove.name}',
          ));

          return _selfBattleCombinations(
            self,
            opponent,
            turn + 1,
            timeline,
          );
        } else if (_chargeMoveSequenceReady(opponent, self.cooldown)) {
          _chargeMoveSequence(opponent, self);

          timeline?.add(BattleTurnSnapshot(
            turn: turn,
            self: self,
            opponent: opponent,
            description:
                '${opponent.name} used ${opponent.nextDecidedChargeMove.name}',
          ));

          return _opponentBattleCombinations(
            self,
            opponent,
            turn + 1,
            timeline,
          );
        } else {
          _fastMoveSequence(self, opponent);

          timeline?.add(BattleTurnSnapshot(
            turn: turn,
            self: self,
            opponent: opponent,
            description: 'Fast move turn',
          ));

          ++turn;
        }
      }
    }

    return [
      BattleResult(
        self: self,
        opponent: opponent,
        timeline: timeline,
      )
    ];
  }

  static bool _chargeMoveSequenceBoth(
    BattlePokemon self,
    BattlePokemon opponent,
  ) {
    return self.cooldown == 0 &&
        opponent.cooldown == 0 &&
        _chargeMoveSequenceReady(self, opponent.cooldown) &&
        _chargeMoveSequenceReady(opponent, self.cooldown);
  }

  static bool _chargeMoveSequenceReady(
    BattlePokemon pokemon,
    int opponentCooldown,
  ) {
    return !pokemon.nextDecidedChargeMove.isNone() &&
        pokemon.energy + pokemon.nextDecidedChargeMove.energyDelta >= 0 &&
        (pokemon.prioritizeMoveAlignment ? opponentCooldown == 0 : true);
  }

  // Both Pokemon have cooled down and have charge moves ready, compare
  // against effective attack to break the tie.
  static void _chargeMoveSequenceTieBreak(
    BattlePokemon self,
    BattlePokemon opponent,
  ) {
    BattlePokemon firstAttacker;
    BattlePokemon secondAttacker;

    // There can be a third case here, but for simulation, it is fine to
    // give self the win if true attacks are equal.
    if (self.effectiveAttack >= opponent.effectiveAttack) {
      firstAttacker = self;
      secondAttacker = opponent;
    } else {
      firstAttacker = opponent;
      secondAttacker = self;
    }

    firstAttacker.applyChargeMoveDamage(secondAttacker);
    self.resetCooldown();
    if (secondAttacker.currentHp > 0) {
      secondAttacker.applyChargeMoveDamage(firstAttacker);
      opponent.resetCooldown();
    }
  }

  // One Pokemon |chargeUser| is in a charge move sequence
  // Apply charge move damage, followed by the defender's immediate fast
  // move damage
  static void _chargeMoveSequence(
    BattlePokemon chargeUser,
    BattlePokemon defender,
  ) {
    chargeUser.applyChargeMoveDamage(defender);
    if (defender.currentHp > 0) {
      defender.applyFastMoveDamage(chargeUser);
      defender.resetCooldown();
    }
    chargeUser.resetCooldown();
  }

  static void _fastMoveSequence(
    BattlePokemon self,
    BattlePokemon opponent,
  ) {
    if (self.cooldown == 0) {
      self.applyFastMoveDamage(opponent);
      self.resetCooldown();
    }
    if (opponent.cooldown == 0) {
      opponent.applyFastMoveDamage(self);
      opponent.resetCooldown();
    }
  }

  static BattleResult? _closestMatchup(List<BattleResult?> results) {
    results = results.whereType<BattleResult>().toList();

    results = results as List<BattleResult>;

    BattleResult? selfClosestWin;
    BattleResult? opponentClosestWin;

    List<BattleResult> wins =
        results.where((result) => result.outcome == BattleOutcome.win).toList();
    List<BattleResult> losses = results
        .where((result) => result.outcome == BattleOutcome.loss)
        .toList();

    if (wins.isNotEmpty) {
      selfClosestWin = wins.reduce((rating1, rating2) =>
          (rating1.ratingDifference > rating2.ratingDifference
              ? rating1
              : rating2));
    }

    if (losses.isNotEmpty) {
      opponentClosestWin = losses.reduce((rating1, rating2) =>
          (rating1.ratingDifference > rating2.ratingDifference
              ? rating1
              : rating2));
    }

    if (selfClosestWin == null) {
      return opponentClosestWin;
    } else if (opponentClosestWin == null) {
      return selfClosestWin;
    }

    return selfClosestWin.self.currentRating >
            opponentClosestWin.opponent.currentRating
        ? selfClosestWin
        : opponentClosestWin;
  }

  static bool _battleComplete(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
  ) {
    return self.currentHp == 0 ||
        opponent.currentHp == 0 ||
        turn > Globals.maxPvpTurns;
  }

  static List<BattleResult> _allBattleCombinations(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
    List<BattleTurnSnapshot>? timeline,
  ) {
    List<BattleResult> results = [
      ..._battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedBattleChargeMoves.first,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedBattleChargeMoves.first,
        ),
        turn,
        timeline == null ? null : List<BattleTurnSnapshot>.from(timeline),
      ),
      ..._battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedBattleChargeMoves.last,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedBattleChargeMoves.last,
        ),
        turn,
        timeline == null ? null : List<BattleTurnSnapshot>.from(timeline),
      ),
      ..._battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedBattleChargeMoves.first,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedBattleChargeMoves.last,
        ),
        turn,
        timeline == null ? null : List<BattleTurnSnapshot>.from(timeline),
      ),
      ..._battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedBattleChargeMoves.last,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedBattleChargeMoves.first,
        ),
        turn,
        timeline == null ? null : List<BattleTurnSnapshot>.from(timeline),
      ),
    ];

    return results;
  }

  static List<BattleResult> _selfBattleCombinations(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
    List<BattleTurnSnapshot>? timeline, {
    bool prioritizeMoveAlignment = false,
  }) {
    return [
      ..._battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedBattleChargeMoves.first,
          prioritizeMoveAlignment: prioritizeMoveAlignment,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.nextDecidedChargeMove,
        ),
        turn,
        timeline == null ? null : List<BattleTurnSnapshot>.from(timeline),
      ),
      ..._battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedBattleChargeMoves.last,
          prioritizeMoveAlignment: prioritizeMoveAlignment,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.nextDecidedChargeMove,
        ),
        turn,
        timeline == null ? null : List<BattleTurnSnapshot>.from(timeline),
      ),
    ];
  }

  static List<BattleResult> _opponentBattleCombinations(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
    List<BattleTurnSnapshot>? timeline, {
    bool prioritizeMoveAlignment = false,
  }) {
    return [
      ..._battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.nextDecidedChargeMove,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedBattleChargeMoves.first,
          prioritizeMoveAlignment: prioritizeMoveAlignment,
        ),
        turn,
        timeline == null ? null : List<BattleTurnSnapshot>.from(timeline),
      ),
      ..._battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.nextDecidedChargeMove,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedBattleChargeMoves.last,
          prioritizeMoveAlignment: prioritizeMoveAlignment,
        ),
        turn,
        timeline == null ? null : List<BattleTurnSnapshot>.from(timeline),
      ),
    ];
  }

  static void debugPrintInitialization(
    BattlePokemon self,
    BattlePokemon opponent,
  ) {
    DebugCLI.printMulti(self.name, [
      'fast    : ${self.selectedBattleFastMove.name} : ${self.selectedBattleFastMove.damage} : '
          'energy delta : ${self.selectedBattleFastMove.energyDelta}',
      'charge1 : ${self.selectedBattleChargeMoves.first.name} : ${self.selectedBattleChargeMoves.first.damage} : '
          'energy delta : ${self.selectedBattleChargeMoves.first.energyDelta}',
      'charge2 : ${self.selectedBattleChargeMoves.last.name} : ${self.selectedBattleChargeMoves.last.damage} : '
          'energy delta : ${self.selectedBattleChargeMoves.last.energyDelta}',
      'level   : ${self.selectedIVs.level}',
      'cp      : ${self.cp}',
      'ivs     : ${self.selectedIVs.atk}  ${self.selectedIVs.def}  ${self.selectedIVs.hp}'
    ]);
    DebugCLI.printMulti(opponent.name, [
      'fast : ${opponent.selectedBattleFastMove.name} : ${opponent.selectedBattleFastMove.damage} : '
          'energy delta : ${opponent.selectedBattleFastMove.energyDelta}',
      'charge1 : ${opponent.selectedBattleChargeMoves.first.name} : ${opponent.selectedBattleChargeMoves.first.damage} : '
          'energy delta : ${opponent.selectedBattleChargeMoves.first.energyDelta}',
      'charge2 : ${opponent.selectedBattleChargeMoves.last.name} : ${opponent.selectedBattleChargeMoves.last.damage} : '
          'energy delta : ${opponent.selectedBattleChargeMoves.last.energyDelta}',
      'level   : ${opponent.selectedIVs.level}',
      'cp      : ${opponent.cp}',
      'ivs     : ${opponent.selectedIVs.atk}  ${opponent.selectedIVs.def}  ${opponent.selectedIVs.hp}'
    ]);
  }

  static void debugPrintBattleOutcome(BattleResult results) {
    String selfOutcome = results.outcome.name;
    String opponentOutcome = '';
    switch (results.outcome) {
      case BattleOutcome.tie:
        opponentOutcome = 'tie';
        break;
      case BattleOutcome.loss:
        opponentOutcome = 'win';
        break;
      case BattleOutcome.win:
        opponentOutcome = 'loss';
        break;
    }
    DebugCLI.printHeader('Outcome');
    DebugCLI.printMulti(results.self.name, [
      selfOutcome,
      'score : ${results.self.currentRating}',
    ]);
    DebugCLI.printMulti(results.opponent.name, [
      opponentOutcome,
      'score : ${results.opponent.currentRating}',
    ]);
    DebugCLI.printFooter();
  }
}

class BattleTurnSnapshot {
  BattleTurnSnapshot({
    required this.turn,
    required BattlePokemon self,
    required BattlePokemon opponent,
    required this.description,
  }) {
    this.self = BattlePokemon.from(
      self,
      nextDecidedChargeMove: self.nextDecidedChargeMove,
    );
    this.opponent = BattlePokemon.from(
      opponent,
      nextDecidedChargeMove: opponent.nextDecidedChargeMove,
    );
  }

  final int turn;
  late final BattlePokemon self;
  late final BattlePokemon opponent;
  final String description;

  void debugPrint() {
    DebugCLI.printMulti('Turn $turn', [description]);
    DebugCLI.printMulti(self.name, [
      'hp             : ${self.currentHp} / ${self.maxHp}',
      'energy         : ${self.energy}',
      'cooldown       : ${self.cooldown}',
      '-' * (1 + DebugCLI.debugHeaderWidth),
      'next charge    : ${self.nextDecidedChargeMove.name}',
    ]);
    DebugCLI.printMulti(opponent.name, [
      'hp             : ${opponent.currentHp} / ${opponent.maxHp}',
      'energy         : ${opponent.energy}',
      'cooldown       : ${opponent.cooldown}',
      '-' * (1 + DebugCLI.debugHeaderWidth),
      'next charge    : ${opponent.nextDecidedChargeMove.name}',
    ]);
  }
}
