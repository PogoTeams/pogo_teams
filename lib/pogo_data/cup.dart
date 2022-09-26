import '../pogo_data/pokemon.dart';

class Cup {
  Cup({
    required this.cupId,
    required this.name,
    required this.cp,
    required this.partySize,
    required this.live,
    required this.includeFilters,
    required this.excludeFilters,
  });

  factory Cup.fromJson(Map<String, dynamic> json) {
    return Cup(
      cupId: json['cupId'] as String,
      name: json['name'] as String,
      cp: json['cp'] as int,
      partySize: json['partySize'] as int,
      live: json['live'] as bool,
      includeFilters: json.containsKey('include')
          ? List<Map<String, dynamic>>.from(json['include'])
              .map((filterJson) => CupFilter.fromJson(filterJson))
              .toList()
          : null,
      excludeFilters: json.containsKey('exclude')
          ? List<Map<String, dynamic>>.from(json['exclude'])
              .map((filterJson) => CupFilter.fromJson(filterJson))
              .toList()
          : null,
    );
  }

  bool pokemonIsAllowed(Pokemon pokemon) {
    if (includeFilters != null) {
      for (CupFilter filter in includeFilters!) {
        if (filter.contains(pokemon)) {
          return true;
        }
      }
    }

    if (excludeFilters != null) {
      for (CupFilter filter in excludeFilters!) {
        if (filter.contains(pokemon)) {
          return false;
        }
      }
    }

    return true;
  }

  final String cupId;
  final String name;
  final int cp;
  final int partySize;
  final bool live;
  final List<CupFilter>? includeFilters;
  final List<CupFilter>? excludeFilters;
}

enum FilterType { dex, pokemonId, type, tags }

class CupFilter {
  CupFilter({
    required this.filterType,
    required this.values,
  });

  factory CupFilter.fromJson(Map<String, dynamic> json) {
    FilterType filterType = _filterTypeFromString(json['filterType'] as String);
    return CupFilter(
      filterType: filterType,
      values: _valuesFromFilterType(
        filterType,
        List<String>.from(json['values']),
      ),
    );
  }

  static FilterType _filterTypeFromString(String filterTypeString) {
    switch (filterTypeString) {
      case 'dex':
        return FilterType.dex;
      case 'pokemonId':
        return FilterType.pokemonId;
      case 'type':
        return FilterType.type;
      case 'tags':
        return FilterType.tags;
    }
    return FilterType.pokemonId;
  }

  static List<dynamic> _valuesFromFilterType(
    FilterType filterType,
    List<String> jsonValues,
  ) {
    switch (filterType) {
      case FilterType.dex:
        return jsonValues.map((v) => int.parse(v)).toList();
      case FilterType.pokemonId:
        return jsonValues;
      case FilterType.type:
        return jsonValues;
      case FilterType.tags:
        return jsonValues;
    }
  }

  bool contains(Pokemon pokemon) {
    switch (filterType) {
      case FilterType.dex:
        return values.contains(pokemon.dex);
      case FilterType.pokemonId:
        return values.contains(pokemon.pokemonId);
      case FilterType.type:
        return values.contains(pokemon.typing.typeA.typeId) ||
            (!pokemon.typing.isMonoType() &&
                values.contains(pokemon.typing.typeB!.typeId));
      case FilterType.tags:
        return pokemon.tags == null
            ? false
            : pokemon.tags!.indexWhere((tag) => values.contains(tag)) != -1;
    }
  }

  final FilterType filterType;
  final List<dynamic> values;
}
