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
    required this.cooldown,
    this.archetype,
    this.abbreviation,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    final moveId = json['moveId'] as String;
    final name = json['name'] as String;
    final type = Type(typeKey: json['type'] as String);
    final power = json['power'] as num;
    final energy = json['energy'] as num;
    final cooldown = json['cooldown'] as num;

    final abbreviation = json['abbreviation'] as String?;
    final archetype = json['archetype'] as String?;

    return Move(
      moveId: moveId,
      name: name,
      type: type,
      power: power,
      energy: energy,
      cooldown: cooldown,
      abbreviation: abbreviation,
      archetype: archetype,
    );
  }

  final String moveId;
  final String name;
  final Type type;
  final num power;
  final num energy;
  final num cooldown;
  final String? abbreviation;
  final String? archetype;

  // Get a general score based off of power, cooldown, energy generation, and STAB
  num getScore(Typing typing) {
    return (power / cooldown) *
        (energy == 0 ? 1 : energy) *
        getStabScale(typing);
    //getCounterScale(typing);
  }

  // Determine the scale of stab damage for this move
  num getStabScale(Typing typing) {
    return (typing.contains(type)) ? 2.0 : 1.0;
  }

  num getCounterScale(Typing typing) {
    return TypeMaster.getCounterScale(typing, type);
  }

  // True if other is the same move as this one
  bool isSameMove(Move other) {
    return moveId == other.moveId;
  }
}
