class Ratings {
  Ratings({
    required this.overall,
    required this.lead,
    required this.switchRating,
    required this.closer,
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

  static Ratings empty() => Ratings(
        overall: 0,
        lead: 0,
        switchRating: 0,
        closer: 0,
      );

  int overall;
  int lead;
  int switchRating;
  int closer;
}
