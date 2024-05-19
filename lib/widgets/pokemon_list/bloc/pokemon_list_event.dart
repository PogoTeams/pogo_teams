part of 'pokemon_list_bloc.dart';

sealed class PokemonListEvent extends Equatable {
  const PokemonListEvent();
}

class PokemonListInitial extends PokemonListEvent {
  final List<CupPokemon> pokemon = [];

  @override
  List<Object?> get props => [pokemon];
}

class PokemonListLoaded extends PokemonListEvent {
  @override
  List<Object?> get props => [];
}

class SearchTextChanged extends PokemonListEvent {
  const SearchTextChanged({
    required this.searchText,
  });

  final String searchText;

  @override
  List<Object?> get props => [searchText];
}

class RankingsCategoryChanged extends PokemonListEvent {
  const RankingsCategoryChanged({
    required this.rankingsCategory,
  });

  final RankingsCategories rankingsCategory;

  @override
  List<Object?> get props => [rankingsCategory];
}
