// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../masters/type_master.dart';
import '../colors.dart';
import '../globals.dart' as globals;

/*
-------------------------------------------------------------------- @PogoTeams
Manages a Pokemon's typing which can be exactly 1 or 2 types. This is basically
a helper class that effectively handles the case of a Pokemon with 2 types.
-------------------------------------------------------------------------------
*/

class Typing {
  Typing(List<String> typeKeys) {
    typeA = TypeMaster.typeMap[typeKeys[0]]!;
    typeB = TypeMaster.typeMap[typeKeys[1]] ?? Type(typeKey: 'none');
  }

  late final Type typeA;
  late final Type typeB;

  // True if a Pokemon only has 1 type
  bool isMonoType() {
    return 'none' == typeB.typeKey;
  }

  // True of typeKeys contains a key that this typing manages
  bool containsKey(String typeKey) {
    return (typeKey == typeA.typeKey || typeKey == typeB.typeKey);
  }

  bool containsType(List<Type> types) {
    final int typesLen = types.length;
    bool contains = false;
    for (int i = 0; i < typesLen && !contains; ++i) {
      contains = types[i].typeKey == typeA.typeKey ||
          types[i].typeKey == typeB.typeKey;
    }

    return contains;
  }

  List<Color> getColors() {
    return isMonoType()
        ? [typeA.typeColor]
        : [typeA.typeColor, typeB.typeColor];
  }

  // Get effectiveness of all types on this typing
  List<double> getDefenseEffectiveness() {
    if (isMonoType()) return typeA.getDefenseEffectiveness();

    List<double> aEffectiveness = typeA.getDefenseEffectiveness();
    List<double> bEffectiveness = typeB.getDefenseEffectiveness();

    // Calculate duo-type effectiveness
    for (int i = 0; i < globals.typeCount; ++i) {
      aEffectiveness[i] *= bEffectiveness[i];
    }

    return aEffectiveness;
  }
}

/*
-------------------------------------------------------------------- @PogoTeams
Manages all data cooresponding to a single type. This can be a type from a
Pokemon's duo / mono typing or a Pokemon move.
-------------------------------------------------------------------------------
*/

class Type {
  Type({required this.typeKey}) {
    typeColor = typeColors[typeKey]!;

    if ('none' == typeKey) {
      effectivenessMap = {};
    } else {
      effectivenessMap = TypeMaster.getEffectivenessMap(typeKey);
    }
  }

  final String typeKey;
  late final Color typeColor;

  // The offensive and defensive effectivness of this type to all types
  // [0] : offensive
  // [1] : defensive
  late final Map<String, List<double>> effectivenessMap;

  Image getIcon({double scale = 1.0}) {
    return Image.asset(
      'assets/white_type_icons/' + typeKey + '.png',
      scale: scale,
    );
  }

  List<double> getDefenseEffectiveness() {
    List<double> effectiveness =
        List.generate(globals.typeCount, (index) => 0.0);

    int i = 0;

    for (List<double> effectivenessVal in effectivenessMap.values) {
      effectiveness[i] = effectivenessVal[1];
      ++i;
    }

    return effectiveness;
  }

  List<double> getOffenseEffectiveness() {
    List<double> effectiveness =
        List.generate(globals.typeCount, (index) => 0.0);

    int i = 0;

    for (List<double> effectivenessVal in effectivenessMap.values) {
      effectiveness[i] = effectivenessVal[0];
      ++i;
    }

    return effectiveness;
  }
}
