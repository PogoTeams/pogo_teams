// Local Imports
import 'typing.dart';
import '../masters/type_master.dart';

/*
-------------------------------------------------------------------------------
A single Pokemon move which is either a fast move or charged move with
respective typing, coloring, and stats. GameMaster will read in and manage a
list of moves from assets/gamemaster.json.
-------------------------------------------------------------------------------
*/

class Move {
  Move({
    required this.moveId,
    required this.name,
    required this.type,
    required this.power,
    required this.energy,
    required this.energyGain,
    required this.cooldown,
    this.archetype,
    this.abbreviation,
  });

  factory Move.fromJson(json) {
    final moveId = json['moveId'] as String;
    String name = json['name'] as String;

    // Remove typing in weather ball name
    // Colors will indicate the type
    if (name.contains('Weather Ball')) {
      name = name.replaceRange(12, name.length, '');
    }

    final type = TypeMaster.typeMap[json['type'] as String] as Type;
    final power = json['power'] as num;
    final energy = json['energy'] as num;
    final energyGain = json['energyGain'] as num;
    final cooldown = json['cooldown'] as num;

    final abbreviation = json['abbreviation'] as String?;
    final archetype = json['archetype'] as String?;

    return Move(
      moveId: moveId,
      name: name,
      type: type,
      power: power,
      energy: energy,
      energyGain: energyGain,
      cooldown: cooldown,
      abbreviation: abbreviation,
      archetype: archetype,
    );
  }

  static Move from(Move other) {
    return Move(
      moveId: other.moveId,
      name: other.name,
      type: other.type,
      power: other.power,
      energy: other.energy,
      energyGain: other.energyGain,
      cooldown: other.cooldown,
      abbreviation: other.abbreviation,
      archetype: other.archetype,
    );
  }

  final String moveId;
  final String name;
  final Type type;
  final num power;
  final num energy;
  final num energyGain;
  final num cooldown;
  final String? abbreviation;
  final String? archetype;

  // True if other is the same move as this one
  bool isSameMove(Move other) {
    return moveId == other.moveId;
  }
}
