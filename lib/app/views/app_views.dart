// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'rankings.dart';
import 'battle_logs.dart';
import 'teams.dart';
import 'settings.dart';
import 'tags.dart';

/*
-------------------------------------------------------------------- @PogoTeams
An enumeration to express the identity of all top-level pages in the app.
-------------------------------------------------------------------------------
*/

enum AppViews {
  teams(
    displayName: 'Teams',
    icon: Icons.catching_pokemon_rounded,
    page: Teams(),
  ),
  tags(
    displayName: 'Tags',
    icon: Icons.tag_rounded,
    page: Tags(),
  ),
  battleLogs(
    displayName: 'Battle Logs',
    icon: Icons.query_stats_rounded,
    page: BattleLogs(),
  ),
  rankings(
    displayName: 'Rankings',
    icon: Icons.bar_chart_rounded,
    page: Rankings(),
  ),
  sync(
    displayName: 'Sync Pogo Data',
    icon: Icons.sync_rounded,
    page: Rankings(),
  ),
  settings(
    displayName: 'Settings',
    icon: Icons.settings_rounded,
    page: Settings(),
  );

  const AppViews({
    required this.displayName,
    required this.icon,
    required this.page,
  });

  final String displayName;
  final IconData icon;
  final Widget page;

  static const AppViews defaultView = teams;

  static fromIndex(int index) {
    switch (index) {
      case 0:
        return AppViews.teams;
      case 1:
        return AppViews.tags;
      case 2:
        return AppViews.battleLogs;
      case 3:
        return AppViews.rankings;
      case 4:
        return AppViews.sync;
      case 5:
        return AppViews.settings;
    }

    return AppViews.teams;
  }
}
