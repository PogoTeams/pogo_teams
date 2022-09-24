// Local
import 'ranking_data.dart';
import '../pogo_data/pokemon.dart';
import '../pogo_data/cup.dart';
import '../rankers/pokemon_ranker.dart';
import '../tools/json_tools.dart';
import '../battle/pokemon_battler.dart';
import '../modules/gamemaster.dart';
import '../modules/debug_cli.dart';
import '../modules/stats.dart';

void generatePokemonRankings() async {
  final Map<String, dynamic>? snapshot =
      await JsonTools.loadJson('bin/json/niantic-snapshot');
  if (snapshot == null) return;

  GameMaster.load(snapshot);

  for (Cup cup in GameMaster.cups) {
    List<Pokemon> cupPokemonList = GameMaster.getCupFilteredPokemonList(cup);
    for (Pokemon pokemon in cupPokemonList) {
      BattlePokemon battlePokemon = BattlePokemon.fromPokemon(pokemon);
      battlePokemon.initialize(cup.cp);
      if (!PokemonBattler.isBanned(cup.cp, battlePokemon.pokemonId) &&
          battlePokemon.cp >= StatsModule.cpMinimums[cup.cp]!) {
        PokemonRankingData rankingData = PokemonRanker.rank(
          battlePokemon,
          cup,
          cupPokemonList,
        );
        debugPrintPokemonRatings(pokemon, rankingData);
      }
    }
  }
}

void debugPrintPokemonRatings(Pokemon pokemon, PokemonRankingData rankingData) {
  DebugCLI.printMulti('${pokemon.dex} | ${pokemon.name}', [
    'overall : ${rankingData.ratings.overall}',
    'lead    : ${rankingData.ratings.lead}',
    'switch  : ${rankingData.ratings.switchRating}',
    'closer  : ${rankingData.ratings.closer}',
  ]);
}
