// Dart
import 'dart:math';

// Local
import '../pogo_data/stats.dart';
import '../modules/globals.dart';

/*
----------------------------- C P - F O R M U L A -----------------------------
CP = Floor( Max( 10, ATK * DEF^0.5 * HP^0.5 * CP_MUL[LVL]^2) / 10 ) )
-------------------------------------------------------------------------------
ATK : atk stat + atk iv
DEF : def stat + def iv
HP  : hp  stat +  hp iv

Given a Pokemon's base stats and ivs, this formula can be used to calculate
all CP breakpoints cooresponding to each level. By iterating through the list
cpMultipliers, a Pokemon's CP growth can be computed from level 1 all the way
up to 55, where each index is 1/2 of a level.
-------------------------------------------------------------------------------
*/

class Stats {
  static const int ivSpreadMax = 250;
  static const num pvpDamageBonusMultiplier = 1.3;
  static const num shadowAtkMultiplier = 1.2;
  static const num shadowDefMultiplier = 0.8333333;

  static int calculateCP(BaseStats stats, IVs ivs) {
    return max(
        10,
        ((stats.atk + ivs.atk) *
                sqrt(stats.def + ivs.def) *
                sqrt(stats.hp + ivs.hp) *
                pow(cpMultipliers[getLevelIndex(ivs.level)], 2) *
                .1)
            .toInt());
  }

  static int calculateMaxHp(BaseStats stats, IVs ivs) {
    return max(
        10, ((stats.hp + ivs.hp) * Stats.getCpMultiplier(ivs.level)).floor());
  }

  static int calculateIVStatProduct(BaseStats baseStats, IVs ivs) {
    double cpm = getCpMultiplier(ivs.level);
    double atk = (baseStats.atk + ivs.atk) * cpm;
    double def = (baseStats.def + ivs.def) * cpm;
    double hp = ((baseStats.hp + ivs.hp) * cpm).floorToDouble();
    return (atk * def * hp).floor();
  }

  static List<IVs> generateIVSpreads(BaseStats baseStats, int cpCap) {
    // IV combinations are inserted, sorted by IV-stat product
    List<PokemonStats> ivCombinations = [];

    for (int hpIV = 15; hpIV >= 0; --hpIV) {
      for (int defIV = 15; defIV >= 0; --defIV) {
        for (int atkIV = 15; atkIV >= 0; --atkIV) {
          PokemonStats stats = PokemonStats(
            baseStats: baseStats,
            ivs: IVs(
              level: 1,
              atk: atkIV,
              def: defIV,
              hp: hpIV,
            ),
          );
          setMaxLevel(stats, cpCap);

          // calculate IV-stat product for this IV combinations max level
          stats.ivStatProduct =
              calculateIVStatProduct(stats.baseStats, stats.ivs);
          ivCombinations.add(stats);
        }
      }
    }

    ivCombinations
        .sort((combo1, combo2) => combo2.ivStatProduct - combo1.ivStatProduct);

    return ivCombinations
        .toList()
        .getRange(0, ivSpreadMax)
        .map((ivCombo) => ivCombo.ivs)
        .toList();
  }

  static void setMaxLevel(PokemonStats stats, int cpCap) {
    do {
      stats.ivs.level += .5;
      stats.cp = calculateCP(stats.baseStats, stats.ivs);
    } while (stats.cp <= cpCap && stats.ivs.level <= Globals.maxPokemonLevel);

    // back-track to the last valid level
    if (stats.ivs.level != 1) stats.ivs.level -= .5;
  }

  static int getLevelIndex(num level) {
    if (level > Globals.maxPokemonLevel) {
      return ((Globals.maxPokemonLevel * 2) - 2).toInt();
    }
    return ((level * 2) - 2).toInt();
  }

  static double getCpMultiplier(num level) {
    if (level > Globals.maxPokemonLevel) {
      return cpMultipliers[getLevelIndex(Globals.maxPokemonLevel)];
    }

    return cpMultipliers[getLevelIndex(level)];
  }

  // The scales used in calculating the cp increase
  static List<double> powerUpScales = [
    0.009426125469, // Level 1 - 9.5
    0.008919025675, // Level 10 - 19.5
    0.008924905903, // Level 20 - 29.5
    0.00445946079 // Level 30 - 39.5
  ];

  // The multipliers are used in calculating a Pokemon's CP
  // These values coorespond to a Pokemon's current level
  // [0] level 1
  // [1] level 1.5
  // [2] level 2
  // [3] level 2.5
  static List<double> cpMultipliers = [
    0.094,
    0.13513743,
    0.16639787,
    0.19265091,
    0.21573247,
    0.23657266,
    0.25572005,
    0.27353038,
    0.29024988,
    0.30605738,
    0.3210876,
    0.33544503,
    0.34921268,
    0.36245776,
    0.3752356,
    0.38759242,
    0.39956728,
    0.41119354,
    0.4225,
    0.43292641,
    0.44310755,
    0.45305996,
    0.4627984,
    0.47233608,
    0.48168495,
    0.49085581,
    0.49985844,
    0.50870176,
    0.51739395,
    0.5259425,
    0.5343543,
    0.54263575,
    0.5507927,
    0.55883059,
    0.5667545,
    0.57456913,
    0.5822789,
    0.5898879,
    0.5974,
    0.60482366,
    0.6121573,
    0.61940411,
    0.6265671,
    0.63364917,
    0.64065295,
    0.64758096,
    0.65443563,
    0.66121926,
    0.667934,
    0.67458189,
    0.6811649,
    0.68768489,
    0.69414365,
    0.70054289,
    0.7068842,
    0.7131691,
    0.7193991,
    0.72557562,
    0.7317,
    0.73474102,
    0.7377695,
    0.74078558,
    0.74378943,
    0.7467812,
    0.74976104,
    0.7527291,
    0.7556855,
    0.75863036,
    0.76156384,
    0.76448607,
    0.76739717,
    0.77029727,
    0.7731865,
    0.77606494,
    0.77893275,
    0.78179008,
    0.784637,
    0.78747359,
    0.7903,
    0.79280394,
    0.7953,
    0.79780392,
    0.8003,
    0.80280389,
    0.8053,
    0.80780387,
    0.8103,
    0.81280384,
    0.8153,
    0.81780382,
    0.8203,
    0.8228038,
    0.8253,
    0.82780378,
    0.8303,
    0.83280375,
    0.8353,
    0.83780373,
    0.8403,
    0.84280371,
    0.8453,
    0.84780369,
    0.8503,
    0.85280366,
    0.8553,
    0.85780364,
    0.8603,
    0.86280362,
    0.8653
  ];
}
