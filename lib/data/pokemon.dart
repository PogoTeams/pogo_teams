import 'package:flutter/material.dart';
import 'typing.dart';
import 'move.dart';

/*
Pokemon is the encapsulation of a single Pokemon and all of its characteristics
GameMaster manages the list of all Pokemon which are of this class type
*/
class Pokemon {
  Pokemon({
    required this.dex,
    required this.speciesName,
    required this.speciesId,
    required this.baseStats,
    required this.typing,
    required this.fastMoves,
    required this.chargedMoves,
    required this.defaultIVs,
    this.thirdMoveCost,
    this.released,
    this.tags,
    this.eliteMoves,
    this.isShadow = false,
  });

  // JSON -> OBJ conversion
  factory Pokemon.fromJson(Map<String, dynamic> json, List<Move> moves) {
    final dex = json['dex'] as int;
    final speciesName = json['speciesName'] as String;
    final speciesId = json['speciesId'] as String;
    final baseStats = BaseStats.fromJson(json['baseStats']);
    final typing = Typing(List<String>.from(json['types']));
    final fastMoveKeys = List<String>.from(json['fastMoves']);
    final chargedMoveKeys = List<String>.from(json['chargedMoves']);

    // For UI purposes, any Pokemon with only 1 possible charged move will have
    // an additional 2nd charge move called 'none'.
    if (chargedMoveKeys.length == 1) chargedMoveKeys.add('NONE');

    // Setup the lists of Moves this Pokemon can learn
    final List<Move> fastMoves =
        moves.where((move) => fastMoveKeys.contains(move.moveId)).toList();
    final List<Move> chargedMoves =
        moves.where((move) => chargedMoveKeys.contains(move.moveId)).toList();

    final defaultIVs = DefaultIVs.fromJson(json['defaultIVs']);

    var thirdMoveCost = json['thirdMoveCost'];

    if (thirdMoveCost.runtimeType == bool) {
      thirdMoveCost = 0;
    }

    final released = json['released'] as bool?;
    List<String>? tags = [];
    List<String>? eliteMoves = [];

    if (json.containsKey('eliteMoves')) {
      eliteMoves = List<String>.from(json['eliteMoves']);
    }

    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);
    }

    return Pokemon(
      dex: dex,
      speciesName: speciesName,
      speciesId: speciesId,
      baseStats: baseStats,
      typing: typing,
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
  final String speciesId;
  final BaseStats baseStats;
  final Typing typing;
  final List<Move> fastMoves;
  final List<Move> chargedMoves;
  final DefaultIVs defaultIVs;

  // OPTIONAL
  final int? thirdMoveCost;
  final bool? released;
  final List<String>? tags;
  final List<String>? eliteMoves;

  // VARIABLES
  bool isShadow = false;
  late Move selectedFastMove = getMetaFastMove();
  late List<Move> selectedChargedMoves = getMetaChargedMoves();

  // Form a string that describes this Pokemon's typing
  String getTypeString() {
    return typing.toString();
  }

  List<Color> getTypeColors() {
    return typing.getColors();
  }

  List<Image> getTypeIcons({String iconColor = 'color'}) {
    return typing.isMonoType()
        ? [typing.typeA.getIcon(iconColor: iconColor)]
        : [
            typing.typeA.getIcon(iconColor: iconColor),
            typing.typeB.getIcon(iconColor: iconColor),
          ];
  }

  // Get the offensive & defensive effectiveness of this Pokemon's typing
  List<double> getDefenseEffectiveness() {
    return typing.getDefenseEffectiveness();
  }

  //TODO
  // Determine the most meta-relevant fast move and return it
  Move getMetaFastMove() {
    return fastMoves[0];
  }

  //TODO
  // Determine the most meta-relevant charged moves and return it
  List<Move> getMetaChargedMoves() {
    return [chargedMoves[0], chargedMoves[1]];
  }

  // Update the selected fast move slot with the provided name
  void updateSelectedFastMove(String? newFastMove) {
    if (newFastMove == null) return;

    selectedFastMove = fastMoves.firstWhere((move) => move.name == newFastMove);
  }

  // 0) charged 1
  // 1) charged 2
  // Update the specified charged move slot with the provided name
  void updateSelectedChargedMove(int index, String? newChargedMove) {
    if (newChargedMove == null) return;

    selectedChargedMoves[index] =
        chargedMoves.firstWhere((move) => move.name == newChargedMove);
  }

  // Get a list of all fast move names
  List<String> getFastMoveNames() {
    return fastMoves.map<String>((Move move) {
      return move.name;
    }).toList();
  }

  // Get a list of all charged move names
  List<String> getChargedMoveNames() {
    return chargedMoves.map<String>((Move move) {
      return move.name;
    }).toList();
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

  factory BaseStats.fromJson(Map<String, dynamic> json) {
    final atk = json['atk'] as int;
    final def = json['def'] as int;
    final hp = json['hp'] as int;

    return BaseStats(
      atk: atk,
      def: def,
      hp: hp,
    );
  }

  final int atk;
  final int def;
  final int hp;
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
}
