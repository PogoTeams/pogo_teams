// Local
import '../../game_objects/pokemon_typing.dart';
import '../../game_objects/pokemon.dart';
import '../../tools/pair.dart';
import '../../tools/logic.dart';
import 'globals.dart';

class PokemonTypes {
  // type effectiveness damage scales
  static const double superEffective = 1.6;
  static const double neutral = 1.0;
  static const double notEffective = 0.625;
  static const double immune = 0.390625;

  // duo-typing effectiveness bounds
  static const double duoSuperEffective = 2.56;
  static const double duoImmune = 0.152587890625;

  // The master list of ALL type objects
  static final List<PokemonType> typeList = [
    PokemonType(typeId: 'normal'),
    PokemonType(typeId: 'fire'),
    PokemonType(typeId: 'water'),
    PokemonType(typeId: 'grass'),
    PokemonType(typeId: 'electric'),
    PokemonType(typeId: 'ice'),
    PokemonType(typeId: 'fighting'),
    PokemonType(typeId: 'poison'),
    PokemonType(typeId: 'ground'),
    PokemonType(typeId: 'flying'),
    PokemonType(typeId: 'psychic'),
    PokemonType(typeId: 'bug'),
    PokemonType(typeId: 'rock'),
    PokemonType(typeId: 'ghost'),
    PokemonType(typeId: 'dragon'),
    PokemonType(typeId: 'dark'),
    PokemonType(typeId: 'steel'),
    PokemonType(typeId: 'fairy'),
    PokemonType(typeId: 'none'),
  ];

  // A master map of ALL type objects
  static final Map<String, PokemonType> typeMap = {
    'normal': typeList[0],
    'fire': typeList[1],
    'water': typeList[2],
    'grass': typeList[3],
    'electric': typeList[4],
    'ice': typeList[5],
    'fighting': typeList[6],
    'poison': typeList[7],
    'ground': typeList[8],
    'flying': typeList[9],
    'psychic': typeList[10],
    'bug': typeList[11],
    'rock': typeList[12],
    'ghost': typeList[13],
    'dragon': typeList[14],
    'dark': typeList[15],
    'steel': typeList[16],
    'fairy': typeList[17],
    'none': typeList[18],
  };

  // A map of all type keys to their respective index
  static final Map<String, int> typeIndexMap = {
    'normal': 0,
    'fire': 1,
    'water': 2,
    'grass': 3,
    'electric': 4,
    'ice': 5,
    'fighting': 6,
    'poison': 7,
    'ground': 8,
    'flying': 9,
    'psychic': 10,
    'bug': 11,
    'rock': 12,
    'ghost': 13,
    'dragon': 14,
    'dark': 15,
    'steel': 16,
    'fairy': 17,
  };

  // Get the map of type effectiveness cooresponding to the typeId
  static Map<String, List<double>> getEffectivenessMap(String typeId) =>
      effectivenessMaster[typeId] as Map<String, List<double>>;

  // Get a list of the provided pokemon team's net effectiveness
  // [0] : offensive
  // [1] : defensive
  static List<double> getNetEffectiveness(List<Pokemon> team) {
    List<double> netEffectiveness = List.generate(
      Globals.typeCount,
      (index) => 0.0,
    );

    final int teamLen = team.length;

    // Accumulate team defensive type effectiveness for all types
    for (int i = 0; i < teamLen; ++i) {
      final List<double> effectiveness = team[i].defenseEffectiveness;

      for (int k = 0; k < Globals.typeCount; ++k) {
        netEffectiveness[k] += effectiveness[k];
      }
    }

    return netEffectiveness;
  }

  // Generate a list that pairs a value to all included types
  static List<Pair<PokemonType, double>> generateTypeValuePairedList(
    List<String> includedTypesKeys,
  ) {
    return includedTypesKeys
        .map(
          (typeKey) => Pair(
            a: typeMap[typeKey]!,
            b: 0.0,
          ),
        )
        .toList();
  }

  // Get a list of types given the effectiveness and types to include
  // Used in analyzing team type coverages
  static List<Pair<PokemonType, double>> getDefenseCoverage(
    List<double> effectiveness,
    List<String> includedTypesKeys,
  ) {
    List<Pair<PokemonType, double>> effectivenessList = [];

    for (int i = 0; i < includedTypesKeys.length; ++i) {
      effectivenessList.add(
        Pair(
          a: typeMap[includedTypesKeys[i]]!,
          b: effectiveness[typeIndexMap[includedTypesKeys[i]]!],
        ),
      );
    }

    return effectivenessList;
  }

  // Get a list of offense coverage given a team's moveset
  static List<Pair<PokemonType, double>> getOffenseCoverage(
    List<Pokemon> team,
    List<String> includedTypesKeys,
  ) {
    List<Pair<PokemonType, double>> offenseCoverage =
        generateTypeValuePairedList(includedTypesKeys);

    for (int i = 0; i < team.length; ++i) {
      final List<double> movesetEffectiveness = team[i].offenseCoverage;

      for (int k = 0; k < includedTypesKeys.length; ++k) {
        offenseCoverage[k].b +=
            movesetEffectiveness[typeIndexMap[includedTypesKeys[k]]!];
      }
    }

    return offenseCoverage;
  }

  // Get the effectiveness given the defense effectiveness and offense coverage
  // Used to display a net effectiveness graph on a team analysis page
  static List<Pair<PokemonType, double>> getMovesWeightedEffectiveness(
    List<Pair<PokemonType, double>> defense,
    List<Pair<PokemonType, double>> offense,
    List<String> includedTypesKeys,
  ) {
    List<Pair<PokemonType, double>> movesWeightedEffectiveness =
        generateTypeValuePairedList(includedTypesKeys);

    for (int i = 0; i < movesWeightedEffectiveness.length; ++i) {
      movesWeightedEffectiveness[i].b =
          normalize(offense[i].b / defense[i].b, 0.1, 1.6);
    }

    return movesWeightedEffectiveness;
  }

  // Given a list of type, return the top n counters to those types
  // This is used in determining the Pokemon threats / counters in analysis
  static List<PokemonType> getCounterTypes(
      List<PokemonType> types, List<String> includedTypesKeys,
      {int typesCount = 5}) {
    if (typesCount > includedTypesKeys.length ||
        typesCount > Globals.typeCount ||
        typesCount < 1) {
      typesCount = includedTypesKeys.length;
    }

    // Build a list of length equal to the included type keys
    List<Pair<PokemonType, double>> netTypeEffectiveness = List.generate(
      includedTypesKeys.length,
      (index) => Pair(
        a: typeList[typeIndexMap[includedTypesKeys[index]]!],
        b: 0.0,
      ),
    );

    List<PokemonType> counters = [];

    // Accumulate only the included types
    for (int i = 0; i < types.length; ++i) {
      final List<double> effectiveness = types[i].defenseEffectiveness;

      for (int i = 0; i < includedTypesKeys.length; ++i) {
        netTypeEffectiveness[i].b +=
            effectiveness[typeIndexMap[includedTypesKeys[i]]!];
      }
    }

    netTypeEffectiveness
        .sort((prev, curr) => ((prev.b - curr.b) * 100).toInt());

    for (int i = 0; i < typesCount; ++i) {
      counters.add(netTypeEffectiveness[i].a);
    }

    return counters;
  }

  // All type offense & defense effectiveness.
  // The first key accesses a map of all type effectivnesses cooresponding
  // to that particular type. The 2 element list represents :
  // [0] : parent key offensive effectiveness
  // [1] : parent key defensive effectiveness
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
    'none': {},
  };
}
