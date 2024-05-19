part of 'pokemon_list_bloc.dart';

class PokemonListState extends Equatable {
  const PokemonListState({
    this.selectedCup,
    this.pokemon,
    this.filteredPokemon,
    this.searchText = '',
    this.rankingsCategory = RankingsCategories.overall,
  });

  final Cup? selectedCup;
  final RankingsCategories rankingsCategory;
  final List<CupPokemon>? pokemon;
  final List<CupPokemon>? filteredPokemon;
  final String searchText;

  @override
  List<Object?> get props => [
        selectedCup,
        pokemon,
        searchText,
        filteredPokemon,
        rankingsCategory,
      ];

  PokemonListState copyWith({
    Cup? selectedCup,
    List<CupPokemon>? pokemon,
    List<CupPokemon>? filteredPokemon,
    String? searchText,
    RankingsCategories? rankingsCategory,
  }) =>
      PokemonListState(
        selectedCup: selectedCup ?? this.selectedCup,
        pokemon: pokemon ?? this.pokemon,
        filteredPokemon: filteredPokemon ?? this.filteredPokemon,
        searchText: searchText ?? this.searchText,
        rankingsCategory: rankingsCategory ?? this.rankingsCategory,
      );
}
