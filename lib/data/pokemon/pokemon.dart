// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'typing.dart';
import 'move.dart';
import 'stats.dart';
import '../../tools/logic.dart';
import '../masters/cp_master.dart';
import '../globals.dart' as globals;

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
    required this.shadowEligible,
    required this.isXs,
    required this.isShadow,
    this.released,
    this.tags,
    this.eliteMoves,
  });

  // Deep copy
  static Pokemon from(Pokemon other) {
    final copy = Pokemon(
      dex: other.dex,
      speciesName: other.speciesName,
      speciesId: other.speciesId,
      baseStats: other.baseStats,
      typing: other.typing,
      fastMoves: other.fastMoves,
      chargedMoves: other.chargedMoves,
      defaultIVs: other.defaultIVs,
      shadowEligible: other.shadowEligible,
      isXs: other.isXs,
      isShadow: other.isShadow,
      released: other.released,
      tags: other.tags,
      eliteMoves: other.eliteMoves,
    );

    copy.setMoveset(
      other.selectedFastMove.moveId,
      other.selectedChargedMoves.map((move) => move.moveId).toList(),
    );

    copy.setRating(other.rating);

    return copy;
  }

  // JSON -> OBJ conversion
  factory Pokemon.fromJson(Map<String, dynamic> json, List<Move> moves) {
    final dex = json['dex'] as int;
    String speciesName = json['speciesName'] as String;
    final speciesId = json['speciesId'] as String;
    final baseStats = BaseStats.fromJson(json['baseStats']);
    final typing = Typing(List<String>.from(json['types']));
    final fastMoveKeys = List<String>.from(json['fastMoves']);
    final chargedMoveKeys = List<String>.from(json['chargedMoves']);
    final released = json['released'] as bool?;
    List<String>? tags = [];
    List<String>? eliteMoves = [];
    bool shadowEligible = false;
    bool isXs = false;
    bool isShadow = false;

    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);

      // Add Return to Pokemon that can be shadow / purified
      // Currently, the pvpoke ratings have shadows as a separate instance
      if (tags.contains('shadoweligible')) {
        shadowEligible = true;
        chargedMoveKeys.add('RETURN');
      } else if (tags.contains('shadow')) {
        isShadow = true;
        shadowEligible = true;
        chargedMoveKeys.add('FRUSTRATION');

        // Instead of the name showing shadow, there will be an icon
        speciesName = speciesName.replaceFirst(' (Shadow)', '');
      }

      // XL candy Pokemon
      isXs = tags.contains('xs');
    }

    // For UI purposes, any Pokemon with only 1 possible charged move will have
    // an additional 2nd charge move called 'none'.
    if (chargedMoveKeys.length == 1) chargedMoveKeys.add('NONE');

    // Setup the lists of Moves this Pokemon can learn
    final List<Move> fastMoves =
        moves.where((move) => fastMoveKeys.contains(move.moveId)).toList();
    final List<Move> chargedMoves =
        moves.where((move) => chargedMoveKeys.contains(move.moveId)).toList();

    final defaultIVs = DefaultIVs.fromJson(json['defaultIVs']);

    if (json.containsKey('eliteMoves')) {
      eliteMoves = List<String>.from(json['eliteMoves']);
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
      released: released,
      tags: tags,
      eliteMoves: eliteMoves,
      shadowEligible: shadowEligible,
      isXs: isXs,
      isShadow: isShadow,
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
  final bool shadowEligible;
  final bool isXs;
  bool isShadow;

  // OPTIONAL
  final bool? released;
  final List<String>? tags;
  final List<String>? eliteMoves;

  // Form a string that describes this Pokemon's typing
  String getTypeString() {
    return typing.toString();
  }

  // If the move is an elite move, slap a * on there to make it special
  String getFormattedMoveName(Move move) {
    if (isElite(move.moveId)) {
      return move.name.padRight(move.name.length + 1, ' *');
    }
    return move.name;
  }

  bool isElite(String moveId) {
    return eliteMoves == null ? false : eliteMoves!.contains(moveId);
  }

  // True if one of the specified types exists in this Pokemon's typing
  bool hasType(List<Type> types) {
    return typing.containsType(types);
  }

  // Get the color(s) of this Pokemon's typing
  // If this Pokemon is monotype, this will be a single element list
  List<Color> getTypeColors() {
    return typing.getColors();
  }

  // Get the icon(s) of this Pokemon's typing
  List<Image> getTypeIcons() {
    return typing.isMonoType()
        ? [typing.typeA.getIcon()]
        : [
            typing.typeA.getIcon(),
            typing.typeB.getIcon(),
          ];
  }

  // Given a cpCap cooresponding to a PVP cup :
  // Get a list of the perfect cp stats
  // [0] : level
  // [1] : atk iv
  // [2] : def iv
  // [3] : hp iv
  // [4] : cp
  List<num> getPerfectPvpStats(int cpCap) {
    // Get the perfect PVP ivs
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

  /* --- POKEMON STATE
   * All Pokemon state is managed below
  */

  // The current selected moves for this Pokemon
  late Move selectedFastMove = fastMoves[0];
  late List<Move> selectedChargedMoves = [chargedMoves[0], chargedMoves[1]];

  // The rating of this Pokemon given a cup
  num rating = 0;

  void setRating(num r) {
    rating = r;
  }

  // This json will contain moveset info and an id
  // This id is used to retrieve an actual Pokemon ref from the idMap
  static Pokemon? fromStateJson(dynamic json, Map<String, Pokemon> idMap) {
    if (json == null) return null;

    Pokemon stateJson = Pokemon.from(idMap[json['speciesId']]!);

    stateJson.setMoveset(json['selectedFastMove'] as String,
        List<String>.from(json['selectedChargedMoves']));

    return stateJson;
  }

  // For writing out to local storage
  Map<String, dynamic> toStateJson() {
    return {
      'speciesId': speciesId,
      'selectedFastMove': selectedFastMove.moveId,
      'selectedChargedMoves': [
        selectedChargedMoves[0].moveId,
        selectedChargedMoves[1].moveId,
      ],
    };
  }

  List<Color> getMoveColors() {
    return [
      selectedFastMove.type.typeColor,
      selectedChargedMoves[0].type.typeColor,
      selectedChargedMoves[1].type.typeColor,
    ];
  }

  // Get the type effectiveness of this Pokemon, factoring in current moveset
  List<double> getDefenseEffectiveness() {
    return typing.getDefenseEffectiveness();
  }

  // Go through the moveset typing, accumulate the best type effectiveness
  List<double> getOffenseCoverage() {
    List<double> offenseCoverage = [];
    final fast = selectedFastMove.type.getOffenseEffectiveness();
    final c1 = selectedChargedMoves[0].type.getOffenseEffectiveness();
    List<double> c2;

    if ((selectedChargedMoves[1].moveId == 'NONE')) {
      c2 = List.filled(globals.typeCount, 0.0);
    } else {
      c2 = selectedChargedMoves[1].type.getOffenseEffectiveness();
    }

    for (int i = 0; i < globals.typeCount; ++i) {
      offenseCoverage.add(max(fast[i], c1[i], c2[i]));
    }

    return offenseCoverage;
  }

  // Set the moveset for this Pokemon (used in 'from' constructor)
  void setMoveset(String fastMoveId, List<String> chargedMoveIds) {
    selectedFastMove =
        fastMoves.firstWhere((move) => move.moveId == fastMoveId);

    selectedChargedMoves = [
      chargedMoves.firstWhere((move) => move.moveId == chargedMoveIds[0]),
      chargedMoves.firstWhere((move) => move.moveId == chargedMoveIds[1]),
    ];
  }

  // Set the selected moves to the relatively most powerful moves
  // Because of ever-changing meta this is not necessarily a perfect algorithm
  void initializeMetaMoves(List<String> moveIds) {
    selectedFastMove = getMetaFastMove(moveIds[0]);
    if (moveIds.length < 3) {
      getMetaChargedMoves(moveIds[1], 'NONE');
    } else {
      selectedChargedMoves = getMetaChargedMoves(moveIds[1], moveIds[2]);
    }
  }

  // Determine the most meta-relevant fast move and return it
  Move getMetaFastMove(String fastId) {
    final Move? fast = fastMoves.firstWhere((move) => move.moveId == fastId);

    return fast!;
  }

  // Determine the most meta-relevant charged moves and return it
  List<Move> getMetaChargedMoves(String chargeId1, String chargeId2) {
    final c1 = chargedMoves.firstWhere((move) => move.moveId == chargeId1);
    final c2 = chargedMoves.firstWhere((move) => move.moveId == chargeId2);

    return [c1, c2];
  }

  // Update the selected fast move slot with the provided name
  void updateSelectedFastMove(Move? newFastMove) {
    if (newFastMove == null) return;

    selectedFastMove = newFastMove;
  }

  // 0) charged 1
  // 1) charged 2
  // Update the specified charged move slot with the provided name
  void updateSelectedChargedMove(int index, Move? newChargedMove) {
    if (newChargedMove == null) return;

    selectedChargedMoves[index] = newChargedMove;
  }

  // Get a list of all fast move names
  List<String> getFastMoveIds() {
    return fastMoves.map<String>((Move move) {
      return move.moveId;
    }).toList();
  }

  // Get a list of all charged move names
  List<String> getChargedMoveIds() {
    return chargedMoves.map<String>((Move move) {
      return move.moveId;
    }).toList();
  }
}
