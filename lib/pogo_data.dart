import 'dart:convert';
import 'dart:io';

void main() async {
  // Fetch the gamemaster JSON file
  final gmFile = File('../assets/gamemaster.json');
  // Parse into string form
  final gmString = await gmFile.readAsString();
  // Decode to a map
  final gmJson = jsonDecode(gmString);
  final gamemaster = GameMaster.fromJson(gmJson);
  gamemaster.display();
}

/*
GameMaster contains all necessary information about the game
- A list of all Pokemon
- A list of all moves
*/
class GameMaster {
  GameMaster({required this.pokemon});

  // JSON -> OBJ conversion
  factory GameMaster.fromJson(Map<String, dynamic> data) {
    final List<dynamic> pokeList = data['pokemon'];

    List<Pokemon> pokemon = [];

    // Callback for 'forEach'
    parsePkm(json) {
      pokemon.add(Pokemon.fromJson(json));
    }

    pokeList.forEach(parsePkm);

    return GameMaster(pokemon: pokemon);
  }

  // The pokemon list of ALL pokemon
  List<Pokemon> pokemon;

  //DEBUG
  display() {
    pokemon.forEach((pkm) {
      pkm.display();
    });
  }
}

/*
Pokemon is the encapsulation of a single Pokemon and all of its characteristics
GameMaster manages the list of all Pokemon which are of this class type
*/
class Pokemon {
  Pokemon(
      {required this.dex,
      required this.speciesName,
      required this.speciesId,
      required this.baseStats,
      required this.types,
      required this.fastMoves,
      required this.chargedMoves,
      required this.defaultIVs,
      this.thirdMoveCost,
      this.released,
      this.tags,
      this.eliteMoves});

  // JSON -> OBJ conversion
  factory Pokemon.fromJson(Map<String, dynamic> data) {
    final dex = data['dex'] as int;
    final speciesName = data['speciesName'] as String;
    final speciesId = data['speciesId'] as String;
    final baseStats = BaseStats.fromJson(data['baseStats']);
    final types = List<String>.from(data['types']);
    final fastMoves = List<String>.from(data['fastMoves']);
    final chargedMoves = List<String>.from(data['chargedMoves']);
    final defaultIVs = DefaultIVs.fromJson(data['defaultIVs']);

    var thirdMoveCost = data['thirdMoveCost'];

    if (thirdMoveCost.runtimeType == bool) {
      thirdMoveCost = 0;
    }

    final released = data['released'] as bool?;
    List<String>? tags = [];
    List<String>? eliteMoves = [];

    if (data.containsKey('eliteMoves')) {
      tags = List<String>.from(data['eliteMoves']);
    }

    if (data.containsKey('tags')) {
      tags = List<String>.from(data['tags']);
    }

    return Pokemon(
        dex: dex,
        speciesName: speciesName,
        speciesId: speciesId,
        baseStats: baseStats,
        types: types,
        fastMoves: fastMoves,
        chargedMoves: chargedMoves,
        defaultIVs: defaultIVs,
        thirdMoveCost: thirdMoveCost,
        released: released,
        tags: tags,
        eliteMoves: eliteMoves);
  }

  // REQUIRED
  final int dex;
  final String speciesName;
  final String speciesId;
  final BaseStats baseStats;
  final List<String> types;
  final List<String> fastMoves;
  final List<String> chargedMoves;
  final DefaultIVs defaultIVs;

  // OPTIONAL
  final int? thirdMoveCost;
  final bool? released;
  final List<String>? tags;
  final List<String>? eliteMoves;

  //DEBUG
  display() {
    print(dex);
    print(speciesName);
    print(speciesId);
    baseStats.display();
    print(types);
    print(fastMoves);
    print(chargedMoves);
    defaultIVs.display();
    print(thirdMoveCost);
    print(released);
    print(tags);
    print(eliteMoves);
  }
}

/*
Every Pokemon contains three stats :
attack
defense
hp

BaseStats encapsulates these stats
*/
class BaseStats {
  BaseStats({required this.atk, required this.def, required this.hp});

  factory BaseStats.fromJson(Map<String, dynamic> data) {
    final atk = data['atk'] as int;
    final def = data['def'] as int;
    final hp = data['hp'] as int;

    return BaseStats(atk: atk, def: def, hp: hp);
  }

  final int atk;
  final int def;
  final int hp;

  display() {
    print(atk);
    print(def);
    print(hp);
  }
}

/*
Every Pokemon contains it's best IV set for each respective league in GBL
- cp500 -- Little League
- cp1500 -- Great League
- cp2500 -- Ultra League

DefaultIVs encapsulates these IV values
*/
class DefaultIVs {
  DefaultIVs({required this.cp500, required this.cp1500, required this.cp2500});

  // JSON -> OBJ conversion
  factory DefaultIVs.fromJson(Map<String, dynamic> data) {
    final List<num> cp500 = List<num>.from(data['cp500']);
    final List<num> cp1500 = List<num>.from(data['cp1500']);
    final List<num> cp2500 = List<num>.from(data['cp2500']);

    return DefaultIVs(cp500: cp500, cp1500: cp1500, cp2500: cp2500);
  }

  final List<num> cp500;
  final List<num> cp1500;
  final List<num> cp2500;

  //DEBUG
  display() {
    print(cp500);
    print(cp1500);
    print(cp2500);
  }
}
