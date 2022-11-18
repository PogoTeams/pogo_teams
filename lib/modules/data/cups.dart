import '../../pogo_objects/pokemon_base.dart';

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
