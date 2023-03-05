// Local
import 'ranking_data.dart';
import '../tools/pair.dart';
import '../pogo_objects/pokemon.dart';
import '../pogo_objects/pokemon_base.dart';
import '../pogo_objects/battle_pokemon.dart';
import '../pogo_objects/cup.dart';
import '../battle/pokemon_battler.dart';
import '../battle/battle_result.dart';
import '../modules/data/pogo_data.dart';
import '../modules/data/cups.dart';
import '../modules/data/pogo_debugging.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class PokemonRanker {
  static RankingData rankSync(
    BattlePokemon self,
    Cup cup,
    List<PokemonBase> opponents,
  ) {
    RankingData rankingData = RankingData(pokemon: self);

    for (PokemonBase opponentPokemon in opponents) {
      if (self.pokemonId != opponentPokemon.pokemonId) {
        BattlePokemon opponent = BattlePokemon.fromPokemon(opponentPokemon);

        opponent.initializeStats(cup.cp);
        self.initializeMoveset(opponent, true);
        opponent.initializeMoveset(self, true);

        self.selectedBattleFastMove.usage += 1;
        self.selectedBattleChargeMoves.first.usage += 1;
        self.selectedBattleChargeMoves.last.usage += 1;

        PokemonBattler.resetPokemon(self, opponent);

        if (opponent.cp >= Cups.cpMinimums[cup.cp]!) {
          // Lead shield scenario
          rankingData.addLeadResult(battle(self, opponent, [2, 2]));

          // Switch shield scenarios
          for (List<int> shields in RankingData.switchShieldScenarios) {
            rankingData.addSwitchResult(
                battle(self, opponent, shields), shields);
          }

          // Closer shield scenarios
          for (List<int> shields in RankingData.closerShieldScenarios) {
            rankingData.addCloserResult(
                battle(self, opponent, shields), shields);
          }
        }
      }
    }

    // Calculate final ratings for this pokemon
    rankingData.finalizeResults();

    return rankingData;
  }

  static Stream<Pair<String, double>> rankAsync(
    BattlePokemon self,
    Cup cup,
    List<CupPokemon> opponents,
    RankingData rankingData,
  ) async* {
    for (CupPokemon opponentPokemon in opponents) {
      BattlePokemon opponent = BattlePokemon.fromCupPokemon(opponentPokemon);

      opponent.initializeStats(cup.cp);
      self.initializeMoveset(opponent, false);
      opponent.initializeMoveset(self, false);

      PokemonBattler.resetPokemon(self, opponent);

      if (opponent.cp >= Cups.cpMinimums[cup.cp]!) {
        // Lead shield scenario
        rankingData.addLeadResult(battle(self, opponent, [2, 2]));

        // Switch shield scenarios
        for (List<int> shields in RankingData.switchShieldScenarios) {
          rankingData.addSwitchResult(battle(self, opponent, shields), shields);
        }

        // Closer shield scenarios
        for (List<int> shields in RankingData.closerShieldScenarios) {
          rankingData.addCloserResult(battle(self, opponent, shields), shields);
        }
      }
    }

    // Calculate final ratings for this pokemon
    rankingData.finalizeResults();
  }

  static BattleResult battle(
    BattlePokemon self,
    BattlePokemon opponent,
    List<int> shieldScenario,
  ) {
    self.currentShields = shieldScenario.first;
    opponent.currentShields = shieldScenario.last;

    BattleResult result = PokemonBattler.battle(
      self,
      opponent,
      makeTimeline: false,
    );
    PokemonBattler.resetPokemon(self, opponent);

    return result;
  }

  static void rankTesting(
    String selfId,
    String opponentId,
    int cp,
  ) {
    BattlePokemon self =
        BattlePokemon.fromPokemon(PogoData.getPokemonById(selfId));
    BattlePokemon opponent =
        BattlePokemon.fromPokemon(PogoData.getPokemonById(opponentId));

    self.initializeStats(cp);
    opponent.initializeStats(cp);
    self.initializeMoveset(opponent, true);
    opponent.initializeMoveset(self, true);

    PokemonBattler.resetPokemon(self, opponent);

    BattleResult result = PokemonBattler.battle(
      self,
      opponent,
      makeTimeline: true,
    );

    for (BattleTurnSnapshot snapshot in result.timeline!) {
      snapshot.debugPrint();
      PogoDebugging.breakpoint();
    }
  }
}
