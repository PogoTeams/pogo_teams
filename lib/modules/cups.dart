import '../model/pokemon_base.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Additional static Cup-related data.
-------------------------------------------------------------------------------
*/

class Cups {
  static const Map<int, int> cpMinimums = {
    500: 300,
    1500: 1200,
    2500: 2200,
    9999: 2500,
  };

  static const List<String> permaBanList = [
    'ditto',
    'smeargle',
    'shedinja',
  ];

  static bool isBanned(PokemonBase pokemon, int cpCap) {
    return permaBanList.contains(pokemon.pokemonId);
  }
}
