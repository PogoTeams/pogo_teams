import 'package:hive_flutter/hive_flutter.dart';

// Local
import '../enums/rankings_categories.dart';

class Ratings {
  Ratings({
    this.overall = 0,
    this.lead = 0,
    this.switchRating = 0,
    this.closer = 0,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      overall: json['overall'],
      lead: json['lead'],
      switchRating: json['switch'],
      closer: json['closer'],
    );
  }

  Map<String, int> toJson() {
    return {
      'overall': overall,
      'lead': lead,
      'switch': switchRating,
      'closer': closer,
    };
  }

  int overall;
  int lead;
  int switchRating;
  int closer;

  String getRating(RankingsCategories rankingsCategory) {
    switch (rankingsCategory) {
      case RankingsCategories.overall:
        return overall.toString();
      case RankingsCategories.leads:
        return lead.toString();
      case RankingsCategories.switches:
        return switchRating.toString();
      case RankingsCategories.closers:
        return closer.toString();
      default:
        break;
    }

    return overall.toString();
  }
}
