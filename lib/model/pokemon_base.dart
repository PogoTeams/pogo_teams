// Local
import 'package:pogo_teams/modules/pogo_repository.dart';

import 'pokemon_typing.dart';
import 'move.dart';
import 'pokemon_stats.dart';

/*
-------------------------------------------------------------------- @PogoTeams
This is the base class for several Pokemon abstractions. All information that
isn't related to state is managed here.
-------------------------------------------------------------------------------
*/

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
    Map<String, dynamic> json,
    PogoRepository pogoRepository, {
    bool shadowForm = false,
  }) {
    if (json['pokemonId'] == 'swampert_shadow') {
      print('swampert_shadow');
    }
    List<String>? tags;
    if (json.containsKey('tags')) {
      tags = List<String>.from(json['tags']);
    }

    if (shadowForm) {
      tags ??= [];
      tags.add('shadow');
    }

    final pokemonBase = PokemonBase(
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
      eliteChargeMoveIds: json.containsKey('eliteChargeMoves')
          ? List<String>.from(json['eliteChargeMoves'])
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
      littleCupIVs: json.containsKey('littleCupIVs')
          ? IVs.fromJson(json['littleCupIVs'])
          : null,
      greatLeagueIVs: json.containsKey('greatLeagueIVs')
          ? IVs.fromJson(json['greatLeagueIVs'])
          : null,
      ultraLeagueIVs: json.containsKey('ultraLeagueIVs')
          ? IVs.fromJson(json['ultraLeagueIVs'])
          : null,
    );

    if (json.containsKey('fastMoves')) {
      for (var moveId in List<String>.from(json['fastMoves'])) {
        pokemonBase.fastMoves.add(pogoRepository.getFastMoveById(moveId));
      }
    }

    if (json.containsKey('chargeMoves')) {
      for (var moveId in List<String>.from(json['chargeMoves'])) {
        pokemonBase.chargeMoves.add(pogoRepository.getChargeMoveById(moveId));
      }
    }

    if (json.containsKey('eliteFastMoves')) {
      for (var moveId in List<String>.from(json['eliteFastMoves'])) {
        pokemonBase.fastMoves.add(pogoRepository.getFastMoveById(moveId));
      }
    }

    if (json.containsKey('eliteChargeMoves')) {
      for (var moveId in List<String>.from(json['eliteChargeMoves'])) {
        pokemonBase.chargeMoves.add(pogoRepository.getChargeMoveById(moveId));
      }
    }

    if (json.containsKey('shadow') && json['shadow']['released']) {
      final moveId = json['shadow']['purifiedChargeMove'];
      pokemonBase.chargeMoves.add(pogoRepository.getChargeMoveById(moveId));
    }

    return pokemonBase;
  }

  Map<String, dynamic> toJson() {
    final json = {
      'dex': dex,
      'pokemonId': pokemonId,
      'name': name,
      'typing': typing.toJson(),
      'stats': stats.toJson(),
      'fastMoves': fastMoves.map((e) => e.moveId).toList(),
      'chargeMoves': chargeMoves.map((e) => e.moveId).toList(),
      'form': form,
      'familyId': familyId,
      'evolutions': evolutions.map((e) => e.toJson()).toList(),
      'tempEvolutions': tempEvolutions.map((e) => e.toJson()).toList(),
      'released': released,
    };

    if (tags != null) {
      json['tags'] = tags!;
    }

    if (eliteFastMoveIds != null) {
      json['eliteFastMoveIds'] = eliteFastMoveIds!;
    }

    if (eliteChargeMoveIds != null) {
      json['eliteChargeMoveIds'] = eliteChargeMoveIds!;
    }

    if (thirdMoveCost != null) {
      json['thirdMoveCost'] = thirdMoveCost!.toJson();
    }

    if (shadow != null) {
      json['shadow'] = shadow!.toJson();
    }

    if (littleCupIVs != null) {
      json['littleCupIVs'] = littleCupIVs!.toJson();
    }

    if (greatLeagueIVs != null) {
      json['greatLeagueIVs'] = greatLeagueIVs!.toJson();
    }

    if (ultraLeagueIVs != null) {
      json['ultraLeagueIVs'] = ultraLeagueIVs!.toJson();
    }

    return json;
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
      littleCupIVs: overridesJson.containsKey('littleCupIVs')
          ? IVs.fromJson(overridesJson['littleCupIVs'])
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

  final int dex;
  final String pokemonId;
  final String name;
  final PokemonTyping typing;
  final BaseStats stats;
  final List<FastMove> fastMoves = List<FastMove>.empty(growable: true);
  final List<ChargeMove> chargeMoves = List<ChargeMove>.empty(growable: true);
  final List<String>? eliteFastMoveIds;
  final List<String>? eliteChargeMoveIds;
  final ThirdMoveCost? thirdMoveCost;
  final Shadow? shadow;
  final String form;
  final String familyId;
  final List<Evolution> evolutions = List<Evolution>.empty(growable: true);
  final List<TempEvolution> tempEvolutions =
      List<TempEvolution>.empty(growable: true);
  final bool released;
  final List<String>? tags;
  final IVs? littleCupIVs;
  final IVs? greatLeagueIVs;
  final IVs? ultraLeagueIVs;

  List<FastMove> getFastMoves() {
    return fastMoves;
  }

  List<ChargeMove> getChargeMoves() {
    return chargeMoves;
  }

  Future<List<FastMove>> getFastMovesAsync() async {
    return fastMoves;
  }

  Future<List<ChargeMove>> getChargeMovesAsync() async {
    return chargeMoves;
  }

  List<Evolution> getEvolutions() {
    return evolutions;
  }

  List<TempEvolution> getTempEvolutions() {
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

  Map<String, dynamic> toJson() {
    return {
      'stardust': stardust,
      'candy': candy,
    };
  }

  int stardust;
  int candy;
}

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

  Map<String, dynamic> toJson() {
    return {
      'pokemonId': pokemonId,
      'purificationStardust': purificationStardust,
      'purificationCandy': purificationCandy,
      'purifiedChargeMove': purifiedChargeMove,
      'shadowChargeMove': shadowChargeMove,
      'released': released,
    };
  }

  String? pokemonId;
  int? purificationStardust;
  int? purificationCandy;
  String? purifiedChargeMove;
  String? shadowChargeMove;
  bool? released;
}

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

  Map<String, dynamic> toJson() {
    return {
      'pokemonId': pokemonId,
      'candyCost': candyCost,
      'purifiedEvolutionCost': purifiedEvolutionCost,
    };
  }

  String? pokemonId;
  int? candyCost;
  int? purifiedEvolutionCost;
}

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

  Map<String, dynamic> toJson() {
    return {
      'tempEvolutionId': tempEvolutionId,
      'typing': typing.toJson(),
      'stats': stats?.toJson(),
      'released': released,
    };
  }

  String? tempEvolutionId;
  PokemonTyping typing;
  BaseStats? stats;
  bool released;
}
