class Cup {
  Cup({
    required this.cupId,
    required this.name,
    required this.cp,
    required this.partySize,
    required this.live,
  });

  factory Cup.fromJson(Map<String, dynamic> json) {
    return Cup(
      cupId: json['cupId'] as String,
      name: json['name'] as String,
      cp: json['cp'] as int,
      partySize: json['partySize'] as int,
      live: json['live'] as bool,
    );
  }

  final String cupId;
  final String name;
  final int cp;
  final int partySize;
  final bool live;
}
