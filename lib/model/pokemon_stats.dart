// Packages
import 'package:hive_flutter/hive_flutter.dart';

// Local
import '../modules/globals.dart';

/*
-------------------------------------------------------------------- @PogoTeams
All data related to a Pokemon's stats are managed here.
-------------------------------------------------------------------------------
*/

class PokemonStats {
  PokemonStats({
    required this.baseStats,
    required this.ivs,
  });

  BaseStats baseStats;
  IVs ivs;
  int ivStatProduct = 0;
  int cp = 0;
}

class BaseStats {
  BaseStats({
    this.atk = 0,
    this.def = 0,
    this.hp = 0,
  });

  factory BaseStats.fromJson(Map<String, dynamic> json) {
    return BaseStats(
      atk: json['atk'] as int,
      def: json['def'] as int,
      hp: json['hp'] as int,
    );
  }

  factory BaseStats.empty() {
    return BaseStats(
      atk: 0,
      def: 0,
      hp: 0,
    );
  }

  Map<String, num> toJson() {
    return <String, num>{
      'atk': atk,
      'def': def,
      'hp': hp,
    };
  }

  final int atk;
  final int def;
  final int hp;
}

class IVs {
  IVs({
    this.level = 1,
    this.atk = 0,
    this.def = 0,
    this.hp = 0,
  });

  factory IVs.fromJson(Map<String, dynamic> json) {
    return IVs(
      level: json['level'] as double,
      atk: json['atk'] as int,
      def: json['def'] as int,
      hp: json['hp'] as int,
    );
  }

  Map<String, num> toJson() {
    return <String, num>{
      'level': level,
      'atk': atk,
      'def': def,
      'hp': hp,
    };
  }

  factory IVs.max() {
    return IVs(
      level: Globals.maxPokemonLevel,
      atk: 15,
      def: 15,
      hp: 15,
    );
  }

  double level;
  int atk;
  int def;
  int hp;
}
