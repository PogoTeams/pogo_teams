// Local
import '../pogo_data/pokemon.dart';
import '../pogo_data/move.dart';
import '../battle/pokemon_battler.dart';
import '../battle/battle_result.dart';
import '../modules/globals.dart';

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
  //KeyMatchups keyLeads = KeyMatchups();
  //KeyMatchups keySwitches = KeyMatchups();
  //KeyMatchups keyClosers = KeyMatchups();
  int leadBattleCount = 0;
  int switchBattleCount = 0;
  int closerBattleCount = 0;

  Map<String, dynamic> toJson() {
    FastMove idealFastMove = pokemon.fastMoves.reduce((move1, move2) {
      return (move1.usage > move2.usage ? move1 : move2);
    });
    pokemon.chargeMoves.sort((move1, move2) => move2.usage - move1.usage);

    return {
      'pokemonId': pokemon.pokemonId,
      'ratings': ratings.toJson(),
      'idealMoveset': {
        'fastMove': idealFastMove.moveId,
        'chargeMoves': (pokemon.chargeMoves.length > 1
            ? [pokemon.chargeMoves[0].moveId, pokemon.chargeMoves[1].moveId]
            : [pokemon.chargeMoves[0].moveId])
      },
      //'keyLeads': keyLeads.toJson(),
      //'keySwitches': keySwitches.toJson(),
      //'keyClosers': keyClosers.toJson(),
    };
  }

  void addLeadResult(BattleResult result) {
    int leadRating = ((result.self.rating + _shieldRating(result, [2, 2])) *
            Globals.pokemonRatingMagnitude)
        .floor();

    if (result.outcome == BattleOutcome.win) {}

    ratings.overall += leadRating;
    ratings.lead += leadRating;
    //keyLeads.update(result);
    ++leadBattleCount;
  }

  void addSwitchResult(BattleResult result, List<int> shieldScenario) {
    int switchRating = ((result.self.rating *
                    .5 *
                    result.self.getOffenseEffectivenessFromTyping(
                        result.opponent.typing) /
                    result.opponent
                        .getOffenseEffectivenessFromTyping(result.self.typing) +
                _shieldRating(result, shieldScenario)) *
            Globals.pokemonRatingMagnitude)
        .floor();

    if (result.outcome == BattleOutcome.win) {}

    ratings.overall += switchRating;
    ratings.switchRating += switchRating;
    //keySwitches.update(result);
    ++switchBattleCount;
  }

  void addCloserResult(BattleResult result, List<int> shieldScenario) {
    int closerRating =
        ((result.self.rating + _shieldRating(result, shieldScenario)) *
                Globals.pokemonRatingMagnitude)
            .floor();

    ratings.overall += closerRating;
    ratings.closer += closerRating;
    //keyClosers.update(result);
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

  void averageRatings() {
    if (leadBattleCount != 0) {
      ratings.lead = (ratings.lead / leadBattleCount).floor();
    }

    if (switchBattleCount != 0) {
      ratings.switchRating = (ratings.switchRating / switchBattleCount).floor();
    }

    if (closerBattleCount != 0) {
      ratings.closer = (ratings.closer / closerBattleCount).floor();
    }

    ratings.overall =
        ((ratings.lead + ratings.switchRating + ratings.closer) / 3).floor();
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
      shelfResult(winShelf, result,
          (r1, r2) => (r2.self.rating > r1.self.rating ? -1 : 1));
    } else if (result.outcome == BattleOutcome.loss) {
      shelfResult(lossShelf, result,
          (r1, r2) => (r2.opponent.rating > r1.opponent.rating ? -1 : 1));
    }
  }

  static void shelfResult(
    List<BattleResult> shelf,
    BattleResult result,
    int Function(BattleResult, BattleResult) sort,
  ) {
    shelf.add(result);
    shelf.sort(sort);
    if (shelf.length > shelfSize) shelf.removeLast();
  }
}
