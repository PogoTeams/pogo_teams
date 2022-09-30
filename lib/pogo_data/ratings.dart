class Ratings {
  int overall = 0;
  int lead = 0;
  int switchRating = 0;
  int closer = 0;

  Map<String, int> toJson() {
    return {
      'overall': overall,
      'lead': lead,
      'switch': switchRating,
      'closer': closer,
    };
  }
}
