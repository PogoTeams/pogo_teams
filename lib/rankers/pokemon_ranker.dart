// Local
import 'ranking_data.dart';
import '../pogo_data/pokemon.dart';
import '../pogo_data/cup.dart';
import '../modules/stats.dart';
import '../battle/pokemon_battler.dart';

class PokemonRanker {
  static PokemonRankingData rank(
    BattlePokemon self,
    Cup cup,
    List<Pokemon> opponents,
  ) {
    PokemonRankingData rankingData = PokemonRankingData(
      cupId: cup.cupId,
      pokemon: self,
    );

    for (Pokemon opponentPokemon in opponents) {
      if (self.pokemonId != opponentPokemon.pokemonId) {
        BattlePokemon opponent = BattlePokemon.fromPokemon(opponentPokemon);

        opponent.initialize(cup.cp);
        self.selectMoveset((opponent));
        opponent.selectMoveset(self);

        PokemonBattler.resetPokemon(self, opponent);

        if (!PokemonBattler.isBanned(cup.cp, opponent.pokemonId) &&
            opponent.cp >= StatsModule.cpMinimums[cup.cp]!) {
          // Lead shield scenario
          rankingData.addLeadResult(battle(self, opponent, [2, 2]));

          // Switch shield scenarios
          for (List<int> shields in PokemonRankingData.switchShieldScenarios) {
            rankingData.addSwitchResult(battle(self, opponent, shields));
          }

          // Closer shield scenarios
          for (List<int> shields in PokemonRankingData.closerShieldScenarios) {
            rankingData.addCloserResult(battle(self, opponent, shields));
          }
        }
      }
    }

    rankingData.finalize();

    return rankingData;
  }

  static BattleResult battle(
    BattlePokemon self,
    BattlePokemon opponent,
    List<int> shieldScenario,
  ) {
    self.shields = shieldScenario.first;
    opponent.shields = shieldScenario.last;

    BattleResult result = PokemonBattler.battle(self, opponent);
    PokemonBattler.resetPokemon(self, opponent);

    return result;
  }
}
