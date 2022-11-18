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
  //KeyMatchups keyLeads = KeyMatchups();
  //KeyMatchups keySwitches = KeyMatchups();
  //KeyMatchups keyClosers = KeyMatchups();
  int leadBattleCount = 0;
  int switchBattleCount = 0;
  int closerBattleCount = 0;

  Map<String, dynamic> toJson() {
    FastMove idealFastMove = pokemon.getFastMoves().reduce((move1, move2) {
      return (move1.usage > move2.usage ? move1 : move2);
    });
    //pokemon.chargeMoves.sort((move1, move2) => move2.usage - move1.usage);

    return {
      'pokemonId': pokemon.pokemonId,
      'ratings': ratings.toJson(),
      'idealMoveset': {
        'fastMove': idealFastMove.moveId,
        /*
        'chargeMoves': (pokemon.chargeMoves.length > 1
            ? [pokemon.chargeMoves[0].moveId, pokemon.chargeMoves[1].moveId]
            : [pokemon.chargeMoves[0].moveId])
            */
      },
      //'keyLeads': keyLeads.toJson(),
      //'keySwitches': keySwitches.toJson(),
      //'keyClosers': keyClosers.toJson(),
    };
  }

  void addLeadResult(BattleResult result) {
    int leadRating =
        ((result.self.currentRating + _shieldRating(result, [2, 2])) *
                Globals.pokemonRatingMagnitude)
            .floor();

    ratings.lead += leadRating;
    //keyLeads.update(result);
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
    //keySwitches.update(result);
    ++switchBattleCount;
  }

  void addCloserResult(BattleResult result, List<int> shieldScenario) {
    int closerRating =
        ((result.self.currentRating + _shieldRating(result, shieldScenario)) *
                Globals.pokemonRatingMagnitude)
            .floor();

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
          (r1, r2) => (r2.self.currentRating > r1.self.currentRating ? -1 : 1));
    } else if (result.outcome == BattleOutcome.loss) {
      shelfResult(
          lossShelf,
          result,
          (r1, r2) =>
              (r2.opponent.currentRating > r1.opponent.currentRating ? -1 : 1));
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
