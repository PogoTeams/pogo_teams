/*
-------------------------------------------------------------------- @PogoTeams
This enum expresses the outcome of a Pokemon battle.
-------------------------------------------------------------------------------
*/

enum BattleOutcome { win, loss, tie }

extension BattleOutcomeExt on BattleOutcome {
  String get name {
    switch (this) {
      case BattleOutcome.win:
        return 'win';
      case BattleOutcome.loss:
        return 'loss';
      case BattleOutcome.tie:
        return 'tie';
    }
  }
}
