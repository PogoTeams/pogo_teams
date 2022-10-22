enum PokemonFilters { overall, leads, switches, closers, dex }

extension RankingsCategoriesExt on PokemonFilters {
  String get displayName {
    switch (this) {
      case PokemonFilters.overall:
        return 'overall';
      case PokemonFilters.leads:
        return 'leads';
      case PokemonFilters.switches:
        return 'switches';
      case PokemonFilters.closers:
        return 'closers';
      case PokemonFilters.dex:
        return 'dex';
    }
  }
}
