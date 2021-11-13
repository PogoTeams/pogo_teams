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
      : typeA = Type(typeKey: typeKeys[0]),
        typeB = Type(typeKey: typeKeys[1]);

  late final Type typeA;
  late final Type typeB;

  // True if a Pokemon only has 1 type
  bool isMonoType() {
    return 'none' == typeB.typeKey;
  }

  @override
  String toString() {
    return isMonoType() ? typeA.typeKey : typeA.typeKey + " / " + typeB.typeKey;
  }

  List<Color> getColors() {
    return isMonoType()
        ? [typeA.typeColor]
        : [typeA.typeColor, typeB.typeColor];
  }

  // Calculate defensive type effectiveness
  List<double> getDefenseEffectiveness() {
    if (isMonoType()) return typeA.getDefenseEffectiveness();

    List<double> aDefense = typeA.getDefenseEffectiveness();
    List<double> bDefense = typeB.getDefenseEffectiveness();

    // Calculate duo-type scaling
    int length = aDefense.length;
    for (int i = 0; i < length; ++i) {
      aDefense[i] *= bDefense[i];
    }

    return aDefense;
  }

  // True if type cooresponds to one of the types this typing contains
  bool contains(Type type) {
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
    if ('none' != typeKey) {
      typeColor = typeColors[typeKey] as Color;
      typeEffectiveness = TypeMaster.getEffectivenessMap(typeKey);
    } else {
      typeColor = Colors.black;
    }
  }

  final String typeKey;
  late final Color typeColor;

  // The offensive and defensive effectivness of this type on all types
  late final Map<String, List<double>> typeEffectiveness;

  Image getIcon({String iconColor = 'color'}) {
    return Image.asset(
        'assets/' + iconColor + '_type_icons/' + typeKey + '.png');
  }

  // Accumulate the effectivness scales for all types attacking this type
  List<double> getDefenseEffectiveness() {
    int i = 0;
    List<double> defenseEffectiveness = List.filled(globals.typeCount, 0);

    for (String typeKey in typeEffectiveness.keys) {
      defenseEffectiveness[i] = typeEffectiveness[typeKey]![1];
      ++i;
    }

    return defenseEffectiveness;
  }

  List<double> getOffensiveEffectiveness() {
    int i = 0;
    List<double> offenseEffectiveness = List.filled(globals.typeCount, 0);

    for (String typeKey in typeEffectiveness.keys) {
      offenseEffectiveness[i] = typeEffectiveness[typeKey]![0];
      ++i;
    }

    return offenseEffectiveness;
  }

  // Get a list of counters to this type
  List<Type> getCounters() {
    List<Type> counters = [];

    for (String typeKey in typeEffectiveness.keys) {
      if (typeEffectiveness[typeKey]![1] > 1.0) {
        counters.add(Type(typeKey: typeKey));
      }
    }

    return counters.getRange(0, 2).toList();
  }
}
