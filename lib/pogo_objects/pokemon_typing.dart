// Packages
import 'package:isar/isar.dart';

// Local
import '../modules/data/globals.dart';
import '../modules/data/pokemon_types.dart';

part 'pokemon_typing.g.dart';

/*
-------------------------------------------------------------------------------
Manages a Pokemon's typing which can be exactly 1 or 2 types.
-------------------------------------------------------------------------------
*/
@embedded
class PokemonTyping {
  PokemonTyping();

  factory PokemonTyping.fromJson(Map<String, dynamic> json) {
    return PokemonTyping()
      ..typeA = PokemonTypes.typeMap[json['typeA'] as String]!
      ..typeB = json.containsKey('typeB')
          ? PokemonTypes.typeMap[json['typeB'] as String]!
          : null;
  }

  PokemonType typeA = PokemonType.none;
  PokemonType? typeB;

  bool isMonoType() => typeB == null;

  bool contains(PokemonType type) {
    return (typeA.isSameType(type) || typeB != null && typeB!.isSameType(type));
  }

  bool containsType(List<PokemonType> types) {
    for (PokemonType type in types) {
      if (typeA.isSameType(type) ||
          (!isMonoType() && typeB!.isSameType(type))) {
        return true;
      }
    }

    return false;
  }

  bool containsTypeId(String typeId) {
    return (typeId == typeA.typeId || typeId == typeB?.typeId);
  }

  // Get defense effectiveness of all types on this typing
  List<double> defenseEffectiveness() {
    if (isMonoType()) return typeA.defenseEffectiveness();

    List<double> aEffectiveness = typeA.defenseEffectiveness();
    List<double>? bEffectiveness = typeB?.defenseEffectiveness();

    // Calculate duo-type effectiveness
    for (int i = 0; i < Globals.typeCount; ++i) {
      aEffectiveness[i] *= bEffectiveness![i];
    }

    return aEffectiveness;
  }

  num getEffectivenessFromType(PokemonType type) {
    if (isMonoType()) {
      return PokemonTypes.effectivenessMaster[typeA.typeId]![type.typeId]![1];
    }

    return PokemonTypes.effectivenessMaster[typeA.typeId]![type.typeId]![1] *
        PokemonTypes.effectivenessMaster[typeB?.typeId]![type.typeId]![1];
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
@embedded
class PokemonType {
  PokemonType({this.typeId = 'none'});

  static final PokemonType none = PokemonType(typeId: 'none');

  final String typeId;

  // The offensive and defensive effectivness of this type to all types
  // [0] : offensive
  // [1] : defensive
  Map<String, List<double>> effectivenessMap() =>
      PokemonTypes.getEffectivenessMap(typeId);

  bool isSameType(PokemonType other) {
    return typeId == other.typeId;
  }

  bool isWeakTo(PokemonType type) {
    return effectivenessMap()[type.typeId]![1] > 1.0;
  }

  List<double> defenseEffectiveness() {
    List<double> effectiveness =
        List.generate(Globals.typeCount, (index) => 0.0);

    int i = 0;

    for (List<double> effectivenessVal in effectivenessMap().values) {
      effectiveness[i] = effectivenessVal[1];
      ++i;
    }

    return effectiveness;
  }

  List<double> offenseEffectiveness() {
    List<double> effectiveness =
        List.generate(Globals.typeCount, (index) => 0.0);

    int i = 0;

    for (List<double> effectivenessVal in effectivenessMap().values) {
      effectiveness[i] = effectivenessVal[0];
      ++i;
    }

    return effectiveness;
  }
}
