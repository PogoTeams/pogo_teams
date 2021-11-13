// Local Imports
import '../../tools/pair.dart';
import '../pokemon/typing.dart';
import '../pokemon/pokemon.dart';
import '../globals.dart' as globals;

/*
-------------------------------------------------------------------------------
All type effectiveness relationships are handled here. The effectivenessMaster
map contains these numeric relationships, effectively scaling all type on type
offense / defense scenerios that can occur.
-------------------------------------------------------------------------------
*/

class TypeMaster {
  // type effectiveness damage scales
  static const double neutral = 1.0;
  static const double superEffective = 1.6;
  static const double notEffective = 0.0625;
  static const double immune = 0.390625;

  // The master list of ALL type objects
  static final typeList =
      effectivenessMaster.keys.map((key) => Type(typeKey: key)).toList();

  // Get the map of type effectiveness cooresponding to the typeKey
  static Map<String, List<double>> getEffectivenessMap(String typeKey) {
    return effectivenessMaster[typeKey] as Map<String, List<double>>;
  }

  static List<Type> generateTypeList() {
    return List.from(typeList);
  }

  // Get a scale that represents 'type's ability to counter 'typing's weaknesses
  static num getCounterScale(Typing typing, Type type) {
    List<double> defense = typing.getDefenseEffectiveness();
    final effectivenessMap = effectivenessMaster[type.typeKey];

    num counterScale = 1.0;

    int i = 0;
    for (List<double> scales in effectivenessMap!.values) {
      if (defense[i] < 1.0) {
        counterScale *= scales[0];
      }
      ++i;
    }

    return counterScale;
  }

  // Get a list of pairs, where each type has a value
  // These values coorespond to the team's net type effectiveness
  static List<Pair<double, Type>> getNetTypeEffectiveness(List<Pokemon> team) {
    // Bind a list of all types to a value
    // This value will represent their offensive effectiveness on this team
    List<Pair<double, Type>> teamEffectiveness =
        List.generate(globals.typeCount, (i) {
      return Pair(a: 0.0, b: typeList[i]);
    });

    final int teamLength = team.length;

    // Accumulate team defensive type effectiveness for all types
    for (int i = 0; i < teamLength; ++i) {
      final List<double> effectiveness = team[i].getDefenseEffectiveness();

      for (int k = 0; k < globals.typeCount; ++k) {
        teamEffectiveness[k].a += effectiveness[k];
      }
    }

    return teamEffectiveness;
  }

  // Find the net weaknesses of the team
  // Then find the counters to those weaknesses and return them
  static List<Type> getCounters(List<Pokemon> team) {
    final int teamLen = team.length;
    if (teamLen == 0) return [];

    final List<Pair<double, Type>> effectiveness =
        getNetTypeEffectiveness(team);

    List<Type> counters = [];

    // Sort by the highest team weaknesses
    effectiveness.sort((pairA, pairB) => ((pairB.a - pairA.a) * 100).toInt());

    // Get the counters of the 3 highest threats
    for (int i = 0; i < 3; ++i) {
      if (effectiveness[i].a > teamLen) {
        counters.addAll(effectiveness[i].b.getCounters());
      }
    }

    return counters;
  }

  // A master list of all type keys
  static const List<String> typeKeys = [
    'normal',
    'fire',
    'water',
    'grass',
    'electric',
    'ice',
    'fighting',
    'poison',
    'ground',
    'flying',
    'psychic',
    'bug',
    'rock',
    'ghost',
    'dragon',
    'dark',
    'steel',
    'fairy',
  ];

  // All type offense & defense effectiveness.
  // The first key accesses a map of all type effectivnesses cooresponding
  // to that particular type. The 2 element list represents :
  // [0] : offensive effectiveness
  // [1] : defensive effectiveness
  static const Map<String, Map<String, List<double>>> effectivenessMaster = {
    'normal': {
      'normal': [neutral, neutral],
      'fire': [neutral, neutral],
      'water': [neutral, neutral],
      'grass': [neutral, neutral],
      'electric': [neutral, neutral],
      'ice': [neutral, neutral],
      'fighting': [neutral, superEffective],
      'poison': [neutral, neutral],
      'ground': [neutral, neutral],
      'flying': [neutral, neutral],
      'psychic': [neutral, neutral],
      'bug': [neutral, neutral],
      'rock': [notEffective, neutral],
      'ghost': [immune, immune],
      'dragon': [neutral, neutral],
      'dark': [neutral, neutral],
      'steel': [notEffective, neutral],
      'fairy': [neutral, neutral]
    },
    'fire': {
      'normal': [neutral, neutral],
      'fire': [notEffective, notEffective],
      'water': [notEffective, superEffective],
      'grass': [superEffective, notEffective],
      'electric': [neutral, neutral],
      'ice': [superEffective, notEffective],
      'fighting': [neutral, neutral],
      'poison': [neutral, neutral],
      'ground': [neutral, superEffective],
      'flying': [neutral, neutral],
      'psychic': [neutral, neutral],
      'bug': [superEffective, notEffective],
      'rock': [notEffective, superEffective],
      'ghost': [neutral, neutral],
      'dragon': [notEffective, neutral],
      'dark': [neutral, neutral],
      'steel': [superEffective, notEffective],
      'fairy': [neutral, neutral]
    },
    'water': {
      'normal': [neutral, neutral],
      'fire': [superEffective, notEffective],
      'water': [notEffective, notEffective],
      'grass': [notEffective, superEffective],
      'electric': [neutral, superEffective],
      'ice': [neutral, notEffective],
      'fighting': [neutral, neutral],
      'poison': [neutral, neutral],
      'ground': [superEffective, neutral],
      'flying': [neutral, neutral],
      'psychic': [neutral, neutral],
      'bug': [neutral, neutral],
      'rock': [superEffective, neutral],
      'ghost': [neutral, neutral],
      'dragon': [notEffective, neutral],
      'dark': [neutral, neutral],
      'steel': [neutral, notEffective],
      'fairy': [neutral, neutral]
    },
    'grass': {
      'normal': [neutral, neutral],
      'fire': [notEffective, superEffective],
      'water': [superEffective, notEffective],
      'grass': [notEffective, notEffective],
      'electric': [neutral, notEffective],
      'ice': [neutral, superEffective],
      'fighting': [neutral, neutral],
      'poison': [notEffective, superEffective],
      'ground': [superEffective, notEffective],
      'flying': [notEffective, superEffective],
      'psychic': [neutral, neutral],
      'bug': [notEffective, superEffective],
      'rock': [superEffective, neutral],
      'ghost': [neutral, neutral],
      'dragon': [notEffective, neutral],
      'dark': [neutral, neutral],
      'steel': [notEffective, neutral],
      'fairy': [neutral, neutral]
    },
    'electric': {
      'normal': [neutral, neutral],
      'fire': [neutral, neutral],
      'water': [superEffective, neutral],
      'grass': [notEffective, neutral],
      'electric': [notEffective, notEffective],
      'ice': [neutral, neutral],
      'fighting': [neutral, neutral],
      'poison': [neutral, neutral],
      'ground': [immune, superEffective],
      'flying': [superEffective, notEffective],
      'psychic': [neutral, neutral],
      'bug': [neutral, neutral],
      'rock': [neutral, neutral],
      'ghost': [neutral, neutral],
      'dragon': [notEffective, neutral],
      'dark': [neutral, neutral],
      'steel': [neutral, notEffective],
      'fairy': [neutral, neutral]
    },
    'ice': {
      'normal': [neutral, neutral],
      'fire': [notEffective, superEffective],
      'water': [notEffective, neutral],
      'grass': [superEffective, neutral],
      'electric': [neutral, neutral],
      'ice': [notEffective, notEffective],
      'fighting': [neutral, superEffective],
      'poison': [neutral, neutral],
      'ground': [superEffective, neutral],
      'flying': [superEffective, neutral],
      'psychic': [neutral, neutral],
      'bug': [neutral, neutral],
      'rock': [neutral, superEffective],
      'ghost': [neutral, neutral],
      'dragon': [superEffective, neutral],
      'dark': [neutral, neutral],
      'steel': [notEffective, superEffective],
      'fairy': [neutral, neutral]
    },
    'fighting': {
      'normal': [superEffective, neutral],
      'fire': [neutral, neutral],
      'water': [neutral, neutral],
      'grass': [neutral, neutral],
      'electric': [neutral, neutral],
      'ice': [superEffective, neutral],
      'fighting': [neutral, neutral],
      'poison': [notEffective, neutral],
      'ground': [neutral, neutral],
      'flying': [notEffective, superEffective],
      'psychic': [notEffective, superEffective],
      'bug': [notEffective, notEffective],
      'rock': [superEffective, notEffective],
      'ghost': [immune, neutral],
      'dragon': [neutral, neutral],
      'dark': [superEffective, notEffective],
      'steel': [superEffective, neutral],
      'fairy': [notEffective, superEffective]
    },
    'poison': {
      'normal': [neutral, neutral],
      'fire': [neutral, neutral],
      'water': [neutral, neutral],
      'grass': [superEffective, notEffective],
      'electric': [neutral, neutral],
      'ice': [neutral, neutral],
      'fighting': [neutral, notEffective],
      'poison': [notEffective, notEffective],
      'ground': [notEffective, superEffective],
      'flying': [neutral, neutral],
      'psychic': [neutral, superEffective],
      'bug': [neutral, notEffective],
      'rock': [notEffective, neutral],
      'ghost': [notEffective, neutral],
      'dragon': [neutral, neutral],
      'dark': [neutral, neutral],
      'steel': [immune, neutral],
      'fairy': [superEffective, notEffective]
    },
    'ground': {
      'normal': [neutral, neutral],
      'fire': [superEffective, neutral],
      'water': [neutral, superEffective],
      'grass': [notEffective, superEffective],
      'electric': [superEffective, immune],
      'ice': [neutral, superEffective],
      'fighting': [neutral, neutral],
      'poison': [superEffective, notEffective],
      'ground': [neutral, neutral],
      'flying': [immune, neutral],
      'psychic': [neutral, neutral],
      'bug': [notEffective, neutral],
      'rock': [superEffective, notEffective],
      'ghost': [neutral, neutral],
      'dragon': [neutral, neutral],
      'dark': [neutral, neutral],
      'steel': [superEffective, neutral],
      'fairy': [neutral, neutral]
    },
    'flying': {
      'normal': [neutral, neutral],
      'fire': [neutral, neutral],
      'water': [neutral, neutral],
      'grass': [superEffective, notEffective],
      'electric': [notEffective, superEffective],
      'ice': [neutral, superEffective],
      'fighting': [superEffective, notEffective],
      'poison': [neutral, neutral],
      'ground': [neutral, immune],
      'flying': [neutral, neutral],
      'psychic': [neutral, neutral],
      'bug': [superEffective, notEffective],
      'rock': [notEffective, superEffective],
      'ghost': [neutral, neutral],
      'dragon': [neutral, neutral],
      'dark': [neutral, neutral],
      'steel': [notEffective, neutral],
      'fairy': [neutral, neutral]
    },
    'psychic': {
      'normal': [neutral, neutral],
      'fire': [neutral, neutral],
      'water': [neutral, neutral],
      'grass': [neutral, neutral],
      'electric': [neutral, neutral],
      'ice': [neutral, neutral],
      'fighting': [superEffective, notEffective],
      'poison': [superEffective, neutral],
      'ground': [neutral, neutral],
      'flying': [neutral, neutral],
      'psychic': [notEffective, notEffective],
      'bug': [neutral, superEffective],
      'rock': [neutral, neutral],
      'ghost': [neutral, superEffective],
      'dragon': [neutral, neutral],
      'dark': [immune, superEffective],
      'steel': [notEffective, neutral],
      'fairy': [neutral, neutral]
    },
    'bug': {
      'normal': [neutral, neutral],
      'fire': [notEffective, superEffective],
      'water': [neutral, neutral],
      'grass': [superEffective, notEffective],
      'electric': [neutral, neutral],
      'ice': [neutral, neutral],
      'fighting': [notEffective, notEffective],
      'poison': [notEffective, neutral],
      'ground': [neutral, notEffective],
      'flying': [notEffective, superEffective],
      'psychic': [superEffective, neutral],
      'bug': [neutral, neutral],
      'rock': [neutral, superEffective],
      'ghost': [notEffective, neutral],
      'dragon': [neutral, neutral],
      'dark': [superEffective, neutral],
      'steel': [notEffective, neutral],
      'fairy': [notEffective, neutral]
    },
    'rock': {
      'normal': [neutral, notEffective],
      'fire': [superEffective, notEffective],
      'water': [neutral, superEffective],
      'grass': [neutral, superEffective],
      'electric': [neutral, neutral],
      'ice': [superEffective, neutral],
      'fighting': [notEffective, superEffective],
      'poison': [neutral, notEffective],
      'ground': [notEffective, superEffective],
      'flying': [superEffective, notEffective],
      'psychic': [neutral, neutral],
      'bug': [superEffective, neutral],
      'rock': [neutral, neutral],
      'ghost': [neutral, neutral],
      'dragon': [neutral, neutral],
      'dark': [neutral, neutral],
      'steel': [notEffective, superEffective],
      'fairy': [neutral, neutral]
    },
    'ghost': {
      'normal': [immune, immune],
      'fire': [neutral, neutral],
      'water': [neutral, neutral],
      'grass': [neutral, neutral],
      'electric': [neutral, neutral],
      'ice': [neutral, neutral],
      'fighting': [neutral, immune],
      'poison': [neutral, notEffective],
      'ground': [neutral, neutral],
      'flying': [neutral, neutral],
      'psychic': [superEffective, neutral],
      'bug': [neutral, notEffective],
      'rock': [neutral, neutral],
      'ghost': [superEffective, superEffective],
      'dragon': [neutral, neutral],
      'dark': [notEffective, superEffective],
      'steel': [neutral, neutral],
      'fairy': [neutral, neutral]
    },
    'dragon': {
      'normal': [neutral, neutral],
      'fire': [neutral, notEffective],
      'water': [neutral, notEffective],
      'grass': [neutral, notEffective],
      'electric': [neutral, notEffective],
      'ice': [neutral, superEffective],
      'fighting': [neutral, neutral],
      'poison': [neutral, neutral],
      'ground': [neutral, neutral],
      'flying': [neutral, neutral],
      'psychic': [neutral, neutral],
      'bug': [neutral, neutral],
      'rock': [neutral, neutral],
      'ghost': [neutral, neutral],
      'dragon': [superEffective, superEffective],
      'dark': [neutral, neutral],
      'steel': [notEffective, neutral],
      'fairy': [immune, superEffective]
    },
    'dark': {
      'normal': [neutral, neutral],
      'fire': [neutral, neutral],
      'water': [neutral, neutral],
      'grass': [neutral, neutral],
      'electric': [neutral, neutral],
      'ice': [neutral, neutral],
      'fighting': [notEffective, superEffective],
      'poison': [neutral, neutral],
      'ground': [neutral, neutral],
      'flying': [neutral, neutral],
      'psychic': [superEffective, immune],
      'bug': [neutral, superEffective],
      'rock': [neutral, neutral],
      'ghost': [superEffective, notEffective],
      'dragon': [neutral, neutral],
      'dark': [notEffective, notEffective],
      'steel': [neutral, neutral],
      'fairy': [notEffective, superEffective]
    },
    'steel': {
      'normal': [neutral, notEffective],
      'fire': [notEffective, superEffective],
      'water': [notEffective, neutral],
      'grass': [neutral, notEffective],
      'electric': [notEffective, neutral],
      'ice': [superEffective, notEffective],
      'fighting': [neutral, superEffective],
      'poison': [neutral, immune],
      'ground': [neutral, superEffective],
      'flying': [neutral, notEffective],
      'psychic': [neutral, notEffective],
      'bug': [neutral, notEffective],
      'rock': [superEffective, notEffective],
      'ghost': [neutral, neutral],
      'dragon': [neutral, notEffective],
      'dark': [neutral, neutral],
      'steel': [notEffective, notEffective],
      'fairy': [superEffective, notEffective]
    },
    'fairy': {
      'normal': [neutral, neutral],
      'fire': [notEffective, neutral],
      'water': [neutral, neutral],
      'grass': [neutral, neutral],
      'electric': [neutral, neutral],
      'ice': [neutral, neutral],
      'fighting': [superEffective, notEffective],
      'poison': [notEffective, superEffective],
      'ground': [neutral, neutral],
      'flying': [neutral, neutral],
      'psychic': [neutral, neutral],
      'bug': [neutral, notEffective],
      'rock': [neutral, neutral],
      'ghost': [neutral, neutral],
      'dragon': [superEffective, immune],
      'dark': [superEffective, notEffective],
      'steel': [notEffective, superEffective],
      'fairy': [neutral, neutral]
    },
  };
}
