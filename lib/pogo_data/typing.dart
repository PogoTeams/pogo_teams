// Local
import '../modules/globals.dart';
import '../modules/types.dart';

/*
-------------------------------------------------------------------------------
Manages a Pokemon's typing which can be exactly 1 or 2 types. This is basically
a helper class that effectively handles the case of a Pokemon with 2 types.
-------------------------------------------------------------------------------
*/

class PokemonTyping {
  PokemonTyping({
    required this.typeA,
    required this.typeB,
  });

  factory PokemonTyping.fromJson(Map<String, dynamic> json) {
    return PokemonTyping(
      typeA: TypeModule.typeMap[json['typeA'] as String]!,
      typeB: json.containsKey('typeB')
          ? TypeModule.typeMap[json['typeB'] as String]!
          : null,
    );
  }

  final Type typeA;
  final Type? typeB;

  bool isMonoType() {
    return typeB == null;
  }

  bool contains(Type type) {
    return (type.typeId == typeA.typeId ||
        typeB != null && type.typeId == typeB?.typeId);
  }

  // Get defense effectiveness of all types on this typing
  List<double> get defenseEffectiveness {
    if (isMonoType()) return typeA.getDefenseEffectiveness();

    List<double> aEffectiveness = typeA.getDefenseEffectiveness();
    List<double>? bEffectiveness = typeB?.getDefenseEffectiveness();

    // Calculate duo-type effectiveness
    for (int i = 0; i < Globals.typeCount; ++i) {
      aEffectiveness[i] *= bEffectiveness![i];
    }

    return aEffectiveness;
  }

  num getEffectivenessFromType(Type type) {
    if (isMonoType()) {
      return TypeModule.effectivenessMaster[typeA.typeId]![type.typeId]![1];
    }

    return TypeModule.effectivenessMaster[typeA.typeId]![type.typeId]![1] *
        TypeModule.effectivenessMaster[typeB?.typeId]![type.typeId]![1];
  }

  @override
  String toString() {
    if (isMonoType()) {
      return typeA.typeId;
    }

    return '${typeA.typeId} / ${typeB?.typeId}';
  }
}

/*
Manages all data cooresponding to a single type. This can be a type from a
Pokemon's duo / mono typing or a Pokemon move.
*/
class Type {
  Type({required this.typeId}) {
    effectivenessMap = TypeModule.getEffectivenessMap(typeId);
  }

  static final Type none = Type(typeId: 'none');

  final String typeId;

  // The offensive and defensive effectivness of this type to all types
  // [0] : offensive
  // [1] : defensive
  late final Map<String, List<double>> effectivenessMap;

  bool isSameType(Type other) {
    return typeId == other.typeId;
  }

  bool isWeakTo(Type type) {
    return effectivenessMap[type.typeId]![1] > 1.0;
  }

  List<double> getDefenseEffectiveness() {
    List<double> effectiveness =
        List.generate(Globals.typeCount, (index) => 0.0);

    int i = 0;

    for (List<double> effectivenessVal in effectivenessMap.values) {
      effectiveness[i] = effectivenessVal[1];
      ++i;
    }

    return effectiveness;
  }

  List<double> getOffenseEffectiveness() {
    List<double> effectiveness =
        List.generate(Globals.typeCount, (index) => 0.0);

    int i = 0;

    for (List<double> effectivenessVal in effectivenessMap.values) {
      effectiveness[i] = effectivenessVal[0];
      ++i;
    }

    return effectiveness;
  }
}
