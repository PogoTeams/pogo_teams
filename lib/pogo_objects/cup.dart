// Packages
import 'package:isar/isar.dart';

// Local
import 'pokemon.dart';
import '../modules/data/pokemon_types.dart';
import '../enums/cup_filter_type.dart';

part 'cup.g.dart';

@Collection(accessor: 'cups')
class Cup {
  Cup({
    required this.cupId,
    required this.name,
    required this.cp,
    required this.partySize,
    required this.live,
    this.publisher,
  });

  factory Cup.fromJson(Map<String, dynamic> json) {
    return Cup(
      cupId: json['cupId'] as String,
      name: json['name'] as String,
      cp: json['cp'] as int,
      partySize: json['partySize'] as int,
      live: json['live'] as bool,
      publisher: json['publisher'] as String?,
    );
  }

  Id id = Isar.autoIncrement;

  final String cupId;
  final String name;
  final int cp;
  final int partySize;
  final bool live;
  final String? publisher;

  IsarLinks<CupFilter> includeFilters = IsarLinks<CupFilter>();
  IsarLinks<CupFilter> excludeFilters = IsarLinks<CupFilter>();
  IsarLinks<RankedPokemon> rankings = IsarLinks<RankedPokemon>();

  bool pokemonIsAllowed(Pokemon pokemon) {
    if (includeFilters.isNotEmpty) {
      for (CupFilter filter in includeFilters) {
        if (filter.contains(pokemon)) {
          return true;
        }
      }
    }

    if (excludeFilters.isNotEmpty) {
      for (CupFilter filter in excludeFilters) {
        if (filter.contains(pokemon)) {
          return false;
        }
      }
    }

    return true;
  }

  List<String> includedTypeKeys() {
    if (includeFilters.isEmpty) return PokemonTypes.typeIndexMap.keys.toList();

    for (CupFilter filter in includeFilters) {
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

  bool contains(Pokemon pokemon) {
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
