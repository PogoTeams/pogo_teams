import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pogo_teams/enums/rankings_categories.dart';
import 'package:pogo_teams/model/cup.dart';
import 'package:pogo_teams/model/pokemon.dart';
import 'package:pogo_teams/modules/pogo_repository.dart';

part 'pokemon_list_event.dart';
part 'pokemon_list_state.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  PokemonListBloc({required this.pogoRepository})
      : super(const PokemonListState()) {
    on<PokemonListLoaded>(_onPokemonListLoaded);
    on<SearchTextChanged>(_onSearchTextChanged);
    on<RankingsCategoryChanged>(_onRankingsCategoryChanged);
  }

  final PogoRepository pogoRepository;

  Future _onPokemonListLoaded(
      PokemonListLoaded event, Emitter<PokemonListState> emit) async {
    Cup cup = pogoRepository.getCupById('great_league');
    List<CupPokemon> pokemon = cup.getCupPokemonList(state.rankingsCategory);

    emit(
      state.copyWith(
        selectedCup: cup,
        pokemon: pokemon,
        filteredPokemon: pokemon,
      ),
    );
  }

  void _onSearchTextChanged(
      SearchTextChanged event, Emitter<PokemonListState> emit) async {
    if (state.pokemon == null) return;

    emit(
      state.copyWith(
        filteredPokemon: event.searchText.isEmpty
            ? state.pokemon!
            : getFilteredPokemonList(state.searchText, state.pokemon!),
        searchText: event.searchText,
      ),
    );
  }

  void _onRankingsCategoryChanged(
      RankingsCategoryChanged event, Emitter<PokemonListState> emit) {
    if (state.selectedCup == null) return;

    List<CupPokemon> pokemon =
        state.selectedCup!.getCupPokemonList(event.rankingsCategory);

    emit(
      state.copyWith(
        pokemon: pokemon,
        filteredPokemon: state.searchText.isEmpty
            ? pokemon
            : getFilteredPokemonList(state.searchText, pokemon),
        rankingsCategory: event.rankingsCategory,
      ),
    );
  }

  List<CupPokemon> getFilteredPokemonList(
      String searchText, List<CupPokemon> pokemon) {
    // Get the lowercase user input
    final String input = searchText.toLowerCase();

    // Split any comma seperated list into individual search terms
    final List<String> terms = input.split(', ');

    // Callback to filter Pokemon by the search terms
    // Filter by the search terms
    return pokemon
        .where((pokemon) => filterPokemonBySearchTerms(terms, pokemon))
        .toList();
  }

  bool filterPokemonBySearchTerms(List<String> terms, CupPokemon pokemon) {
    bool isMatch = false;

    for (String term in terms) {
      isMatch = pokemon.getBase().name.toLowerCase().startsWith(term) ||
          pokemon.getBase().typing.containsTypeId(term) ||
          pokemon.getBase().form.contains(term) ||
          term == 'shadow' && pokemon.getBase().isShadow();
    }

    return isMatch;
  }
}
