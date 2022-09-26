import '../pogo_data/pokemon.dart';

class Cups {
  static const Map<int, int> cpMinimums = {
    500: 300,
    1500: 1200,
    2500: 2200,
    9999: 2500,
  };

  static const Map<int, List<String>> ineligibleLists = {
    500: [],
    1500: [],
    2500: [],
    9999: [],
  };

  static const List<String> permaBanList = [
    'ditto',
    'smeargle',
  ];

  static bool isBanned(Pokemon pokemon, int cpCap) {
    return ineligibleLists[cpCap]!.contains(pokemon.pokemonId) ||
        permaBanList.contains(pokemon.pokemonId);
  }
}
