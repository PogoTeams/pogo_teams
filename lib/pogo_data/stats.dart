import '../modules/globals.dart';

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
    required this.atk,
    required this.def,
    required this.hp,
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

  final int atk;
  final int def;
  final int hp;
}

class IVs {
  IVs({
    required this.level,
    required this.atk,
    required this.def,
    required this.hp,
  });

  factory IVs.fromJson(Map<String, dynamic> json) {
    return IVs(
      level: json['level'] as num,
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

  factory IVs.empty() {
    return IVs(
      level: 0,
      atk: 0,
      def: 0,
      hp: 0,
    );
  }

  factory IVs.max() {
    return IVs(
      level: Globals.maxPokemonLevel,
      atk: 15,
      def: 15,
      hp: 15,
    );
  }

  num level;
  int atk;
  int def;
  int hp;
}
