// Dart
import 'dart:math';

// Local
import 'pokemon_typing.dart';
import 'move.dart';
import 'ratings.dart';
import 'pokemon_stats.dart';
import '../modules/data/stats.dart';
import '../modules/data/pokemon_types.dart';
import '../modules/data/gamemaster.dart';
import '../modules/data/globals.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class Pokemon {
  Pokemon({
    required this.dex,
    required this.pokemonId,
    required this.name,
    required this.typing,
    required this.stats,
    required this.fastMoves,
    required this.chargeMoves,
    required this.eliteFastMoveIds,
    required this.eliteChargeMoveIds,
    required this.thirdMoveCost,
    required this.shadow,
    required this.form,
    required this.familyId,
    required this.evolutions,
    required this.tempEvolutions,
    required this.released,
    required this.tags,
    required this.littleCupIVs,
    required this.greatLeagueIVs,
    required this.ultraLeagueIVs,
    FastMove? selectedFastMove,
    List<ChargeMove>? selectedChargeMoves,
    this.currentRating = 0,
  })  : selectedFastMove = selectedFastMove ?? FastMove.none,
        selectedChargeMoves =
            selectedChargeMoves ?? List<ChargeMove>.filled(2, ChargeMove.none);

  factory Pokemon.fromJson(
    Map<String, dynamic> json, {
    bool shadowForm = false,
  }) {
    List<FastMove> fastMoves = [];
    if (json.containsKey('fastMoves')) {
      for (String moveId in List<String>.from(json['fastMoves'])) {
        fastMoves.add(Gamemaster().getFastMoveById(moveId));
      }
    } else {
      fastMoves = [];
    }

    List<ChargeMove> chargeMoves = [];
    if (json.containsKey('chargeMoves')) {
      for (String moveId in List<String>.from(json['chargeMoves'])) {
        chargeMoves.add(Gamemaster().getChargeMoveById(moveId));
      }
    }

    List<String>? eliteFastMoveIds;
    if (json.containsKey('eliteFastMoves')) {
      eliteFastMoveIds = List<String>.from(json['eliteFastMoves']);
      for (String moveId in List<String>.from(json['eliteFastMoves'])) {
        fastMoves.add(Gamemaster().getFastMoveById(moveId));
      }
    }

    List<String>? eliteChargeMoveIds;
    if (json.containsKey('eliteChargeMoves')) {
      eliteChargeMoveIds = List<String>.from(json['eliteChargeMoves']);
      for (String moveId in List<String>.from(json['eliteChargeMoves'])) {
        chargeMoves.add(Gamemaster().getChargeMoveById(moveId));
      }
    }

    if (json.containsKey('shadow') &&
        json['shadow']['released'] &&
        !shadowForm) {
      String purifiedChargeMove =
          json['shadow']['purifiedChargeMove'] as String;
      chargeMoves.add(Gamemaster().getChargeMoveById(purifiedChargeMove));
    }

    List<String> tags = [];
    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);
    }

    if (shadowForm) {
      tags.add('shadow');
    }

    return Pokemon(
      dex: json['dex'] as int,
      pokemonId: (shadowForm ? json['shadow']['pokemonId'] : json['pokemonId'])
          as String,
      name: json['name'] as String,
      typing: PokemonTyping.fromJson(json['typing']),
      stats: json.containsKey('stats')
          ? BaseStats.fromJson(json['stats'])
          : BaseStats.empty(),
      fastMoves: fastMoves,
      chargeMoves: chargeMoves,
      eliteFastMoveIds: eliteFastMoveIds,
      eliteChargeMoveIds: eliteChargeMoveIds,
      thirdMoveCost: json.containsKey('thirdMoveCost')
          ? ThirdMoveCost.fromJson(json['thirdMoveCost'])
          : null,
      shadow:
          json.containsKey('shadow') ? Shadow.fromJson(json['shadow']) : null,
      form: json['form'] as String,
      familyId: json['familyId'] as String,
      evolutions: json.containsKey('evolutions')
          ? List<Map<String, dynamic>>.from(json['evolutions'])
              .map((evolutionJson) => Evolution.fromJson(evolutionJson))
              .toList()
          : null,
      tempEvolutions: json.containsKey('tempEvolutions')
          ? List<Map<String, dynamic>>.from(json['tempEvolutions'])
              .map((tempEvoJson) => TempEvolution.fromJson(tempEvoJson))
              .toList()
          : null,
      released:
          (shadowForm ? json['shadow']['released'] : json['released']) as bool,
      tags: tags.isEmpty ? null : tags,
      littleCupIVs: json.containsKey('littlecupsivs')
          ? IVs.fromJson(json['littlecupsivs'])
          : null,
      greatLeagueIVs: json.containsKey('greatLeagueIVs')
          ? IVs.fromJson(json['greatLeagueIVs'])
          : null,
      ultraLeagueIVs: json.containsKey('ultraLeagueIVs')
          ? IVs.fromJson(json['ultraLeagueIVs'])
          : null,
    );
  }

  factory Pokemon.tempEvolutionFromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> overridesJson,
  ) {
    List<FastMove> fastMoves = [];
    if (json.containsKey('fastMoves')) {
      for (String moveId in List<String>.from(json['fastMoves'])) {
        fastMoves.add(Gamemaster().getFastMoveById(moveId));
      }
    } else {
      fastMoves = [];
    }

    List<ChargeMove> chargeMoves = [];
    if (json.containsKey('chargeMoves')) {
      for (String moveId in List<String>.from(json['chargeMoves'])) {
        chargeMoves.add(Gamemaster().getChargeMoveById(moveId));
      }
    }

    List<String>? eliteFastMoveIds;
    if (json.containsKey('eliteFastMoves')) {
      eliteFastMoveIds = List<String>.from(json['eliteFastMoves']);
      for (String moveId in List<String>.from(json['eliteFastMoves'])) {
        fastMoves.add(Gamemaster().getFastMoveById(moveId));
      }
    }

    List<String>? eliteChargeMoveIds;
    if (json.containsKey('eliteChargeMoves')) {
      eliteChargeMoveIds = List<String>.from(json['eliteChargeMoves']);
      for (String moveId in List<String>.from(json['eliteChargeMoves'])) {
        chargeMoves.add(Gamemaster().getChargeMoveById(moveId));
      }
    }

    List<String> tags = [];
    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);
    }

    String tempEvolutionId = overridesJson['tempEvolutionId'] as String;
    if (tempEvolutionId.contains('mega')) {
      tags.add('mega');
    }

    return Pokemon(
      dex: json['dex'] as int,
      pokemonId: overridesJson['pokemonId'] as String,
      name: json['name'] as String,
      typing: PokemonTyping.fromJson(overridesJson['typing']),
      stats: overridesJson.containsKey('stats')
          ? BaseStats.fromJson(json['stats'])
          : BaseStats.empty(),
      fastMoves: fastMoves,
      chargeMoves: chargeMoves,
      eliteFastMoveIds: eliteFastMoveIds,
      eliteChargeMoveIds: eliteChargeMoveIds,
      thirdMoveCost: json.containsKey('thirdMoveCost')
          ? ThirdMoveCost.fromJson(json['thirdMoveCost'])
          : null,
      shadow: null,
      form: json['form'] as String,
      familyId: json['familyId'] as String,
      evolutions: null,
      tempEvolutions: null,
      released: overridesJson['released'] as bool,
      tags: tags,
      littleCupIVs: overridesJson.containsKey('littlecupsivs')
          ? IVs.fromJson(overridesJson['littlecupsivs'])
          : null,
      greatLeagueIVs: overridesJson.containsKey('greatLeagueIVs')
          ? IVs.fromJson(overridesJson['greatLeagueIVs'])
          : null,
      ultraLeagueIVs: overridesJson.containsKey('ultraLeagueIVs')
          ? IVs.fromJson(overridesJson['ultraLeagueIVs'])
          : null,
    );
  }

  static Pokemon from(Pokemon other) {
    return Pokemon(
      dex: other.dex,
      pokemonId: other.pokemonId,
      name: other.name,
      typing: other.typing,
      stats: other.stats,
      fastMoves: other.fastMoves,
      chargeMoves: other.chargeMoves,
      eliteFastMoveIds:
          other.eliteFastMoveIds != null ? other.eliteFastMoveIds! : null,
      eliteChargeMoveIds:
          other.eliteChargeMoveIds != null ? other.eliteChargeMoveIds! : null,
      thirdMoveCost: other.thirdMoveCost,
      shadow: other.shadow,
      form: other.form,
      familyId: other.familyId,
      evolutions: other.evolutions,
      tempEvolutions: other.tempEvolutions,
      released: other.released,
      tags: other.tags,
      littleCupIVs: other.littleCupIVs,
      greatLeagueIVs: other.greatLeagueIVs,
      ultraLeagueIVs: other.ultraLeagueIVs,
      selectedFastMove: other.selectedFastMove,
      selectedChargeMoves: other.selectedChargeMoves,
    );
  }

  factory Pokemon.fromUserTeamJson(Map<String, dynamic> json) {
    Pokemon pokemon =
        Pokemon.from(Gamemaster().getPokemonById(json['pokemonId']));

    String fastMoveId = json['moveset']['fastMove'] as String;
    pokemon.selectedFastMove = Gamemaster().getFastMoveById(fastMoveId);

    List<String> chargeMoveIds =
        List<String>.from(json['moveset']['chargeMoves']);
    pokemon.selectedChargeMoves = [
      Gamemaster().getChargeMoveById(chargeMoveIds.first),
      Gamemaster().getChargeMoveById(chargeMoveIds.last),
    ];

    pokemon.selectedIVs = IVs.fromJson(json['ivs']);

    return pokemon;
  }

  Map<String, dynamic> toUserTeamJson(int pokemonIndex) {
    return {
      'pokemonId': pokemonId,
      'pokemonIndex': pokemonIndex,
      'ivs': selectedIVs.toJson(),
      'moveset': {
        'fastMove': selectedFastMove.moveId,
        'chargeMoves': [
          selectedChargeMoves.first.moveId,
          selectedChargeMoves.last.moveId,
        ],
      }
    };
  }

  final int dex;
  final String pokemonId;
  final String name;
  final PokemonTyping typing;
  final BaseStats stats;
  final List<FastMove> fastMoves;
  final List<ChargeMove> chargeMoves;
  final List<String>? eliteFastMoveIds;
  final List<String>? eliteChargeMoveIds;
  final ThirdMoveCost? thirdMoveCost;
  final Shadow? shadow;
  final String form;
  final String familyId;
  final List<Evolution>? evolutions;
  final List<TempEvolution>? tempEvolutions;
  final bool released;
  final List<String>? tags;
  final IVs? littleCupIVs;
  final IVs? greatLeagueIVs;
  final IVs? ultraLeagueIVs;

  IVs selectedIVs = IVs.empty();
  FastMove selectedFastMove;
  List<ChargeMove> selectedChargeMoves;
  num currentRating;

  // Form a string that describes this Pokemon's typing
  String get typeString => typing.toString();

  String get ratingString => currentRating.toString();

  num get statsProduct => stats.atk * stats.def * stats.hp;

  // Get the type effectiveness of this Pokemon, factoring in current moveset
  List<double> get defenseEffectiveness => typing.defenseEffectiveness;

  // Get a list of all fast move names
  List<String> get fastMoveNames =>
      fastMoves.map((FastMove move) => move.name).toList();

  // Get a list of all fast move ids
  List<String> get fastMoveIds =>
      fastMoves.map((FastMove move) => move.moveId).toList();

  // Get a list of all charge move names
  List<String> get chargeMoveNames =>
      chargeMoves.map<String>((ChargeMove move) => move.name).toList();

  // Get a list of all charge move ids
  List<String> get chargeMoveIds =>
      chargeMoves.map<String>((ChargeMove move) => move.moveId).toList();

  bool get isShadow => tags?.contains('shadow') ?? false;
  bool get isMega => tags?.contains('mega') ?? false;
  bool get isMonoType => typing.isMonoType;

  List<Move> get moveset => [selectedFastMove, ...selectedChargeMoves];

  // Go through the moveset typing, accumulate the best type effectiveness
  List<double> get offenseCoverage {
    List<double> offenseCoverage = [];
    final fast = selectedFastMove.type.offenseEffectiveness;
    final c1 = selectedChargeMoves.first.type.offenseEffectiveness;
    List<double> c2;

    if ((selectedChargeMoves.last.isNone)) {
      c2 = List.filled(Globals.typeCount, 0.0);
    } else {
      c2 = selectedChargeMoves.last.type.offenseEffectiveness;
    }

    for (int i = 0; i < Globals.typeCount; ++i) {
      offenseCoverage
          .add([fast[i], c1[i], c2[i]].reduce((v1, v2) => (v1 > v2 ? v1 : v2)));
    }

    return offenseCoverage;
  }

  double getOffenseEffectivenessFromTyping(PokemonTyping typing) {
    List<double> coverage = offenseCoverage;
    if (typing.isMonoType) {
      return coverage[PokemonTypes.typeIndexMap[typing.typeA.typeId]!];
    }

    return coverage[PokemonTypes.typeIndexMap[typing.typeA.typeId]!] *
        coverage[PokemonTypes.typeIndexMap[typing.typeB?.typeId]!];
  }

  // If the move is an elite move, slap a * on there to make it special
  String getFormattedMoveName(Move move) {
    if (isEliteMove(move)) {
      return '${move.name}*';
    }
    return move.name;
  }

  bool isEliteMove(Move move) {
    if (move is FastMove) {
      return eliteFastMoveIds?.contains(move.moveId) ?? false;
    }
    return eliteChargeMoveIds?.contains(move.moveId) ?? false;
  }

  // True if one of the specified types exists in this Pokemon's typing
  bool hasType(List<PokemonType> types) {
    return typing.containsType(types);
  }

  // True if this Pokemon's selected moveset contains one of the types
  bool hasSelectedMovesetType(List<PokemonType> types) {
    for (PokemonType type in types) {
      if (type.isSameType(selectedFastMove.type) ||
          type.isSameType(selectedChargeMoves.first.type) ||
          type.isSameType(selectedChargeMoves.last.type)) {
        return true;
      }
    }

    return false;
  }

  IVs getIvs(int cpCap) {
    switch (cpCap) {
      case 500:
        return littleCupIVs!;
      case 1500:
        return greatLeagueIVs!;
      case 2500:
        return ultraLeagueIVs!;
      default:
        return IVs.max();
    }
  }
}

class ThirdMoveCost {
  ThirdMoveCost({
    required this.stardust,
    required this.candy,
  });

  factory ThirdMoveCost.fromJson(Map<String, dynamic> json) {
    return ThirdMoveCost(
      stardust: json['stardust'] ?? 0,
      candy: json['candy'] as int,
    );
  }

  final int stardust;
  final int candy;
}

class Shadow {
  Shadow({
    required this.pokemonId,
    required this.purificationStardust,
    required this.purificationCandy,
    required this.purifiedChargeMove,
    required this.shadowChargeMove,
    required this.released,
  });

  factory Shadow.fromJson(Map<String, dynamic> json) {
    return Shadow(
      pokemonId: json['pokemonId'] as String,
      purificationStardust: json['purificationStardust'] as int,
      purificationCandy: json['purificationCandy'] as int,
      purifiedChargeMove: json['purifiedChargeMove'] as String,
      shadowChargeMove: json['shadowChargeMove'] as String,
      released: json['released'] as bool,
    );
  }

  final String pokemonId;
  final int purificationStardust;
  final int purificationCandy;
  final String purifiedChargeMove;
  final String shadowChargeMove;
  final bool released;
}

class Evolution {
  Evolution({
    required this.pokemonId,
    required this.candyCost,
    required this.form,
    required this.purifiedEvolutionCost,
  });

  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(
      pokemonId: json['pokemonId'] as String,
      candyCost: json['candyCost'] as int,
      form: json['form'] as String?,
      purifiedEvolutionCost: json['purifiedEvolutionCost'] as int?,
    );
  }

  final String pokemonId;
  final int candyCost;
  final String? form;
  final int? purifiedEvolutionCost;
}

class TempEvolution {
  TempEvolution({
    required this.tempEvolutionId,
    required this.typing,
    required this.stats,
    required this.released,
  });

  factory TempEvolution.fromJson(Map<String, dynamic> json) {
    return TempEvolution(
      tempEvolutionId: json['tempEvolutionId'],
      typing: PokemonTyping.fromJson(json['typing']),
      stats: BaseStats.fromJson(json['stats']),
      released: json['released'] as bool,
    );
  }

  final String tempEvolutionId;
  final PokemonTyping typing;
  final BaseStats stats;
  final bool released;
}

// Pokemon instance for simulating battles
class BattlePokemon extends Pokemon {
  BattlePokemon({
    required dex,
    required pokemonId,
    required name,
    required typing,
    required stats,
    required fastMoves,
    required chargeMoves,
    required eliteFastMoveIds,
    required eliteChargeMoveIds,
    required thirdMoveCost,
    required shadow,
    required form,
    required familyId,
    required evolutions,
    required tempEvolutions,
    required released,
    required tags,
    required littleCupIVs,
    required greatLeagueIVs,
    required ultraLeagueIVs,
  }) : super(
          dex: dex,
          pokemonId: pokemonId,
          name: name,
          typing: typing,
          stats: stats,
          fastMoves: fastMoves,
          chargeMoves: chargeMoves,
          eliteFastMoveIds: eliteFastMoveIds,
          eliteChargeMoveIds: eliteChargeMoveIds,
          thirdMoveCost: thirdMoveCost,
          shadow: shadow,
          form: form,
          familyId: familyId,
          evolutions: evolutions,
          tempEvolutions: tempEvolutions,
          released: released,
          tags: tags,
          littleCupIVs: littleCupIVs,
          greatLeagueIVs: greatLeagueIVs,
          ultraLeagueIVs: ultraLeagueIVs,
        );

  static BattlePokemon fromPokemon(Pokemon other) {
    return BattlePokemon(
      dex: other.dex,
      pokemonId: other.pokemonId,
      name: other.name,
      typing: other.typing,
      stats: other.stats,
      fastMoves: List<FastMove>.from(other.fastMoves)
          .map((move) => FastMove.from(move))
          .toList(),
      chargeMoves: List<ChargeMove>.from(other.chargeMoves)
          .map((move) => ChargeMove.from(move))
          .toList(),
      eliteFastMoveIds:
          other.eliteFastMoveIds != null ? other.eliteFastMoveIds! : null,
      eliteChargeMoveIds:
          other.eliteChargeMoveIds != null ? other.eliteChargeMoveIds! : null,
      thirdMoveCost: other.thirdMoveCost,
      shadow: other.shadow,
      form: other.form,
      familyId: other.familyId,
      evolutions: other.evolutions,
      tempEvolutions: other.tempEvolutions,
      released: other.released,
      tags: other.tags,
      littleCupIVs: other.littleCupIVs,
      greatLeagueIVs: other.greatLeagueIVs,
      ultraLeagueIVs: other.ultraLeagueIVs,
    );
  }

  static BattlePokemon from(
    BattlePokemon other, {
    ChargeMove? nextDecidedChargeMove,
    bool prioritizeMoveAlignment = false,
  }) {
    BattlePokemon copy = BattlePokemon(
      dex: other.dex,
      pokemonId: other.pokemonId,
      name: other.name,
      typing: other.typing,
      stats: other.stats,
      fastMoves: other.fastMoves,
      chargeMoves: other.chargeMoves,
      eliteFastMoveIds:
          other.eliteFastMoveIds != null ? other.eliteFastMoveIds! : null,
      eliteChargeMoveIds:
          other.eliteChargeMoveIds != null ? other.eliteChargeMoveIds! : null,
      thirdMoveCost: other.thirdMoveCost,
      shadow: other.shadow,
      form: other.form,
      familyId: other.familyId,
      evolutions: other.evolutions,
      tempEvolutions: other.tempEvolutions,
      released: other.released,
      tags: other.tags,
      littleCupIVs: other.littleCupIVs,
      greatLeagueIVs: other.greatLeagueIVs,
      ultraLeagueIVs: other.ultraLeagueIVs,
    );

    copy.selectedIVs = other.selectedIVs;
    copy.cp = other.cp;
    copy.maxHp = other.maxHp;
    copy.currentHp = other.currentHp;
    copy.currentShields = other.currentShields;
    copy.cooldown = other.cooldown;
    copy.energy = other.energy;
    copy.chargeTDO = other.chargeTDO;
    copy.chargeEnergyDelta = other.chargeEnergyDelta;

    copy.selectedFastMove = other.selectedFastMove;
    copy.selectedChargeMoves = other.selectedChargeMoves;

    copy._atkBuffStage = other._atkBuffStage;
    copy._defBuffStage = other._defBuffStage;

    if (nextDecidedChargeMove != null) {
      copy.nextDecidedChargeMove = nextDecidedChargeMove;
    }

    copy.prioritizeMoveAlignment = prioritizeMoveAlignment;

    return copy;
  }

  late final num maxHp;
  num cp = 0;
  num currentHp = 0.0;
  int currentShields = 0;
  int cooldown = 0;
  num energy = 0;
  num chargeTDO = 0;
  num chargeEnergyDelta = 0;
  bool prioritizeMoveAlignment = false;
  ChargeMove nextDecidedChargeMove = ChargeMove.none;

  int _atkBuffStage = 4;
  int _defBuffStage = 4;

  // The damage output per energy spent in a battle
  num get chargeDPE =>
      (chargeEnergyDelta == 0 ? 0 : chargeTDO / chargeEnergyDelta).abs();

  num get currentHpRatio => currentHp / maxHp;
  num get damageRecievedRatio => (maxHp - currentHp) / maxHp;

  // Attack buff
  num get atkBuff => Stats.getBuffMultiplier(_atkBuffStage);
  void updateAtkBuff(int buff) {
    _atkBuffStage += buff;
    if (buff > 0) {
      _atkBuffStage = min(8, _atkBuffStage);
    } else {
      _atkBuffStage = max(0, _atkBuffStage);
    }
  }

  // Defense buff
  num get defBuff => Stats.getBuffMultiplier(_defBuffStage);
  void updateDefBuff(int buff) {
    _defBuffStage += buff;
    if (buff > 0) {
      _defBuffStage = min(8, _defBuffStage);
    } else {
      _defBuffStage = max(0, _defBuffStage);
    }
  }

  bool get hasShield {
    return currentShields != 0;
  }

  void useShield() {
    currentShields -= 1;
  }

  void applyFastMoveDamage(BattlePokemon opponent) {
    energy += selectedFastMove.energyDelta;
    opponent.recieveDamage(selectedFastMove.damage);
  }

  void applyChargeMoveDamage(BattlePokemon opponent) {
    energy += nextDecidedChargeMove.energyDelta;
    if (opponent.hasShield) {
      opponent.useShield();
    } else {
      chargeTDO += opponent.recieveDamage(nextDecidedChargeMove.damage);
      chargeEnergyDelta += nextDecidedChargeMove.energyDelta;
    }

    if (nextDecidedChargeMove.buffs != null) {
      applyChargeMoveBuff(nextDecidedChargeMove, opponent);
    }
  }

  void applyChargeMoveBuff(ChargeMove chargeMove, BattlePokemon opponent) {
    if (chargeMove.buffs!.selfAttack != null) {
      updateAtkBuff(chargeMove.buffs!.selfAttack!);
    }
    if (chargeMove.buffs!.selfDefense != null) {
      updateDefBuff(chargeMove.buffs!.selfDefense!);
    }
    if (chargeMove.buffs!.opponentAttack != null) {
      opponent.updateAtkBuff(chargeMove.buffs!.opponentAttack!);
    }
    if (chargeMove.buffs!.opponentDefense != null) {
      opponent.updateDefBuff(chargeMove.buffs!.opponentDefense!);
    }
  }

  num recieveDamage(num damage) {
    num prevHp = currentHp;
    currentHp = max(0, currentHp - damage);
    return prevHp - currentHp;
  }

  bool isKO(num damage) {
    return damage >= currentHp;
  }

  // Given a cp cap, give the Pokemon the ideal stats and moveset
  void initialize(int cpCap) {
    selectedIVs = getIvs(cpCap);

    // Calculate maxCp
    cp = Stats.calculateCP(stats, selectedIVs);

    // Calculate battle hp (stamina)
    maxHp = Stats.calculateMaxHp(stats, selectedIVs);
  }

  // Bring that bar back
  void resetHp() {
    currentHp = maxHp;
  }

  void resetCooldown({int modifier = 0}) {
    cooldown = selectedFastMove.duration + modifier;
  }

  void selectMoveset(BattlePokemon opponent) {
    if (chargeMoves.isEmpty || fastMoves.isEmpty) return;

    // Find the charge move with highest damage per energy
    chargeMoves.sort((move1, move2) =>
        (move1.dpe > move2.dpe ? -1 : ((move2.dpe > move1.dpe) ? 1 : 0)));
    num highestDpe = chargeMoves.first.dpe;

    _sortByRating(chargeMoves);
    ChargeMove highestRated = chargeMoves.first;

    // For moves that have a strictly better preference, sharply reduce usage
    num ratingsSum = highestRated.rating;

    for (var i = 1; i < chargeMoves.length; i++) {
      for (var n = 0; n < i; n++) {
        if ((chargeMoves[i].type == chargeMoves[n].type) &&
            (chargeMoves[i].energyDelta >= chargeMoves[n].energyDelta) &&
            (chargeMoves[i].dpe / chargeMoves[n].dpe < 1.3)) {
          chargeMoves[i].rating *= .5;
          break;
        }
      }

      ratingsSum += chargeMoves[i].rating;
    }

    if (ratingsSum > 0) {
      for (var move in chargeMoves) {
        move.calculateEffectiveDamage(this, opponent);

        // Normalize move rating
        move.rating = ((move.rating / ratingsSum) * 100).round();
      }
    }

    _sortByRating(chargeMoves);
    highestRated = chargeMoves.first;

    ratingsSum = 0;
    num baseline = Move.calculateCycleDpt(FastMove.none, highestRated);

    for (var move in fastMoves) {
      move.calculateEffectiveDamage(this, opponent);

      num cycleDpt = Move.calculateCycleDpt(move, highestRated);
      cycleDpt = max(cycleDpt - baseline, .1);

      move.rating = cycleDpt * pow(move.rating, max(highestDpe - 1, 1));
      ratingsSum += move.rating;
    }

    if (ratingsSum > 0) {
      // Normalize move rating
      for (var move in fastMoves) {
        move.rating = ((move.rating / ratingsSum) * 100).round();
      }
    }

    _sortByRating(fastMoves);

    selectedFastMove = fastMoves.first;
    selectedChargeMoves.first = chargeMoves[0];
    if (chargeMoves.length > 1) {
      selectedChargeMoves.last = chargeMoves[1];
    }
  }

  void _sortByRating(List<Move> moves) {
    moves.sort((move1, move2) => (move1.rating > move2.rating
        ? -1
        : ((move2.rating > move1.rating) ? 1 : 0)));
  }

  // Go through the moveset typing, accumulate the best type effectiveness
  List<double> getOffenseCoverage() {
    List<double> offenseCoverage = [];
    final fast = selectedFastMove.type.offenseEffectiveness;
    final c1 = selectedChargeMoves[0].type.offenseEffectiveness;
    List<double> c2;

    if ((selectedChargeMoves.last.isNone)) {
      c2 = List.filled(Globals.typeCount, 0.0);
    } else {
      c2 = selectedChargeMoves[1].type.offenseEffectiveness;
    }

    for (int i = 0; i < Globals.typeCount; ++i) {
      offenseCoverage.add(_max(fast[i], c1[i], c2[i]));
    }

    return offenseCoverage;
  }

  // Get the max value among the 3 provided values
  double _max(double v1, double v2, double v3) {
    if (v1 > v2) {
      if (v1 > v3) return v1;
      return v3;
    }

    if (v2 > v3) return v2;
    return v3;
  }

  num get effectiveAttack {
    return atkBuff *
        (stats.atk + selectedIVs.atk) *
        Stats.getCpMultiplier(selectedIVs.level) *
        (isShadow ? Stats.shadowAtkMultiplier : 1);
  }

  num get effectiveDefense {
    return defBuff *
        (stats.def + selectedIVs.def) *
        Stats.getCpMultiplier(selectedIVs.level) *
        (isShadow ? Stats.shadowDefMultiplier : 1);
  }
}

class RankedPokemon extends Pokemon {
  RankedPokemon({
    required dex,
    required pokemonId,
    required name,
    required typing,
    required baseStats,
    required fastMoves,
    required chargeMoves,
    required eliteFastMoveIds,
    required eliteChargeMoveIds,
    required thirdMoveCost,
    required shadow,
    required form,
    required familyId,
    required evolutions,
    required tempEvolutions,
    required released,
    required tags,
    required littleCupIVs,
    required greatLeagueIVs,
    required ultraLeagueIVs,
    required selectedIVs,
    required this.ratings,
    required selectedFastMove,
    required selectedChargeMoves,
  })  : cp = Stats.calculateCP(baseStats, selectedIVs),
        super(
          dex: dex,
          pokemonId: pokemonId,
          name: name,
          typing: typing,
          stats: baseStats,
          fastMoves: fastMoves,
          chargeMoves: chargeMoves,
          eliteFastMoveIds: eliteFastMoveIds,
          eliteChargeMoveIds: eliteChargeMoveIds,
          thirdMoveCost: thirdMoveCost,
          shadow: shadow,
          form: form,
          familyId: familyId,
          evolutions: evolutions,
          tempEvolutions: tempEvolutions,
          released: released,
          tags: tags,
          littleCupIVs: littleCupIVs,
          greatLeagueIVs: greatLeagueIVs,
          ultraLeagueIVs: ultraLeagueIVs,
          currentRating: ratings.overall,
        ) {
    this.selectedIVs = selectedIVs;
    this.selectedFastMove = selectedFastMove;
    this.selectedChargeMoves = selectedChargeMoves;
  }

  static RankedPokemon fromPokemon(
    Pokemon other,
    IVs ivs,
    Ratings ratings,
    FastMove selectedFastMove,
    List<ChargeMove> selectedChargeMoves,
  ) {
    return RankedPokemon(
      dex: other.dex,
      pokemonId: other.pokemonId,
      name: other.name,
      typing: other.typing,
      baseStats: other.stats,
      fastMoves: other.fastMoves,
      chargeMoves: other.chargeMoves,
      eliteFastMoveIds:
          other.eliteFastMoveIds != null ? other.eliteFastMoveIds! : null,
      eliteChargeMoveIds:
          other.eliteChargeMoveIds != null ? other.eliteChargeMoveIds! : null,
      thirdMoveCost: other.thirdMoveCost,
      shadow: other.shadow,
      form: other.form,
      familyId: other.familyId,
      evolutions: other.evolutions,
      tempEvolutions: other.tempEvolutions,
      released: other.released,
      tags: other.tags,
      littleCupIVs: other.littleCupIVs,
      greatLeagueIVs: other.greatLeagueIVs,
      ultraLeagueIVs: other.ultraLeagueIVs,
      selectedIVs: ivs,
      ratings: ratings,
      selectedFastMove: selectedFastMove,
      selectedChargeMoves: selectedChargeMoves,
    );
  }

  final int cp;
  final Ratings ratings;
}
