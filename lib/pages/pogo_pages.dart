// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'rankings.dart';
import 'battle_logs.dart';
import 'teams/teams.dart';
import 'drive_backup.dart';
import 'settings.dart';
import '../modules/ui/sizing.dart';

enum PogoPages { teams, battleLogs, rankings, sync, driveBackup, settings }

extension PogoPagesExt on PogoPages {
  String get displayName {
    switch (this) {
      case PogoPages.teams:
        return 'Teams';
      case PogoPages.battleLogs:
        return 'Battle Logs';
      case PogoPages.rankings:
        return 'Rankings';
      case PogoPages.sync:
        return 'Sync Pogo Data';
      case PogoPages.driveBackup:
        return 'Google Drive Backup';
      case PogoPages.settings:
        return 'Settings';
    }
  }

  Widget get icon {
    switch (this) {
      case PogoPages.teams:
        return Icon(
          Icons.catching_pokemon,
          size: Sizing.icon3,
        );
      case PogoPages.battleLogs:
        return Icon(
          Icons.query_stats,
          size: Sizing.icon3,
        );
      case PogoPages.rankings:
        return Icon(
          Icons.bar_chart,
          size: Sizing.icon3,
        );
      case PogoPages.sync:
        return Icon(
          Icons.sync,
          size: Sizing.icon3,
        );
      case PogoPages.driveBackup:
        return Icon(
          Icons.drive_file_move,
          size: Sizing.icon3,
        );
      case PogoPages.settings:
        return Icon(
          Icons.settings,
          size: Sizing.icon3,
        );
    }
  }

  Widget get page {
    switch (this) {
      case PogoPages.teams:
        return const Teams();
      case PogoPages.battleLogs:
        return const BattleLogs();
      case PogoPages.rankings:
        return const Rankings();
      case PogoPages.sync:
        return const Rankings();
      case PogoPages.driveBackup:
        return const DriveBackup();
      case PogoPages.settings:
        return const Settings();
    }
  }
}
