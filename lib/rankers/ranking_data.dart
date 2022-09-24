import 'dart:math';

import '../pogo_data/pokemon.dart';
import '../pogo_data/move.dart';
import '../battle/pokemon_battler.dart';
import '../../../modules/debug_cli.dart';

class PokemonRankingData {
  PokemonRankingData({
    required this.cupId,
    required BattlePokemon pokemon,
  }) : pokemonId = pokemon.pokemonId {
    for (var fastMove in pokemon.fastMoves) {
      moveUsage[fastMove.moveId] = MoveUsage(moveId: fastMove.moveId);
    }
    for (var chargeMove in pokemon.chargeMoves) {
      moveUsage[chargeMove.moveId] = MoveUsage(moveId: chargeMove.moveId);
    }
  }

  static const List<int> leadShieldScenario = [2, 2];

  static const List<List<int>> switchShieldScenarios = [
    [0, 1],
    [1, 0],
    [0, 2],
    [2, 0],
    [1, 2],
    [2, 1],
  ];

  static const List<List<int>> closerShieldScenarios = [
    [0, 0],
    [1, 1],
  ];

  final String cupId;
  final String pokemonId;
  final List<BattleResult> _leadResults = [];
  final List<BattleResult> _switchResults = [];
  final List<BattleResult> _closerResults = [];
  final Map<String, MoveUsage> moveUsage = {};

  Ratings ratings = Ratings();
  KeyMatchups keyLeads = KeyMatchups();
  KeyMatchups keySwitches = KeyMatchups();
  KeyMatchups keyClosers = KeyMatchups();

  Map<String, dynamic> toJson() {
    return {
      'pokemonId': pokemonId,
      'moveUsage': moveUsage.values
          .where((usage) => usage.usageCount > 0)
          .map((usage) => usage.toJson())
          .toList(),
      'ratings': ratings.toJson(),
    };
  }

  void _updateMoveUsage(BattleResult results) {
    FastMove selectedFastMove = results.self.selectedFastMove;
    ChargeMove selectedChargeMove1 = results.self.selectedChargeMoves.first;
    ChargeMove selectedChargeMove2 = results.self.selectedChargeMoves.last;

    moveUsage[selectedFastMove.moveId]!.updateUsage(selectedFastMove);
    if (!selectedChargeMove1.isNone()) {
      moveUsage[selectedChargeMove1.moveId]!.updateUsage(selectedChargeMove1);
    }
    if (!selectedChargeMove2.isNone()) {
      moveUsage[selectedChargeMove2.moveId]!.updateUsage(selectedChargeMove2);
    }
  }

  void addLeadResult(BattleResult result) {
    _leadResults.add(result);
    _updateMoveUsage(result);

    ratings.lead += result.self.rating;
    ratings.overall += result.self.rating;
  }

  void addSwitchResult(BattleResult result) {
    _switchResults.add(result);
    _updateMoveUsage(result);

    ratings.switchRating += (result.self.rating *
            result.self
                .getOffenseEffectivenessFromTyping(result.opponent.typing) /
            result.opponent
                .getOffenseEffectivenessFromTyping(result.self.typing))
        .floor();
    ratings.overall += result.self.rating;
  }

  void addCloserResult(BattleResult result) {
    _closerResults.add(result);
    _updateMoveUsage(result);

    ratings.closer += result.self.rating +
        (result.self.currentHp * result.self.stats.def / 1000).floor();
    ratings.overall += result.self.rating;
  }

  void finalize() {
    _averageRatings();
    _sortBattleResults();
  }

  void _averageRatings() {
    if (_leadResults.isNotEmpty) {
      ratings.lead = (ratings.lead / _leadResults.length).floor();
    }

    if (_switchResults.isNotEmpty) {
      ratings.switchRating =
          (ratings.switchRating / _switchResults.length).floor();
    }

    if (_closerResults.isNotEmpty) {
      ratings.closer = (ratings.closer / _closerResults.length).floor();
    }

    ratings.overall =
        ((ratings.lead + ratings.switchRating + ratings.closer) / 3).floor();
  }

  void _sortBattleResults() {
    _leadResults.sort((r1, r2) => r2.self.rating - r1.self.rating);
    _switchResults.sort((r1, r2) => r2.self.rating - r1.self.rating);
    _closerResults.sort((r1, r2) => r2.self.rating - r1.self.rating);
  }

  void _populateMatchups() {
    keyLeads.initialize(_leadResults);
    keySwitches.initialize(_switchResults);
    keyClosers.initialize(_closerResults);
  }
}

class BattleResult {
  BattleResult({
    required this.self,
    required this.opponent,
    required this.timeline,
  }) {
    self.rating = (self.currentHp / self.maxHp * 1000).floor();
    opponent.rating = (opponent.currentHp / opponent.maxHp * 1000).floor();
    if (self.currentHp > 0) {
      outcome = BattleOutcome.win;
      opponent.rating = (self.rating / 2).floor();
    } else if (opponent.currentHp > 0) {
      outcome = BattleOutcome.loss;
      self.rating = (opponent.rating / 2).floor();
    } else {
      outcome = BattleOutcome.tie;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'opponent': {
        'pokemonId': opponent.pokemonId,
        'rating': opponent.rating,
        'selectedFastMove': opponent.selectedFastMove.moveId,
        'selectedChargeMoves': [
          opponent.selectedChargeMoves.first.moveId,
          opponent.selectedChargeMoves.last.moveId,
        ],
      },
      'outcome': battleOutcomeString,
      'rating': self.rating,
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
  List<BattleTurnSnapshot> timeline;

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
    for (var snapshot in timeline) {
      snapshot.debugPrint();
      DebugCLI.breakPoint();
    }
  }
}

class MoveUsage {
  MoveUsage({required this.moveId});

  final String moveId;
  final List<num> damages = [];
  final List<num> ratings = [];
  int usageCount = 0;

  Map<String, dynamic> toJson() {
    return {
      'moveId': moveId,
      'averageRating': averageRating,
      'averageDamage': averageDamage,
      'usageCount': usageCount,
    };
  }

  num get averageDamage {
    if (damages.isEmpty) return 0;
    return (damages.reduce((value, element) => value + element) /
            damages.length)
        .round();
  }

  num get averageRating {
    if (ratings.isEmpty) return 0;
    return (ratings.reduce((value, element) => value + element) /
            ratings.length)
        .round();
  }

  void updateUsage(Move move) {
    damages.add(move.damage);
    ratings.add(move.rating);
    usageCount += 1;
  }
}

class Ratings {
  int overall = 0;
  int lead = 0;
  int switchRating = 0;
  int closer = 0;

  Map<String, int> toJson() {
    return {
      'overall': overall,
      'lead': lead,
      'switch': switchRating,
      'closer': closer,
    };
  }
}

class KeyMatchups {
  late List<BattleResult> losses;
  late List<BattleResult> wins;

  Map<String, dynamic> toJson() {
    return {
      'keyLosses': losses
          .getRange(max(0, losses.length - 11), max(0, losses.length - 1))
          .toList(),
      'keyWins': wins.getRange(0, 9).toList(),
    };
  }

  void initialize(List<BattleResult> sortedResults) {
    losses = sortedResults
        .where((result) => result.outcome == BattleOutcome.loss)
        .toList();
    wins = sortedResults
        .where((result) => result.outcome == BattleOutcome.win)
        .toList();
  }
}
