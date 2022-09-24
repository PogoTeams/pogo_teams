// Local
import '../pogo_data/typing.dart';
import '../pogo_data/pokemon.dart';
import '../modules/globals.dart';

class TypeModule {
  // type effectiveness damage scales
  static const double superEffective = 1.6;
  static const double neutral = 1.0;
  static const double notEffective = 0.625;
  static const double immune = 0.390625;

  // duo-typing effectiveness bounds
  static const double duoSuperEffective = 2.56;
  static const double duoImmune = 0.152587890625;

  // The master list of ALL type objects
  static final List<Type> typeList = [
    Type(typeId: 'normal'),
    Type(typeId: 'fire'),
    Type(typeId: 'water'),
    Type(typeId: 'grass'),
    Type(typeId: 'electric'),
    Type(typeId: 'ice'),
    Type(typeId: 'fighting'),
    Type(typeId: 'poison'),
    Type(typeId: 'ground'),
    Type(typeId: 'flying'),
    Type(typeId: 'psychic'),
    Type(typeId: 'bug'),
    Type(typeId: 'rock'),
    Type(typeId: 'ghost'),
    Type(typeId: 'dragon'),
    Type(typeId: 'dark'),
    Type(typeId: 'steel'),
    Type(typeId: 'fairy'),
    Type(typeId: 'none'),
  ];

  // A master map of ALL type objects
  static final Map<String, Type> typeMap = {
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

  // Get the map of type effectiveness cooresponding to the typeId
  static Map<String, List<double>> getEffectivenessMap(String typeId) {
    return effectivenessMaster[typeId] as Map<String, List<double>>;
  }

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
