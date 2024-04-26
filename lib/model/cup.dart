// Packages
import 'package:isar/isar.dart';
import 'package:pogo_teams/enums/rankings_categories.dart';

// Local
import 'pokemon_base.dart';
import 'pokemon.dart';
import '../modules/pokemon_types.dart';
import '../enums/cup_filter_type.dart';

part 'cup.g.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All data related to a cup or "league".
-------------------------------------------------------------------------------
*/

@Collection(accessor: 'cups')
class Cup {
  Cup({
    required this.cupId,
    required this.name,
    required this.cp,
    required this.partySize,
    required this.live,
    this.publisher,
    this.uiColor,
  });

  factory Cup.fromJson(Map<String, dynamic> json) {
    return Cup(
      cupId: json['cupId'] as String,
      name: json['name'] as String,
      cp: json['cp'] as int,
      partySize: json['partySize'] as int,
      live: json['live'] as bool,
      publisher: json['publisher'] as String?,
      uiColor: json['uiColor'],
    );
  }

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  final String cupId;
  final String name;
  final int cp;
  final int partySize;
  final bool live;
  final String? publisher;
  final String? uiColor;

  final IsarLinks<CupFilter> includeFilters = IsarLinks<CupFilter>();
  final IsarLinks<CupFilter> excludeFilters = IsarLinks<CupFilter>();
  final IsarLinks<CupPokemon> rankings = IsarLinks<CupPokemon>();

  IsarLinks<CupPokemon> getRankings() {
    if (rankings.isAttached && !rankings.isLoaded) {
      rankings.loadSync();
    }

    return rankings;
  }

  Future<IsarLinks<CupPokemon>> getRankingsAsync() async {
    if (rankings.isAttached && !rankings.isLoaded) {
      await rankings.load();
    }

    return rankings;
  }

  IsarLinks<CupFilter> getIncludeFilters() {
    if (includeFilters.isAttached && !includeFilters.isLoaded) {
      includeFilters.loadSync();
    }

    return includeFilters;
  }

  IsarLinks<CupFilter> getExcludeFilters() {
    if (excludeFilters.isAttached && !excludeFilters.isLoaded) {
      excludeFilters.loadSync();
    }

    return excludeFilters;
  }

  List<CupPokemon> getCupPokemonList(RankingsCategories rankingsCategory) {
    final List<CupPokemon> rankedPokemonList = getRankings().toList();
    _sortRankingsByCategory(rankedPokemonList, rankingsCategory);

    return rankedPokemonList;
  }

  Future<List<CupPokemon>> getCupPokemonListAsync(
      RankingsCategories rankingsCategory) async {
    final List<CupPokemon> rankedPokemonList =
        (await getRankingsAsync()).toList();
    _sortRankingsByCategory(rankedPokemonList, rankingsCategory);

    return rankedPokemonList;
  }

  void _sortRankingsByCategory(
      List<CupPokemon> rankings, RankingsCategories category) {
    switch (category) {
      case RankingsCategories.overall:
        rankings.sort((p1, p2) => p2.ratings.overall - p1.ratings.overall);
        break;
      case RankingsCategories.leads:
        rankings.sort((p1, p2) => p2.ratings.lead - p1.ratings.lead);
        break;
      case RankingsCategories.switches:
        rankings.sort(
            (p1, p2) => p2.ratings.switchRating - p1.ratings.switchRating);
        break;
      case RankingsCategories.closers:
        rankings.sort((p1, p2) => p2.ratings.closer - p1.ratings.closer);
        break;
      case RankingsCategories.dex:
        rankings.sort((p1, p2) => p1.getBase().dex - p2.getBase().dex);
        break;
      default:
        rankings.sort((p1, p2) => p2.ratings.overall - p1.ratings.overall);
        break;
    }
  }

  bool pokemonIsAllowed(PokemonBase pokemon) {
    if (getIncludeFilters().isNotEmpty) {
      for (CupFilter filter in getIncludeFilters()) {
        if (filter.contains(pokemon)) {
          return true;
        }
      }
    }

    if (getExcludeFilters().isNotEmpty) {
      for (CupFilter filter in getExcludeFilters()) {
        if (filter.contains(pokemon)) {
          return false;
        }
      }
    }

    return true;
  }

  List<String> includedTypeKeys() {
    if (getIncludeFilters().isEmpty) {
      return PokemonTypes.typeIndexMap.keys.toList();
    }

    for (CupFilter filter in getIncludeFilters()) {
      if (filter.filterType == CupFilterType.type) {
        return filter.values;
      }
    }

    return [];
  }
}

@Collection(accessor: 'cupFilters')
class CupFilter {
  CupFilter({
    required this.filterType,
    required this.values,
  });

  factory CupFilter.fromJson(Map<String, dynamic> json) {
    CupFilterType filterType =
        _filterTypeFromString(json['filterType'] as String);
    return CupFilter(
      filterType: filterType,
      values: List<String>.from(json['values']),
    );
  }

  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.ordinal)
  final CupFilterType filterType;
  final List<String> values;

  static CupFilterType _filterTypeFromString(String filterTypeString) {
    switch (filterTypeString) {
      case 'dex':
        return CupFilterType.dex;
      case 'pokemonId':
        return CupFilterType.pokemonId;
      case 'type':
        return CupFilterType.type;
      case 'tags':
        return CupFilterType.tags;
    }
    return CupFilterType.pokemonId;
  }

  bool contains(PokemonBase pokemon) {
    switch (filterType) {
      case CupFilterType.dex:
        return values.contains(pokemon.dex.toString());
      case CupFilterType.pokemonId:
        return values.contains(pokemon.pokemonId);
      case CupFilterType.type:
        return values.contains(pokemon.typing.typeA.typeId) ||
            (!pokemon.typing.isMonoType() &&
                values.contains(pokemon.typing.typeB!.typeId));
      case CupFilterType.tags:
        return pokemon.tags == null
            ? false
            : pokemon.tags!.indexWhere((tag) => values.contains(tag)) != -1;
    }
  }
}
