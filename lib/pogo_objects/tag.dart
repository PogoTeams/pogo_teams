// Packages
import 'package:isar/isar.dart';

part 'tag.g.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

@Collection(accessor: 'tags')
class Tag {
  Tag({
    required this.name,
    required this.uiColor,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'] as String,
      uiColor: json['uiColor'] as String,
    );
  }

  Map<String, dynamic> toExportJson() {
    return {
      'name': name,
      'uiColor': uiColor,
    };
  }

  Id id = Isar.autoIncrement;

  @Index(unique: true)
  final String name;
  final String uiColor;
}
