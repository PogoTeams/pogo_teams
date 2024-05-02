/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class Tag {
  Tag({
    required this.name,
    required this.uiColor,
    this.dateCreated,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'] as String,
      uiColor: json['uiColor'] as String,
      dateCreated: DateTime.tryParse(json['dateCreated'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uiColor': uiColor,
      'dateCreated': dateCreated?.toString(),
    };
  }

  final String name;
  final String uiColor;
  final DateTime? dateCreated;
}
