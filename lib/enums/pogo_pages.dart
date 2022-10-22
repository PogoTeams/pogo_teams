// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../pages/pogo_account.dart';
import '../pages/teams/teams.dart';
import '../pages/rankings.dart';
import '../modules/ui/sizing.dart';

enum PogoPages { account, teams, rankings }

extension PogoPagesExt on PogoPages {
  String get displayName {
    switch (this) {
      case PogoPages.account:
        return 'Account';
      case PogoPages.teams:
        return 'Teams';
      case PogoPages.rankings:
        return 'Rankings';
    }
  }

  Widget get icon {
    switch (this) {
      case PogoPages.account:
        return Icon(
          Icons.login,
          size: Sizing.h2 * 1.5,
        );
      case PogoPages.teams:
        return Image.asset(
          'assets/pokeball_icon.png',
          width: Sizing.h2 * 1.2,
        );
      case PogoPages.rankings:
        return Icon(
          Icons.bar_chart,
          size: Sizing.h2 * 1.5,
        );
    }
  }

  Widget get page {
    switch (this) {
      case PogoPages.account:
        return const PogoAccount();
      case PogoPages.teams:
        return const Teams();
      case PogoPages.rankings:
        return const Rankings();
    }
  }
}
