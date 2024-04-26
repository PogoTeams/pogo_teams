// Packages
import 'package:isar/isar.dart';

// Local
import 'pokemon_typing.dart';
import 'move.dart';
import 'pokemon_stats.dart';

part 'pokemon_base.g.dart';

/*
-------------------------------------------------------------------- @PogoTeams
This is the base class for several Pokemon abstractions. All information that
isn't related to state is managed here.
-------------------------------------------------------------------------------
*/

@Collection(accessor: 'basePokemon')
class PokemonBase {
  PokemonBase({
    required this.dex,
    required this.pokemonId,
    required this.name,
    required this.typing,
    required this.stats,
    this.eliteFastMoveIds,
    this.eliteChargeMoveIds,
    this.thirdMoveCost,
    this.shadow,
    required this.form,
    required this.familyId,
    required this.released,
    this.tags,
    this.littleCupIVs,
    this.greatLeagueIVs,
    this.ultraLeagueIVs,
  });

  factory PokemonBase.fromJson(
    Map<String, dynamic> json, {
    bool shadowForm = false,
  }) {
    List<String>? tags;
    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);
    }

    if (shadowForm) {
      tags ??= [];
      tags.add('shadow');
    }

    return PokemonBase(
      dex: json['dex'] as int,
      pokemonId: (shadowForm ? json['shadow']['pokemonId'] : json['pokemonId'])
          as String,
      name: json['name'] as String,
      typing: PokemonTyping.fromJson(json['typing']),
      stats: json.containsKey('stats')
          ? BaseStats.fromJson(json['stats'])
          : BaseStats(),
      eliteFastMoveIds: json.containsKey('eliteFastMoves')
          ? List<String>.from(json['eliteFastMoves'])
          : null,
      eliteChargeMoveIds: json.containsKey('eliteChargeMove')
          ? List<String>.from(json['eliteChargeMove'])
          : null,
      thirdMoveCost: json.containsKey('thirdMoveCost')
          ? ThirdMoveCost.fromJson(json['thirdMoveCost'])
          : null,
      shadow:
          json.containsKey('shadow') ? Shadow.fromJson(json['shadow']) : null,
      form: json['form'] as String,
      familyId: json['familyId'] as String,
      released:
          (shadowForm ? json['shadow']['released'] : json['released']) as bool,
      tags: tags,
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

  factory PokemonBase.tempEvolutionFromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> overridesJson,
  ) {
    List<String> tags = [];
    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);
    }

    String tempEvolutionId = overridesJson['tempEvolutionId'] as String;
    if (tempEvolutionId.contains('mega')) {
      tags.add('mega');
    }

    return PokemonBase(
      dex: json['dex'] as int,
      pokemonId: overridesJson['pokemonId'] as String,
      name: json['name'] as String,
      typing: PokemonTyping.fromJson(overridesJson['typing']),
      stats: overridesJson.containsKey('stats')
          ? BaseStats.fromJson(overridesJson['stats'])
          : BaseStats.fromJson(json['stats']),
      eliteFastMoveIds: json.containsKey('eliteFastMoves')
          ? List<String>.from(json['eliteFastMoves'])
          : null,
      eliteChargeMoveIds: json.containsKey('eliteChargeMove')
          ? List<String>.from(json['eliteChargeMove'])
          : null,
      thirdMoveCost: json.containsKey('thirdMoveCost')
          ? ThirdMoveCost.fromJson(json['thirdMoveCost'])
          : null,
      shadow: null,
      form: json['form'] as String,
      familyId: json['familyId'] as String,
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

  factory PokemonBase.missingNo() {
    return PokemonBase(
      dex: 0,
      pokemonId: 'missingNo',
      name: 'MissingNo.',
      typing: PokemonTyping(),
      stats: BaseStats(),
      form: '',
      familyId: '',
      released: false,
    );
  }

  Id id = Isar.autoIncrement;

  final int dex;
  @Index(unique: true)
  final String pokemonId;
  final String name;
  final PokemonTyping typing;
  final BaseStats stats;
  final IsarLinks<FastMove> fastMoves = IsarLinks<FastMove>();
  final IsarLinks<ChargeMove> chargeMoves = IsarLinks<ChargeMove>();
  final List<String>? eliteFastMoveIds;
  final List<String>? eliteChargeMoveIds;
  final ThirdMoveCost? thirdMoveCost;
  final Shadow? shadow;
  final String form;
  final String familyId;
  final IsarLinks<Evolution> evolutions = IsarLinks<Evolution>();
  final IsarLinks<TempEvolution> tempEvolutions = IsarLinks<TempEvolution>();
  final bool released;
  final List<String>? tags;
  final IVs? littleCupIVs;
  final IVs? greatLeagueIVs;
  final IVs? ultraLeagueIVs;

  IsarLinks<FastMove> getFastMoves() {
    if (fastMoves.isAttached && !fastMoves.isLoaded) {
      fastMoves.loadSync();
    }

    return fastMoves;
  }

  IsarLinks<ChargeMove> getChargeMoves() {
    if (chargeMoves.isAttached && !chargeMoves.isLoaded) {
      chargeMoves.loadSync();
    }

    return chargeMoves;
  }

  Future<IsarLinks<FastMove>> getFastMovesAsync() async {
    if (fastMoves.isAttached && !fastMoves.isLoaded) {
      await fastMoves.load();
    }

    return fastMoves;
  }

  Future<IsarLinks<ChargeMove>> getChargeMovesAsync() async {
    if (chargeMoves.isAttached && !chargeMoves.isLoaded) {
      await chargeMoves.load();
    }

    return chargeMoves;
  }

  IsarLinks<Evolution> getEvolutions() {
    if (evolutions.isAttached && !evolutions.isLoaded) {
      evolutions.loadSync();
    }

    return evolutions;
  }

  IsarLinks<TempEvolution> getTempEvolutions() {
    if (tempEvolutions.isAttached && !tempEvolutions.isLoaded) {
      tempEvolutions.loadSync();
    }

    return tempEvolutions;
  }

  // Form a string that describes this Pokemon's typing
  String typeString() => typing.toString();

  double statsProduct() => (stats.atk * stats.def * stats.hp).toDouble();

  // Get the type effectiveness of this Pokemon, factoring in current moveset
  List<double> defenseEffectiveness() => typing.defenseEffectiveness();

  bool isShadow() => tags?.contains('shadow') ?? false;
  bool isMega() => tags?.contains('mega') ?? false;
  bool isMonoType() => typing.isMonoType();

  // If the move is an elite move, slap a * on there to make it special
  String getFormattedMoveName(Move move) {
    if (isEliteMove(move)) {
      return '${move.name}*';
    }
    return move.name;
  }

  String getFormattedForm() {
    List<String> split = form.split('_');
    if (split.isEmpty || split.last.length < 2) return '';

    String last = split.last;
    return '${last[0].toUpperCase()}${last.substring(1)}';
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

@embedded
class ThirdMoveCost {
  ThirdMoveCost({
    this.stardust = 0,
    this.candy = 0,
  });

  factory ThirdMoveCost.fromJson(Map<String, dynamic> json) {
    return ThirdMoveCost(
      stardust: json['stardust'] ?? 0,
      candy: json['candy'] as int,
    );
  }

  int stardust;
  int candy;
}

@embedded
class Shadow {
  Shadow({
    this.pokemonId,
    this.purificationStardust,
    this.purificationCandy,
    this.purifiedChargeMove,
    this.shadowChargeMove,
    this.released,
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

  String? pokemonId;
  int? purificationStardust;
  int? purificationCandy;
  String? purifiedChargeMove;
  String? shadowChargeMove;
  bool? released;
}

@Collection(accessor: 'evolutions')
class Evolution {
  Evolution({
    this.pokemonId,
    this.candyCost,
    this.purifiedEvolutionCost,
  });

  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(
      pokemonId: json['pokemonId'] as String,
      candyCost: json['candyCost'] as int,
      purifiedEvolutionCost: json['purifiedEvolutionCost'] as int?,
    );
  }

  Id id = Isar.autoIncrement;

  String? pokemonId;
  int? candyCost;
  int? purifiedEvolutionCost;
}

@Collection(accessor: 'tempEvolutions')
class TempEvolution {
  TempEvolution({
    required this.tempEvolutionId,
    required this.typing,
    this.stats,
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

  Id id = Isar.autoIncrement;

  String? tempEvolutionId;
  PokemonTyping typing;
  BaseStats? stats;
  bool released;
}
