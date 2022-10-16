// Local
import 'pokemon_battler.dart';
import '../game_objects/pokemon.dart';
import '../modules/data/debug_cli.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class BattleResult {
  BattleResult({
    required this.self,
    required this.opponent,
    required this.timeline,
  }) {
    num selfRating =
        self.currentHpRatio * self.chargeDPE + opponent.damageRecievedRatio;
    num opponentRating =
        opponent.currentHpRatio * opponent.chargeDPE + self.damageRecievedRatio;

    if (self.currentHp > 0) {
      outcome = BattleOutcome.win;
    } else if (opponent.currentHp > 0) {
      outcome = BattleOutcome.loss;
    } else {
      outcome = BattleOutcome.tie;
      selfRating = 1;
      opponentRating = 1;
    }
    self.currentRating = selfRating;
    opponent.currentRating = opponentRating;
  }

  Map<String, dynamic> toJson() {
    return {
      'opponent': {
        'pokemonId': opponent.pokemonId,
        'rating': opponent.currentRating,
        'selectedFastMove': opponent.selectedFastMove.moveId,
        'selectedChargeMoves': [
          opponent.selectedChargeMoves.first.moveId,
          opponent.selectedChargeMoves.last.moveId,
        ],
      },
      'outcome': battleOutcomeString,
      'rating': self.currentRating,
      'selectedFastMove': self.selectedFastMove.moveId,
      'selectedChargeMoves': [
        self.selectedChargeMoves.first.moveId,
        self.selectedChargeMoves.last.moveId,
      ],
    };
  }

  final BattlePokemon self;
  final BattlePokemon opponent;
  BattleOutcome outcome = BattleOutcome.none;
  List<BattleTurnSnapshot>? timeline;

  num get ratingDifference {
    return self.currentRating - opponent.currentRating;
  }

  String get battleOutcomeString {
    switch (outcome) {
      case BattleOutcome.loss:
        return 'loss';
      case BattleOutcome.tie:
        return 'tie';
      case BattleOutcome.win:
        return 'win';
      case BattleOutcome.none:
        return 'none';
    }
  }

  void debugPrintTimeline() {
    if (timeline == null) return;
    for (var snapshot in timeline!) {
      snapshot.debugPrint();
      DebugCLI.breakpoint();
    }
  }
}
