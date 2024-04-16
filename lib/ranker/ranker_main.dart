// Dart
import 'dart:math';

// Local
import 'pokemon_ranker.dart';
import 'ranking_data.dart';
import '../pogo_objects/pokemon_base.dart';
import '../pogo_objects/battle_pokemon.dart';
import '../pogo_objects/cup.dart';
import '../tools/json_tools.dart';
import '../modules/data/pogo_repository.dart';
import '../modules/data/pogo_debugging.dart';
import '../modules/data/cups.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

Future<void> generatePokemonRankings() async {
  final Map<String, dynamic>? snapshot =
      await JsonTools.loadJson('bin/json/niantic-snapshot');
  if (snapshot == null) return;

  await PogoRepository.init();
  await PogoRepository.clear();
  await PogoRepository.rebuildFromJson(snapshot);

  Stopwatch stopwatch = Stopwatch();
  stopwatch.start();

  for (Cup cup in PogoRepository.getCupsSync()) {
    int bestOverallRating = 0;
    int bestLeadRating = 0;
    int bestSwitchRating = 0;
    int bestCloserRating = 0;

    List<RankingData> rankings = [];
    List<PokemonBase> cupPokemonList =
        PogoRepository.getCupFilteredPokemonList(cup);

    for (PokemonBase pokemon in cupPokemonList) {
      BattlePokemon battlePokemon = BattlePokemon.fromPokemon(pokemon);
      battlePokemon.initializeStats(cup.cp);
      if (battlePokemon.cp >= Cups.cpMinimums[cup.cp]!) {
        RankingData rankingData = PokemonRanker.rankCli(
          battlePokemon,
          cup,
          cupPokemonList,
        );

        rankings.add(rankingData);
        bestOverallRating = max(bestOverallRating, rankingData.ratings.overall);
        bestLeadRating = max(bestLeadRating, rankingData.ratings.lead);
        bestSwitchRating =
            max(bestSwitchRating, rankingData.ratings.switchRating);
        bestCloserRating = max(bestCloserRating, rankingData.ratings.closer);

        debugPrintPokemonRatings(pokemon, rankingData, cup.name);
      }
    }

    rankings.sort((r1, r2) => r2.ratings.overall - r1.ratings.overall);

    await writeRankings(
      rankings,
      bestOverallRating,
      bestLeadRating,
      bestSwitchRating,
      bestCloserRating,
      cup.cupId,
    );
    break;
  }

  stopwatch.stop();
  PogoDebugging.print(
      'rankings finished', 'elapsed minutes : ${stopwatch.elapsed.inMinutes}');
}

Future<void> writeRankings(
  List<RankingData> rankings,
  int bestOverallRating,
  int bestLeadRating,
  int bestSwitchRating,
  int bestCloserRating,
  String cupId,
) async {
  for (RankingData r in rankings) {
    r.ratings.overall = (r.ratings.overall / bestOverallRating * 100).floor();
    r.ratings.lead = (r.ratings.lead / bestLeadRating * 100).floor();
    r.ratings.switchRating =
        (r.ratings.switchRating / bestSwitchRating * 100).floor();
    r.ratings.closer = (r.ratings.closer / bestCloserRating * 100).floor();
  }

  await JsonTools.writeJson(
    rankings.map((ranking) => ranking.toJson()).toList(),
    'bin/json/rankings/$cupId',
  );
}

void generatePokemonRankingsTest(
    String selfId, String opponentId, int cp) async {
  final Map<String, dynamic>? snapshot =
      await JsonTools.loadJson('bin/json/niantic-snapshot');
  if (snapshot == null) return;

  await PogoRepository.init();
  await PogoRepository.clear();
  await PogoRepository.rebuildFromJson(snapshot);

  PokemonRanker.rankTesting(selfId, opponentId, cp);
}

void debugPrintPokemonRatings(
  PokemonBase pokemon,
  RankingData rankingData,
  String cupName,
) {
  PogoDebugging.printMulti(
    '${pokemon.dex} | ${pokemon.name}${(pokemon.isShadow() ? ' (Shadow)' : '')}',
    [
      'overall : ${rankingData.ratings.overall}',
      'lead    : ${rankingData.ratings.lead}',
      'switch  : ${rankingData.ratings.switchRating}',
      'closer  : ${rankingData.ratings.closer}',
    ],
    footer: cupName,
  );
}
