// Dart
import 'dart:math';

// Local
import '../pogo_objects/battle_pokemon.dart';
import '../pogo_objects/move.dart';
import '../pogo_objects/ratings.dart';
import '../enums/battle_outcome.dart';
import '../battle/battle_result.dart';
import '../modules/data/globals.dart';
import '../modules/data/pokemon_types.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class RankingData {
  RankingData({required this.pokemon});

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

  final BattlePokemon pokemon;

  Ratings ratings = Ratings();
  KeyMatchups keyLeads = KeyMatchups();
  KeyMatchups keySwitches = KeyMatchups();
  KeyMatchups keyClosers = KeyMatchups();
  int leadBattleCount = 0;
  int switchBattleCount = 0;
  int closerBattleCount = 0;
  FastMove? idealFastMove;
  ChargeMove? idealChargeMoveL;
  ChargeMove? idealChargeMoveR;

  Map<String, dynamic> toJson() {
    return {
      'pokemonId': pokemon.pokemonId,
      'ratings': ratings.toJson(),
      'idealMoveset': {
        'fastMove': idealFastMove?.moveId,
        'chargeMoves': (idealChargeMoveR == null
            ? [idealChargeMoveL?.moveId]
            : [
                idealChargeMoveL?.moveId,
                idealChargeMoveR!.moveId,
              ]),
      },
      'keyLeads': keyLeads.toJson(),
      'keySwitches': keySwitches.toJson(),
      'keyClosers': keyClosers.toJson(),
    };
  }

  void addLeadResult(BattleResult result) {
    int leadRating =
        ((result.self.currentRating + _shieldRating(result, [2, 2])) *
                Globals.pokemonRatingMagnitude)
            .floor();

    ratings.lead += leadRating;
    keyLeads.update(result);
    ++leadBattleCount;
  }

  void addSwitchResult(BattleResult result, List<int> shieldScenario) {
    int switchRating = ((result.self.currentRating *
                    .5 *
                    PokemonTypes.getOffenseEffectivenessFromTyping(
                        result.self.moveset(), result.opponent.typing) /
                    PokemonTypes.getOffenseEffectivenessFromTyping(
                        result.opponent.moveset(), result.self.typing) +
                _shieldRating(result, shieldScenario)) *
            Globals.pokemonRatingMagnitude)
        .floor();

    ratings.switchRating += switchRating;
    keySwitches.update(result);
    ++switchBattleCount;
  }

  void addCloserResult(BattleResult result, List<int> shieldScenario) {
    int closerRating =
        ((result.self.currentRating + _shieldRating(result, shieldScenario)) *
                Globals.pokemonRatingMagnitude)
            .floor();

    ratings.closer += closerRating;
    keyClosers.update(result);
    ++closerBattleCount;
  }

  num _shieldRating(
    BattleResult result,
    List<int> shieldScenario,
  ) {
    if (result.outcome == BattleOutcome.loss) return 0;
    return (shieldScenario[1] - result.opponent.currentShields) *
            Globals.winShieldMultiplier +
        result.self.currentShields * Globals.winShieldMultiplier;
  }

  void finalizeResults() {
    if (leadBattleCount != 0) {
      ratings.lead = (.25 * ratings.lead / leadBattleCount).floor();
    }

    if (switchBattleCount != 0) {
      ratings.switchRating =
          (.5 * ratings.switchRating / switchBattleCount).floor();
    }

    if (closerBattleCount != 0) {
      ratings.closer = (ratings.closer / closerBattleCount).floor();
    }

    ratings.overall =
        ((ratings.lead + ratings.switchRating + ratings.closer) / 3).floor();

    // Determine the best moveset based on usage
    idealFastMove = pokemon.battleFastMoves.reduce((move1, move2) {
      return (move1.usage > move2.usage ? move1 : move2);
    });

    idealChargeMoveL = pokemon.battleChargeMoves.reduce((move1, move2) {
      return (move1.usage > move2.usage ? move1 : move2);
    });

    if (idealChargeMoveL != null && pokemon.battleChargeMoves.length > 1) {
      idealChargeMoveR = pokemon.battleChargeMoves
          .where((move) => !move.isSameMove(idealChargeMoveL!))
          .reduce((move1, move2) {
        return (move1.usage > move2.usage ? move1 : move2);
      });
    }

    // Determine the best and worst matchups
    keyLeads.finalizeResults();
    keySwitches.finalizeResults();
    keyClosers.finalizeResults();
  }
}

class KeyMatchups {
  static const shelfSize = 10;

  List<BattleResult> lossShelf = [];
  List<BattleResult> winShelf = [];

  Map<String, dynamic> toJson() {
    return {
      'wins': winShelf.map((result) => result.toJson()).toList(),
      'losses': lossShelf.map((result) => result.toJson()).toList(),
    };
  }

  void update(BattleResult result) {
    if (result.outcome == BattleOutcome.win) {
      winShelf.add(result);
    } else if (result.outcome == BattleOutcome.loss) {
      lossShelf.add(result);
    }
  }

  void finalizeResults() {
    if (winShelf.isNotEmpty) {
      winShelf.sort(
          (r1, r2) => (r2.self.currentRating > r1.self.currentRating ? -1 : 1));

      winShelf = winShelf.getRange(0, shelfSize).toList();
    }

    if (lossShelf.isNotEmpty) {
      lossShelf.sort(
          (r1, r2) => (r2.self.currentRating > r1.self.currentRating ? -1 : 1));

      lossShelf =
          lossShelf.getRange(0, min(lossShelf.length, shelfSize)).toList();
    }
  }
}
