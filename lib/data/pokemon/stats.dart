/*
-------------------------------------------------------------------------------
All Pokemon stats are managed here. Every Pokemon has a BaseStats object that
manages a Pokemon's attack, defense, and hp. DefaultIVs contains a Pokemon's
100% IVs for each cp cap scenario (500, 1500, 2500, and 10000 : Master).
-------------------------------------------------------------------------------
*/

class BaseStats {
  BaseStats({
    required this.atk,
    required this.def,
    required this.hp,
  });

  factory BaseStats.fromJson(Map<String, dynamic> json) {
    final atk = json['atk'] as num;
    final def = json['def'] as num;
    final hp = json['hp'] as num;

    return BaseStats(
      atk: atk,
      def: def,
      hp: hp,
    );
  }

  final num atk;
  final num def;
  final num hp;
}

/*
Every Pokemon contains it's best IV set for each respective league in GBL
- cp500 -- Little League
- cp1500 -- Great League
- cp2500 -- Ultra League

DefaultIVs encapsulates these IV values
*/
class DefaultIVs {
  DefaultIVs({
    required this.cp500,
    required this.cp1500,
    required this.cp2500,
  });

  // JSON -> OBJ conversion
  factory DefaultIVs.fromJson(Map<String, dynamic> json) {
    final List<num> cp500 = List<num>.from(json['cp500']);
    final List<num> cp1500 = List<num>.from(json['cp1500']);
    final List<num> cp2500 = List<num>.from(json['cp2500']);

    return DefaultIVs(
      cp500: cp500,
      cp1500: cp1500,
      cp2500: cp2500,
    );
  }

  final List<num> cp500;
  final List<num> cp1500;
  final List<num> cp2500;

  // Given a cp cap, return the corresponding list of default IVs
  List<num> getIvs(int cpCap) {
    switch (cpCap) {
      case 500:
        return List.from(cp500);
      case 1500:
        return List.from(cp1500);
      case 2500:
        return List.from(cp2500);
      case 10000:
        return [50, 15, 15, 15];

      default:
        break;
    }

    return List.from(cp1500);
  }
}
