// Local
import 'pokemon_ranker.dart';
import 'ranking_data.dart';
import '../pogo_data/pokemon.dart';
import '../pogo_data/cup.dart';
import '../tools/json_tools.dart';
import '../modules/gamemaster.dart';
import '../modules/debug_cli.dart';
import '../modules/cups.dart';

void generatePokemonRankings() async {
  final Map<String, dynamic>? snapshot =
      await JsonTools.loadJson('bin/json/niantic-snapshot');
  if (snapshot == null) return;

  Gamemaster.load(snapshot);

  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();

  for (Cup cup in Gamemaster.cups) {
    List<RankingData> rankings = [];
    List<Pokemon> cupPokemonList = Gamemaster.getCupFilteredPokemonList(cup);
    for (Pokemon pokemon in cupPokemonList) {
      BattlePokemon battlePokemon = BattlePokemon.fromPokemon(pokemon);
      battlePokemon.initialize(cup.cp);
      if (battlePokemon.cp >= Cups.cpMinimums[cup.cp]!) {
        RankingData rankingData = PokemonRanker.rank(
          battlePokemon,
          cup,
          cupPokemonList,
        );
        rankings.add(rankingData);
        debugPrintPokemonRatings(pokemon, rankingData, cup.name);
      }
    }
    writeRankings(rankings, cup.cupId);
  }

  stopwatch.stop();
  DebugCLI.print(
      'rankings finished', 'elapsed minutes : ${stopwatch.elapsed.inMinutes}');
}

void writeRankings(List<RankingData> rankings, String cupId) {
  rankings.sort((r1, r2) => r2.ratings.overall - r1.ratings.overall);
  JsonTools.writeJson(_rankingsToJson(rankings), 'bin/json/rankings/$cupId');
}

List<Map<String, dynamic>> _rankingsToJson(List<RankingData> rankings) {
  return rankings.map((ranking) => ranking.toJson()).toList();
}

void generatePokemonRankingsTest(
    String selfId, String opponentId, int cp) async {
  final Map<String, dynamic>? snapshot =
      await JsonTools.loadJson('bin/json/niantic-snapshot');
  if (snapshot == null) return;

  Gamemaster.load(snapshot);

  PokemonRanker.rankTesting(selfId, opponentId, cp);
}

void debugPrintPokemonRatings(
  Pokemon pokemon,
  RankingData rankingData,
  String cupName,
) {
  DebugCLI.printMulti(
    '${pokemon.dex} | ${pokemon.name}${(pokemon.isShadow ? ' (Shadow)' : '')}',
    [
      'overall : ${rankingData.ratings.overall}',
      'lead    : ${rankingData.ratings.lead}',
      'switch  : ${rankingData.ratings.switchRating}',
      'closer  : ${rankingData.ratings.closer}',
    ],
    footer: cupName,
  );
}
