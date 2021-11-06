import 'package:flutter/material.dart';
import 'type_effectiveness.dart';
import 'colors.dart';
import '../data/globals.dart' as globals;

/*
Manages a Pokemon's typing which can be exactly 1 or 2 types. This is basically
a helper class that effectively handles the case of a Pokemon with 2 types.
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
}

/*
Manages all data cooresponding to a single type. This can be a type from a
Pokemon's duo / mono typing or a Pokemon move.
*/
class Type {
  Type({required this.typeKey}) {
    typeColor = typeColors[typeKey] as Color;

    if ('none' != typeKey) {
      typeEffectiveness = TypeEffectiveness.getEffectivenessMap(typeKey);
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
}
