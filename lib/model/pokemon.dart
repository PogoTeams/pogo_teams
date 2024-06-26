// Local
import 'dart:convert';

import 'pokemon_base.dart';
import 'pokemon_typing.dart';
import 'move.dart';
import 'ratings.dart';
import 'pokemon_stats.dart';
import 'battle_pokemon.dart';
import '../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A instance of a Pokemon, holding information that is specific to a Cup. Cup
Pokemon are displayed to the user in various places throughout the app. They
can choose to add Cup Pokemon to their team. An instance of the User Pokemon
is added to a user's team.
-------------------------------------------------------------------------------
*/

class Pokemon {
  Pokemon({
    required this.ratings,
    required this.ivs,
    required this.selectedFastMoveId,
    required this.selectedChargeMoveIds,
    this.base,
  });

  Ratings ratings;
  IVs ivs;
  String selectedFastMoveId;
  List<String> selectedChargeMoveIds;
  PokemonBase? base;

  PokemonBase getBase() {
    return base ?? PokemonBase.missingNo();
  }

  FastMove getSelectedFastMove() {
    return getBase().getFastMoves().firstWhere(
        (move) => move.moveId == selectedFastMoveId,
        orElse: () => FastMove.none);
  }

  List<ChargeMove> getSelectedChargeMoves() {
    return [
      getBase().getChargeMoves().firstWhere(
          (move) => selectedChargeMoveIds.first == move.moveId,
          orElse: () => ChargeMove.none),
      getBase().getChargeMoves().firstWhere(
          (move) => selectedChargeMoveIds.last == move.moveId,
          orElse: () => ChargeMove.none),
    ].whereType<ChargeMove>().toList();
  }

  Future<PokemonBase> getBaseAsync() async {
    return base ?? PokemonBase.missingNo();
  }

  Future<FastMove> getSelectedFastMoveAsync() async {
    return (await (await getBaseAsync()).getFastMovesAsync()).firstWhere(
        (move) => move.moveId == selectedFastMoveId,
        orElse: () => FastMove.none);
  }

  Future<List<ChargeMove>> getSelectedChargeMovesAsync() async {
    return [
      (await (await getBaseAsync()).getChargeMovesAsync()).firstWhere(
          (move) => selectedChargeMoveIds.first == move.moveId,
          orElse: () => ChargeMove.none),
      (await (await getBaseAsync()).getChargeMovesAsync()).firstWhere(
          (move) => selectedChargeMoveIds.last == move.moveId,
          orElse: () => ChargeMove.none),
    ].whereType<ChargeMove>().toList();
  }

  ChargeMove getSelectedChargeMoveL() {
    return getBase().getChargeMoves().firstWhere(
        (move) => move.moveId == selectedChargeMoveIds.first,
        orElse: () => getBase().getChargeMoves().first);
  }

  ChargeMove getSelectedChargeMoveR() {
    return getBase().getChargeMoves().firstWhere(
        (move) => move.moveId == selectedChargeMoveIds.last,
        orElse: () => getBase().getChargeMoves().first);
  }

  void initializeStats(int cpCap) {
    ivs = getBase().getIvs(cpCap);
  }

  // Get a list of all fast move names
  List<String> fastMoveNames() =>
      getBase().getFastMoves().map((FastMove move) => move.name).toList();

  // Get a list of all fast move ids
  List<String> fastMoveIds() =>
      getBase().getFastMoves().map((FastMove move) => move.moveId).toList();

  // Get a list of all charge move names
  List<String> chargeMoveNames() => getBase()
      .getChargeMoves()
      .map<String>((ChargeMove move) => move.name)
      .toList();

  // Get a list of all charge move ids
  List<String> chargeMoveIds() => getBase()
      .getChargeMoves()
      .map<String>((ChargeMove move) => move.moveId)
      .toList();

  List<Move> moveset() => [getSelectedFastMove(), ...getSelectedChargeMoves()];

  String getRating(RankingsCategories rankingsCategory) =>
      ratings.getRating(rankingsCategory);

  // True if this Pokemon's selected moveset contains one of the types
  bool hasSelectedMovesetType(List<PokemonType> types) {
    for (PokemonType type in types) {
      if (type.isSameType(getSelectedFastMove().type) ||
          type.isSameType(getSelectedChargeMoveL().type) ||
          type.isSameType(getSelectedChargeMoveR().type)) {
        return true;
      }
    }

    return false;
  }
}

class CupPokemon extends Pokemon {
  CupPokemon({
    required super.ratings,
    required super.ivs,
    required super.selectedFastMoveId,
    required super.selectedChargeMoveIds,
    super.base,
  });

  factory CupPokemon.from(CupPokemon other) {
    return CupPokemon(
      ratings: other.ratings,
      ivs: other.ivs,
      selectedFastMoveId: other.selectedFastMoveId,
      selectedChargeMoveIds: List<String>.from(other.selectedChargeMoveIds),
      base: other.getBase(),
    );
  }

  factory CupPokemon.fromBattlePokemon(BattlePokemon other, PokemonBase base) {
    return CupPokemon(
      ratings: Ratings(),
      ivs: other.selectedIVs,
      selectedFastMoveId: other.selectedBattleFastMove.moveId,
      selectedChargeMoveIds: [
        other.selectedBattleChargeMoves.first.moveId,
        other.selectedBattleChargeMoves.last.moveId,
      ],
      base: base,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pokemonId': getBase().pokemonId,
      'ratings': ratings.toJson(),
      'ivs': ivs.toJson(),
      'idealMoveset': {
        'fastMove': selectedFastMoveId,
        'chargeMoves': jsonEncode(selectedChargeMoveIds),
      },
    };
  }
}

class UserPokemon extends Pokemon {
  UserPokemon({
    required super.ratings,
    required super.ivs,
    required super.selectedFastMoveId,
    required super.selectedChargeMoveIds,
    super.base,
    this.teamIndex,
  });

  factory UserPokemon.fromJson(Map<String, dynamic> json) {
    return UserPokemon(
      ratings: Ratings.fromJson(json['ratings']),
      ivs: IVs.fromJson(json['ivs']),
      selectedFastMoveId: json['selectedFastMoveId'] as String,
      selectedChargeMoveIds:
          List<String>.from(jsonDecode(json['selectedChargeMoveIds'])),
      teamIndex: json['teamIndex'],
    );
  }

  factory UserPokemon.fromPokemon(Pokemon other) {
    return UserPokemon(
      ratings: other.ratings,
      ivs: other.ivs,
      selectedFastMoveId: other.selectedFastMoveId,
      selectedChargeMoveIds: List<String>.from(other.selectedChargeMoveIds),
      base: other.getBase(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pokemonId': getBase().pokemonId,
      'ratings': ratings.toJson(),
      'ivs': ivs.toJson(),
      'selectedFastMoveId': selectedFastMoveId,
      'selectedChargeMoveIds': jsonEncode(selectedChargeMoveIds),
      'teamIndex': teamIndex,
    };
  }

  int? teamIndex;
}
