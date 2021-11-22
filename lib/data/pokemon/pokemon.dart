// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'typing.dart';
import 'move.dart';
import 'stats.dart';
import '../../tools/max.dart';
import '../cup.dart';
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

  // VARIABLES
  late Move selectedFastMove = fastMoves[0];
  late List<Move> selectedChargedMoves = [chargedMoves[0], chargedMoves[1]];
  num rating = 0;

  // Deep copy
  static Pokemon from(Pokemon other) {
    final Pokemon pokemonCopy = Pokemon(
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

    pokemonCopy.setMoveset(other.selectedFastMove, other.selectedChargedMoves);
    pokemonCopy.setRating(other.rating);

    return pokemonCopy;
  }

  void setRating(num r) {
    rating = r;
  }

  // Form a string that describes this Pokemon's typing
  String getTypeString() {
    return typing.toString();
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
  List<Image> getTypeIcons({String iconColor = 'white'}) {
    return typing.isMonoType()
        ? [typing.typeA.getIcon(iconColor: iconColor)]
        : [
            typing.typeA.getIcon(iconColor: iconColor),
            typing.typeB.getIcon(iconColor: iconColor),
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
  void setMoveset(Move fastMove, List<Move> chargedMoves) {
    selectedFastMove = fastMove;
    selectedChargedMoves = chargedMoves;
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
}
