// Packages
import 'package:isar/isar.dart';

// Local
import 'pokemon_base.dart';
import 'pokemon_typing.dart';
import 'move.dart';
import 'ratings.dart';
import 'pokemon_stats.dart';
import '../enums/rankings_categories.dart';

part 'pokemon.g.dart';

/*
-------------------------------------------------------------------- @PogoTeams
-------------------------------------------------------------------------------
*/

class Pokemon {
  Pokemon({
    required this.ratings,
    required this.ivs,
    required this.selectedFastMoveId,
    required this.selectedChargeMoveIds,
    PokemonBase? base,
  }) {
    this.base.value = base;
  }

  Id id = Isar.autoIncrement;

  Ratings ratings;
  IVs ivs;
  String selectedFastMoveId;
  List<String> selectedChargeMoveIds;
  final IsarLink<PokemonBase> base = IsarLink<PokemonBase>();

  PokemonBase getBase() {
    if (base.isAttached && (base.value == null || !base.isLoaded)) {
      base.loadSync();
    }

    return base.value ?? PokemonBase.missingNo();
  }

  FastMove getSelectedFastMove() {
    return getBase().getFastMoves().firstWhere(
        (move) => move.moveId == selectedFastMoveId,
        orElse: () => getBase().getFastMoves().first);
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

@Collection(accessor: 'cupPokemon')
class CupPokemon extends Pokemon {
  CupPokemon({
    required Ratings ratings,
    required IVs ivs,
    required String selectedFastMoveId,
    required List<String> selectedChargeMoveIds,
    PokemonBase? base,
  }) : super(
          ratings: ratings,
          ivs: ivs,
          selectedFastMoveId: selectedFastMoveId,
          selectedChargeMoveIds: selectedChargeMoveIds,
          base: base,
        );

  factory CupPokemon.from(CupPokemon other) {
    return CupPokemon(
      ratings: other.ratings,
      ivs: other.ivs,
      selectedFastMoveId: other.selectedFastMoveId,
      selectedChargeMoveIds: List<String>.from(other.selectedChargeMoveIds),
      base: other.getBase(),
    );
  }
}

@Collection(accessor: 'userPokemon')
class UserPokemon extends Pokemon {
  UserPokemon({
    required Ratings ratings,
    required IVs ivs,
    required String selectedFastMoveId,
    required List<String> selectedChargeMoveIds,
    PokemonBase? base,
    this.teamIndex,
  }) : super(
          ratings: ratings,
          ivs: ivs,
          selectedFastMoveId: selectedFastMoveId,
          selectedChargeMoveIds: selectedChargeMoveIds,
          base: base,
        );

  factory UserPokemon.fromPokemon(Pokemon other) {
    return UserPokemon(
      ratings: other.ratings,
      ivs: other.ivs,
      selectedFastMoveId: other.selectedFastMoveId,
      selectedChargeMoveIds: List<String>.from(other.selectedChargeMoveIds),
      base: other.getBase(),
    );
  }

  int? teamIndex;
}
