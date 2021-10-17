import 'package:flutter/material.dart';

/*
GameMaster contains all necessary information about the game
- A list of all Pokemon
- A list of all moves
*/

class GameMaster {
  GameMaster({
    required this.pokemon,
    required this.moves,
  });

  // JSON -> OBJ conversion
  factory GameMaster.fromJson(Map<String, dynamic> data) {
    final List<dynamic> pokeList = data['pokemon'];
    final List<dynamic> moveList = data['moves'];

    List<Pokemon> pokemon = [];
    List<Move> moves = [];

    // Callback for 'forEach'
    void parsePkm(json) {
      pokemon.add(Pokemon.fromJson(json));
    }

    // Callback for 'forEach'
    void parseMove(json) {
      moves.add(Move.fromJson(json));
    }

    // Populate the lists
    pokeList.forEach(parsePkm);
    moveList.forEach(parseMove);

    return GameMaster(
      pokemon: pokemon,
      moves: moves,
    );
  }

  // The master list of ALL pokemon
  List<Pokemon> pokemon;

  // The master list of ALL moves
  List<Move> moves;

  //DEBUG
  display() {
    pokemon.forEach((pkm) {
      pkm.display();
    });

    /*
    moves.forEach((mv) {
      mv.display();
    });
    */
  }
}

/*
Pokemon is the encapsulation of a single Pokemon and all of its characteristics
GameMaster manages the list of all Pokemon which are of this class type
*/
class Pokemon {
  const Pokemon({
    required this.dex,
    required this.speciesName,
    required this.isShadow,
    required this.speciesId,
    required this.baseStats,
    required this.types,
    required this.typeColor,
    required this.fastMoves,
    required this.chargedMoves,
    required this.defaultIVs,
    this.thirdMoveCost,
    this.released,
    this.tags,
    this.eliteMoves,
  });

  // JSON -> OBJ conversion
  factory Pokemon.fromJson(Map<String, dynamic> data) {
    final dex = data['dex'] as int;
    String speciesName = data['speciesName'] as String;
    bool isShadow = false;

    if (speciesName.endsWith(' (Shadow)')) {
      speciesName = speciesName.replaceAll(' (Shadow)', '');
      isShadow = true;
    }

    final speciesId = data['speciesId'] as String;
    final baseStats = BaseStats.fromJson(data['baseStats']);
    final types = List<String>.from(data['types']);
    final typeColor = typeColors[types[0]] as Color;
    final fastMoves = List<String>.from(data['fastMoves']);
    final chargedMoves = List<String>.from(data['chargedMoves']);
    final defaultIVs = DefaultIVs.fromJson(data['defaultIVs']);

    var thirdMoveCost = data['thirdMoveCost'];

    if (thirdMoveCost.runtimeType == bool) {
      thirdMoveCost = 0;
    }

    final released = data['released'] as bool?;
    List<String>? tags = [];
    List<String>? eliteMoves = [];

    if (data.containsKey('eliteMoves')) {
      tags = List<String>.from(data['eliteMoves']);
    }

    if (data.containsKey('tags')) {
      tags = List<String>.from(data['tags']);
    }

    return Pokemon(
      dex: dex,
      speciesName: speciesName,
      isShadow: isShadow,
      speciesId: speciesId,
      baseStats: baseStats,
      types: types,
      typeColor: typeColor,
      fastMoves: fastMoves,
      chargedMoves: chargedMoves,
      defaultIVs: defaultIVs,
      thirdMoveCost: thirdMoveCost,
      released: released,
      tags: tags,
      eliteMoves: eliteMoves,
    );
  }

  // REQUIRED
  final int dex;
  final String speciesName;
  final bool isShadow;
  final String speciesId;
  final BaseStats baseStats;
  final List<String> types;
  final Color typeColor;
  final List<String> fastMoves;
  final List<String> chargedMoves;
  final DefaultIVs defaultIVs;

  // OPTIONAL
  final int? thirdMoveCost;
  final bool? released;
  final List<String>? tags;
  final List<String>? eliteMoves;

  //DEBUG
  display() {
    print(dex);
    print(speciesName);
    print(speciesId);
    baseStats.display();
    print(types);
    print(fastMoves);
    print(chargedMoves);
    defaultIVs.display();
    print(thirdMoveCost);
    print(released);
    print(tags);
    print(eliteMoves);
  }
}

/*
Every Pokemon contains three stats :
attack
defense
hp

BaseStats encapsulates these stats
*/
class BaseStats {
  BaseStats({
    required this.atk,
    required this.def,
    required this.hp,
  });

  factory BaseStats.fromJson(Map<String, dynamic> data) {
    final atk = data['atk'] as int;
    final def = data['def'] as int;
    final hp = data['hp'] as int;

    return BaseStats(atk: atk, def: def, hp: hp);
  }

  final int atk;
  final int def;
  final int hp;

  display() {
    print(atk);
    print(def);
    print(hp);
  }
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
  factory DefaultIVs.fromJson(Map<String, dynamic> data) {
    final List<num> cp500 = List<num>.from(data['cp500']);
    final List<num> cp1500 = List<num>.from(data['cp1500']);
    final List<num> cp2500 = List<num>.from(data['cp2500']);

    return DefaultIVs(cp500: cp500, cp1500: cp1500, cp2500: cp2500);
  }

  final List<num> cp500;
  final List<num> cp1500;
  final List<num> cp2500;

  //DEBUG
  display() {
    print(cp500);
    print(cp1500);
    print(cp2500);
  }
}

class Move {
  Move({
    required this.moveId,
    required this.name,
    required this.type,
    required this.typeColor,
    required this.power,
    required this.energy,
    required this.cooldown,
    this.archetype,
    this.abbreviation,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    final moveId = json['moveId'] as String;
    final name = json['name'] as String;
    final type = json['type'] as String;
    final typeColor = typeColors[type] as Color;
    final power = json['power'] as num;
    final energy = json['energy'] as num;
    final cooldown = json['cooldown'] as num;

    final abbreviation = json['abbreviation'] as String?;
    final archetype = json['archetype'] as String?;

    return Move(
      moveId: moveId,
      name: name,
      type: type,
      typeColor: typeColor,
      power: power,
      energy: energy,
      cooldown: cooldown,
      abbreviation: abbreviation,
      archetype: archetype,
    );
  }

  final String moveId;
  final String name;
  final String type;
  final Color typeColor;
  final num power;
  final num energy;
  final num cooldown;
  final String? abbreviation;
  final String? archetype;

  //DEBUG
  display() {
    print(moveId);
    print(name);
    print(type);
    print(power);
    print(energy);
    print(cooldown);
    print(abbreviation);
    print(archetype);
  }
}

final Map<String, Color> typeColors = {
  "normal": const Color(0xFFA8A77A),
  "fire": const Color(0xFFEE8130),
  "water": const Color(0xFF6390F0),
  "electric": const Color(0xFFF7D02C),
  "grass": const Color(0xFF7AC74C),
  "ice": const Color(0xFF96D9D6),
  "fighting": const Color(0xFFC22E28),
  "poison": const Color(0xFFA33EA1),
  "ground": const Color(0xFFE2BF65),
  "flying": const Color(0xFFA98FF3),
  "psychic": const Color(0xFFF95587),
  "bug": const Color(0xFFA6B91A),
  "rock": const Color(0xFFB6A136),
  "ghost": const Color(0xFF735797),
  "dragon": const Color(0xFF6F35FC),
  "dark": const Color(0xFF705746),
  "steel": const Color(0xFFB7B7CE),
  "fairy": const Color(0xFFD685AD)
};
