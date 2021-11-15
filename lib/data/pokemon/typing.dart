// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../masters/type_master.dart';
import '../colors.dart';
import '../globals.dart' as globals;

/*
-------------------------------------------------------------------------------
Manages a Pokemon's typing which can be exactly 1 or 2 types. This is basically
a helper class that effectively handles the case of a Pokemon with 2 types.
-------------------------------------------------------------------------------
*/

class Typing {
  Typing(List<String> typeKeys)
      : typeA = TypeMaster.typeMap[typeKeys[0]]!,
        typeB = TypeMaster.typeMap[typeKeys[1]]!;

  late final Type typeA;
  late final Type typeB;

  // True if a Pokemon only has 1 type
  bool isMonoType() {
    return 'none' == typeB.typeKey;
  }

  // True if type cooresponds to one of the types this typing contains
  bool containsType(Type type) {
    return typeA.typeKey == type.typeKey || typeB.typeKey == type.typeKey;
  }

  // True of typeKeys contains a key that this typing manages
  bool containsKey(List<String> typeKeys) {
    final int typeKeyLen = typeKeys.length;
    bool contains = false;

    for (int i = 0; i < typeKeyLen && !contains; ++i) {
      contains = typeKeys[i] == typeA.typeKey || typeKeys[i] == typeB.typeKey;
    }

    return contains;
  }

  List<Color> getColors() {
    return isMonoType()
        ? [typeA.typeColor]
        : [typeA.typeColor, typeB.typeColor];
  }

  List<List<double>> getEffectiveness(List<Type> movesetTypes) {
    if (isMonoType()) return typeA.getEffectiveness();

    List<List<double>> aEffectiveness = typeA.getEffectiveness();
    List<List<double>> bEffectiveness = typeB.getEffectiveness();

    // Calculate duo-type effectiveness
    for (int i = 0; i < globals.typeCount; ++i) {
      aEffectiveness[i][0] *= bEffectiveness[i][0];
      aEffectiveness[i][1] *= bEffectiveness[i][1];

      // Weigh in attack super effective scenarios
      for (int k = 0; k < 3; ++k) {
        aEffectiveness[i][0] *= (movesetTypes[k]
                    .effectivenessMap[TypeMaster.typeList[i].typeKey]![0] >
                1.0
            ? 1.6
            : 1.0);
      }
    }

    return aEffectiveness;
  }

  // True if this typing is weak to the given type
  // 'weak' counts as more than neutral damage
  bool isWeakness(Type type) {
    if (isMonoType()) {
      return TypeMaster.effectivenessMaster[typeA.typeKey]![type.typeKey]![1] >
          1;
    }

    return TypeMaster.effectivenessMaster[typeA.typeKey]![type.typeKey]![1] +
            TypeMaster.effectivenessMaster[typeB.typeKey]![type.typeKey]![1] >
        2.0;
  }
}

/*
Manages all data cooresponding to a single type. This can be a type from a
Pokemon's duo / mono typing or a Pokemon move.
*/
class Type {
  Type({required this.typeKey}) {
    typeColor = typeColors[typeKey]!;

    if ('none' != typeKey) {
      effectivenessMap = TypeMaster.getEffectivenessMap(typeKey);
    }
  }

  final String typeKey;
  late final Color typeColor;

  // The offensive and defensive effectivness of this type to all types
  // [0] : offensive
  // [1] : defensive
  late final Map<String, List<double>> effectivenessMap;

  Image getIcon({String iconColor = 'color'}) {
    return Image.asset(
        'assets/' + iconColor + '_type_icons/' + typeKey + '.png');
  }

  List<List<double>> getEffectiveness() {
    List<List<double>> effectiveness =
        List.generate(globals.typeCount, (index) => [0.0, 0.0]);

    int i = 0;

    for (List<double> effectivenessVal in effectivenessMap.values) {
      effectiveness[i][0] = effectivenessVal[0];
      effectiveness[i][1] = effectivenessVal[1];
      ++i;
    }

    return effectiveness;
  }
}
