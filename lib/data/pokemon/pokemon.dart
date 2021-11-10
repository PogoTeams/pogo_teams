// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'typing.dart';
import 'move.dart';
import 'stats.dart';
import '../cup.dart';
import '../masters/cp_master.dart';

/*
-------------------------------------------------------------------------------
Pokemon is the encapsulation of a single Pokemon and all of its traits.
Additionally, there are instance related variables that determine the 
relative 'state' of a pokemon. The 'state' is effected by various user UI
interactions, such as the selected cup, the selected moveset, or if it is
a shadow Pokemon.
-------------------------------------------------------------------------------
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
  bool isShadow;
  late Move selectedFastMove;
  late List<Move> selectedChargedMoves;

  // Deep copy
  static Pokemon from(Pokemon other) {
    return Pokemon(
      dex: other.dex,
      speciesName: other.speciesName,
      speciesId: other.speciesId,
      baseStats: other.baseStats,
      typing: other.typing,
      fastMoves: other.fastMoves,
      chargedMoves: other.chargedMoves,
      defaultIVs: other.defaultIVs,
      thirdMoveCost: other.thirdMoveCost,
      released: other.released,
      tags: other.tags,
      eliteMoves: other.eliteMoves,
    );
  }

  // Form a string that describes this Pokemon's typing
  String getTypeString() {
    return typing.toString();
  }

  // Get the color(s) of this Pokemon's typing
  // If this Pokemon is monotype, this will be a single element list
  List<Color> getTypeColors() {
    return typing.getColors();
  }

  // Get the icon(s) of this Pokemon's typing
  List<Image> getTypeIcons({String iconColor = 'color'}) {
    return typing.isMonoType()
        ? [typing.typeA.getIcon(iconColor: iconColor)]
        : [
            typing.typeA.getIcon(iconColor: iconColor),
            typing.typeB.getIcon(iconColor: iconColor),
          ];
  }

  // Get the defensive effectiveness of this Pokemon's typing.
  // Each index of the list represents the accumulative effectiveness
  // scale of a given type on this Pokemon's typing.
  List<double> getDefenseEffectiveness() {
    return typing.getDefenseEffectiveness();
  }

  // Set the selected moves to the relatively most powerful moves
  // Because of ever-changing meta this is not necessarily a perfect algorithm
  void initializeMetaMoves() {
    selectedFastMove = getMetaFastMove();
    selectedChargedMoves = getMetaChargedMoves();
  }

  // Determine the most meta-relevant fast move and return it
  Move getMetaFastMove() {
    return fastMoves[0];
  }

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

  // Return the perfect PVP ivs this Pokemon has for the provided cup
  List<num> getPerfectPvpIvs(Cup cup) {
    return defaultIVs.getIvs(cup.cp);
  }

  // Given a cpCap cooresponding to a PVP cup :
  // Get a list of the perfect cp stats
  // [0] : level
  // [1] : atk iv
  // [2] : def iv
  // [3] : hp iv
  // [4] : cp
  // TODO : class abstraction
  List<num> getPerfectPvpStats(int cpCap) {
    // Get the perfect PVP ivs
    // [0] is the Pokemon's level cooresponding to those ivs
    List<num> pvpStats = defaultIVs.getIvs(cpCap);

    // Get the maxCp
    pvpStats.add(CpMaster.getMaxCP(
      getStatTotals(pvpStats),
      getMaxLevelIndex(pvpStats[0]),
    ));

    return pvpStats;
  }

  // Get the total attack, defense and hp stats
  // stat total = base stat + iv stat
  List<num> getStatTotals(List<num> ivs) {
    return [
      baseStats.atk + ivs[1],
      baseStats.def + ivs[2],
      baseStats.hp + ivs[3],
    ];
  }

  // Get the max level index of a Pokemon given the cpCap
  int getMaxLevelIndex(num level) {
    return ((level * 2) - 2).toInt();
  }
}
