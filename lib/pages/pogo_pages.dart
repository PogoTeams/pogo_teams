// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'account/pogo_account.dart';
import 'teams/teams.dart';
import 'rankings.dart';
import '../modules/ui/sizing.dart';

enum PogoPages { teams, rankings, account }

extension PogoPagesExt on PogoPages {
  String get displayName {
    switch (this) {
      case PogoPages.teams:
        return 'Teams';
      case PogoPages.rankings:
        return 'Rankings';
      case PogoPages.account:
        return 'Account';
    }
  }

  Widget get icon {
    switch (this) {
      case PogoPages.teams:
        return Icon(
          Icons.dangerous,
          size: Sizing.icon3,
        );
      case PogoPages.rankings:
        return Icon(
          Icons.bar_chart,
          size: Sizing.icon3,
        );
      case PogoPages.account:
        return Icon(
          Icons.account_circle,
          size: Sizing.icon3,
        );
    }
  }

  Widget get page {
    switch (this) {
      case PogoPages.teams:
        return const Teams();
      case PogoPages.rankings:
        return const Rankings();
      case PogoPages.account:
        return const PogoAccount();
    }
  }
}
