class Globals {
  // The current app version
  // Displayed at the footer of the app's drawer
  static const String version = 'v1.0.0';

  // The earliest timestamp (used for initial app start up)
  static const String earliestTimestamp = '2021-01-01 00:00:00.00';

  // The number of Pokemon types in the game
  static const int typeCount = 18;

  // The most possible damage a type can have against another
  // ex. Scrafty (dark / fighting) : fairy would have 1.6^2 = 2.56 damage
  static const double maxEffectiveDamage = 2.56;

  static const int maxPokemonLevel = 50;

  // The max number of turns in a pvp battle
  // maxTurns = 4m * 60s * 2 (turns per second)
  static const maxPvpTurns = 480;

  static const maxPokemonEnergy = 100;

  static const pokemonRatingMagnitude = 1000;
  static const winShieldMultiplier = 100;
}
