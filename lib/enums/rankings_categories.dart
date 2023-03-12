/*
-------------------------------------------------------------------- @PogoTeams
This enum expresses different categories for how Pokemon are ranked in a cup.
-------------------------------------------------------------------------------
*/

enum RankingsCategories { overall, leads, switches, closers, dex }

extension RankingsCategoriesExt on RankingsCategories {
  String get displayName {
    switch (this) {
      case RankingsCategories.overall:
        return 'overall';
      case RankingsCategories.leads:
        return 'leads';
      case RankingsCategories.switches:
        return 'switches';
      case RankingsCategories.closers:
        return 'closers';
      case RankingsCategories.dex:
        return 'dex';
    }
  }
}
