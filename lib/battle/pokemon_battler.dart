// Local
import '../pogo_data/pokemon.dart';
import '../rankers/ranking_data.dart';
import '../modules/globals.dart';
import '../modules/debug_cli.dart';

enum BattleOutcome {
  win,
  loss,
  tie,
  none,
}

class PokemonBattler {
  static const List<int> shieldScenarios = [0, 1, 2];

  static const Map<int, List<String>> cupBans = {
    1500: [
      'chansey',
      'miltank',
      'mewtwo',
      'giratina_altered',
      'groudon',
      'kyogre',
      'garchomp',
      'latios',
      'latias',
      'palkia',
      'dialga',
      'heatran',
      'regice',
      'regirock'
    ]
  };

  static bool isBanned(int cpCap, String pokemonId) {
    return cupBans[cpCap]!.contains(pokemonId);
  }

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
    List<BattleTurnSnapshot>? timeline,
  }) {
    return _bestSelfRating(_allBattleCombinations(
      self,
      opponent,
      turn,
      timeline ?? [],
    ))!;
  }

  static BattleResult _battle(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
    List<BattleTurnSnapshot> timeline,
  ) {
    if (_battleComplete(self, opponent, turn)) {
      return BattleResult(
        self: self,
        opponent: opponent,
        timeline: timeline,
      );
    }

    bool chargeMoveUsed = false;
    List<BattleResult> battleResults = [];

    while (!chargeMoveUsed && !_battleComplete(self, opponent, turn)) {
      self.fastMoveCooldown -= 1;
      opponent.fastMoveCooldown -= 1;

      if (_chargeMoveSequenceBoth(self, opponent)) {
        _chargeMoveSequenceTieBreak(self, opponent);

        timeline.add(BattleTurnSnapshot(
          turn: turn,
          self: self,
          opponent: opponent,
          description: 'Charge move tie break\n'
              '${self.name} atk : ${self.effectiveAttack}\n'
              '${opponent.name} atk : ${opponent.effectiveAttack}',
        ));

        battleResults.add(battle(
          self,
          opponent,
          turn: ++turn,
          timeline: timeline,
        ));

        chargeMoveUsed = true;
      } else {
        if (_chargeMoveSequenceReady(self, opponent.fastMoveCooldown)) {
          _chargeMoveSequence(self, opponent);

          timeline.add(BattleTurnSnapshot(
            turn: turn,
            self: self,
            opponent: opponent,
            description: '${self.name} used ${self.nextDecidedChargeMove.name}',
          ));

          battleResults.add(battle(
            self,
            opponent,
            turn: ++turn,
            timeline: timeline,
          ));

          chargeMoveUsed = true;
        } else if (_chargeMoveSequenceReady(opponent, self.fastMoveCooldown)) {
          _chargeMoveSequence(opponent, self);

          timeline.add(BattleTurnSnapshot(
            turn: turn,
            self: self,
            opponent: opponent,
            description:
                '${opponent.name} used ${opponent.nextDecidedChargeMove.name}',
          ));

          battleResults.add(battle(
            self,
            opponent,
            turn: ++turn,
            timeline: timeline,
          ));

          chargeMoveUsed = true;
        } else {
          _fastMoveSequence(self, opponent);

          timeline.add(BattleTurnSnapshot(
            turn: turn,
            self: self,
            opponent: opponent,
            description: 'Fast move turn',
          ));

          ++turn;
        }
      }
    }

    return _bestSelfRating(battleResults) ??
        BattleResult(
          self: self,
          opponent: opponent,
          timeline: timeline,
        );
  }

  static BattleResult? _bestSelfRating(List<BattleResult> results) {
    if (results.isEmpty) return null;
    BattleResult closestMatchup = results.first;

    for (BattleResult result in results) {
      if (result.opponent.rating < result.opponent.rating) {
        closestMatchup = result;
      }
    }

    return closestMatchup;
  }

  static bool _battleComplete(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
  ) {
    return self.currentHp <= 0 ||
        opponent.currentHp <= 0 ||
        turn > Globals.maxPvpTurns;
  }

  static bool _chargeMoveSequenceBoth(
    BattlePokemon self,
    BattlePokemon opponent,
  ) {
    return self.fastMoveCooldown == 0 &&
        opponent.fastMoveCooldown == 0 &&
        _chargeMoveSequenceReady(self, opponent.fastMoveCooldown) &&
        _chargeMoveSequenceReady(opponent, self.fastMoveCooldown);
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
    if (self.fastMoveCooldown == 0) {
      self.applyFastMoveDamage(opponent);
      self.resetCooldown();
    }
    if (opponent.fastMoveCooldown == 0) {
      opponent.applyFastMoveDamage(self);
      opponent.resetCooldown();
    }
  }

  static List<BattleResult> _allBattleCombinations(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
    List<BattleTurnSnapshot> timeline,
  ) {
    List<BattleResult?> results = [
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.first,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.first,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.last,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.last,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.first,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.last,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.last,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.first,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
    ];

    /*
    if (self.selectedFastMove.duration < opponent.selectedFastMove.duration) {
      results.addAll(_selfMoveAlignmentPriorityCombinations(
          self, opponent, turn, timeline));
    } else if (opponent.selectedFastMove.duration <
        self.selectedFastMove.duration) {
      results.addAll(_opponentMoveAlignmentPriorityCombinations(
          self, opponent, turn, timeline));
    }
    */

    return results.whereType<BattleResult>().toList();
  }

  static List<BattleResult?> _selfMoveAlignmentPriorityCombinations(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
    List<BattleTurnSnapshot> timeline,
  ) {
    return [
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.first,
          prioritizeMoveAlignment: true,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.first,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.last,
          prioritizeMoveAlignment: true,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.last,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.first,
          prioritizeMoveAlignment: true,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.last,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.last,
          prioritizeMoveAlignment: true,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.first,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
    ];
  }

  static List<BattleResult?> _opponentMoveAlignmentPriorityCombinations(
    BattlePokemon self,
    BattlePokemon opponent,
    int turn,
    List<BattleTurnSnapshot> timeline,
  ) {
    return [
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.first,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.first,
          prioritizeMoveAlignment: true,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.last,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.last,
          prioritizeMoveAlignment: true,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.first,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.last,
          prioritizeMoveAlignment: true,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
      _battle(
        BattlePokemon.from(
          self,
          nextDecidedChargeMove: self.selectedChargeMoves.last,
        ),
        BattlePokemon.from(
          opponent,
          nextDecidedChargeMove: opponent.selectedChargeMoves.first,
          prioritizeMoveAlignment: true,
        ),
        turn,
        List<BattleTurnSnapshot>.from(timeline),
      ),
    ];
  }

  static void debugPrintInitialization(
    BattlePokemon self,
    BattlePokemon opponent,
  ) {
    DebugCLI.printMulti(self.name, [
      'fast    : ${self.selectedFastMove.name} : ${self.selectedFastMove.damage} : '
          'energy delta : ${self.selectedFastMove.energyDelta}',
      'charge1 : ${self.selectedChargeMoves.first.name} : ${self.selectedChargeMoves.first.damage} : '
          'energy delta : ${self.selectedChargeMoves.first.energyDelta}',
      'charge2 : ${self.selectedChargeMoves.last.name} : ${self.selectedChargeMoves.last.damage} : '
          'energy delta : ${self.selectedChargeMoves.last.energyDelta}',
      'level   : ${self.ivs.level}',
      'cp      : ${self.cp}',
      'ivs     : ${self.ivs.atk}  ${self.ivs.def}  ${self.ivs.hp}'
    ]);
    DebugCLI.printMulti(opponent.name, [
      'fast : ${opponent.selectedFastMove.name} : ${opponent.selectedFastMove.damage} : '
          'energy delta : ${opponent.selectedFastMove.energyDelta}',
      'charge1 : ${opponent.selectedChargeMoves.first.name} : ${opponent.selectedChargeMoves.first.damage} : '
          'energy delta : ${opponent.selectedChargeMoves.first.energyDelta}',
      'charge2 : ${opponent.selectedChargeMoves.last.name} : ${opponent.selectedChargeMoves.last.damage} : '
          'energy delta : ${opponent.selectedChargeMoves.last.energyDelta}',
      'level   : ${opponent.ivs.level}',
      'cp      : ${opponent.cp}',
      'ivs     : ${opponent.ivs.atk}  ${opponent.ivs.def}  ${opponent.ivs.hp}'
    ]);
  }

  static void debugPrintBattleOutcome(BattleResult results) {
    String selfOutcome;
    String opponentOutcome;
    switch (results.outcome) {
      case BattleOutcome.tie:
        selfOutcome = 'tie';
        opponentOutcome = 'tie';
        break;
      case BattleOutcome.loss:
        selfOutcome = 'loss';
        opponentOutcome = 'win';
        break;
      case BattleOutcome.win:
        selfOutcome = 'win';
        opponentOutcome = 'loss';
        break;
      case BattleOutcome.none:
        selfOutcome = 'none';
        opponentOutcome = 'none';
        break;
    }
    DebugCLI.printHeader('Outcome');
    DebugCLI.printMulti(results.self.name, [
      selfOutcome,
      'score : ${results.self.rating}',
    ]);
    DebugCLI.printMulti(results.opponent.name, [
      opponentOutcome,
      'score : ${results.opponent.rating}',
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
      'cooldown       : ${self.fastMoveCooldown}',
      '-' * (1 + DebugCLI.debugHeaderWidth),
      'next charge    : ${self.nextDecidedChargeMove.name}',
    ]);
    DebugCLI.printMulti(opponent.name, [
      'hp             : ${opponent.currentHp} / ${opponent.maxHp}',
      'energy         : ${opponent.energy}',
      'cooldown       : ${opponent.fastMoveCooldown}',
      '-' * (1 + DebugCLI.debugHeaderWidth),
      'next charge    : ${opponent.nextDecidedChargeMove.name}',
    ]);
  }
}
