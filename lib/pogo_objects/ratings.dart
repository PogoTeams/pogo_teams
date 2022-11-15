// Packages
import 'package:isar/isar.dart';

part 'ratings.g.dart';

@embedded
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
}
