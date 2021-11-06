import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pogo_teams/widgets/node_decoration.dart';
import '../tools/pair.dart';
import '../data/pokemon.dart';
import '../data/cup.dart';
import '../data/type_effectiveness.dart';
import '../data/typing.dart';
import '../data/move.dart';
import '../widgets/exit_button.dart';
import '../configs/size_config.dart';
import '../data/globals.dart' as globals;

class TeamAnalysis extends StatelessWidget {
  TeamAnalysis({
    Key? key,
    required this.pokemonTeam,
    required this.selectedCup,
  }) : super(key: key);

  List<Pokemon> pokemonTeam;
  final Cup selectedCup;

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Selected cup
            Container(
              alignment: Alignment.center,
              width: SizeConfig.screenWidth * .95,
              height: SizeConfig.blockSizeVertical * 4.5,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: SizeConfig.blockSizeHorizontal * .4,
                ),
                borderRadius: BorderRadius.circular(100.0),
                color: selectedCup.cupColor,
              ),
              child: Text(selectedCup.title),
            ),

            // Spacer
            SizedBox(
              height: blockSize * 3.5,
            ),

            // List of the selected Pokemon team and their selected moves
            Flexible(
              child: SizedBox(
                width: SizeConfig.screenWidth * .95,
                child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: pokemonTeam.map((pokemon) {
                      return Padding(
                          padding: EdgeInsets.only(bottom: blockSize * 2.0),
                          child: CompactPokemonNode(pokemon: pokemon));
                    }).toList()),
              ),
            ),

            // Spacer
            SizedBox(
              height: blockSize * 3.5,
            ),

            Text('THREATS',
                style: TextStyle(
                  letterSpacing: SizeConfig.blockSizeHorizontal * 5.0,
                  fontSize: SizeConfig.h1,
                  fontWeight: FontWeight.bold,
                )),

            // Spacer
            SizedBox(
              height: blockSize * 3.5,
            ),

            EffectivenessAnalysis(pokemonTeam: pokemonTeam),
          ],
        ),
      ),
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class CompactPokemonNode extends StatelessWidget {
  const CompactPokemonNode({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  // The Pokemon name and type icon(s)
  Row _buildNodeHeader(Pokemon pokemon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pokemon name
        Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.0),
          alignment: Alignment.topLeft,
          child: Text(
            pokemon.speciesName,
            style: TextStyle(
              fontSize: SizeConfig.h1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Typing icon(s)
        Container(
          alignment: Alignment.topRight,
          height: SizeConfig.blockSizeHorizontal * 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: pokemon.getTypeIcons(iconColor: 'white'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return Container(
      padding: EdgeInsets.only(
        top: blockSize * 1.3,
        right: blockSize * 2.5,
        bottom: blockSize * 5.0,
        left: blockSize * 2.5,
      ),
      decoration: buildDecoration(pokemon),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNodeHeader(pokemon),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CompactMoveNode(move: pokemon.selectedFastMove),
              CompactMoveNode(move: pokemon.selectedChargedMoves[0]),
              CompactMoveNode(move: pokemon.selectedChargedMoves[1]),
            ],
          ),
        ],
      ),
    );
  }
}

class CompactMoveNode extends StatelessWidget {
  const CompactMoveNode({
    Key? key,
    required this.move,
  }) : super(key: key);

  final Move move;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        move.name,
        style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 3.0,
          fontFamily: DefaultTextStyle.of(context).style.fontFamily,
        ),
      ),
      margin: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * .7,
      ),
      width: SizeConfig.screenWidth * .28,
      height: SizeConfig.blockSizeVertical * 3.5,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(100.0),
        color: move.typeColor,
      ),
    );
  }
}

class EffectivenessAnalysis extends StatelessWidget {
  const EffectivenessAnalysis({
    Key? key,
    required this.pokemonTeam,
  }) : super(key: key);

  final List<Pokemon> pokemonTeam;

  // Determine the type effectiveneses of this team
  Widget _threats() {
    List<Type> typeList = TypeEffectiveness.typeList;

    // Bind a list of all types to a value
    // This value will represent their offensive effectiveness on this team
    List<Pair<double, Type>> teamEffectiveness =
        List.generate(globals.typeCount, (i) {
      return Pair(a: 0.0, b: typeList[i]);
    });

    final int teamLength = pokemonTeam.length;

    // Accumulate team defensive type effectiveness for all types
    for (int i = 0; i < teamLength; ++i) {
      final List<double> effectiveness =
          pokemonTeam[i].getDefenseEffectiveness();

      for (int k = 0; k < globals.typeCount; ++k) {
        teamEffectiveness[k].a += effectiveness[k];
      }
    }

    teamEffectiveness.removeWhere((pair) => pair.a <= teamLength);

    // Sort by teamEffectiveness and typeList by highest threat
    teamEffectiveness.sort((prev, curr) => ((curr.a - prev.a) * 1000).round());

    // DEBUG
    //print('DEFENSE EFFECTIVENESS');
    //teamEffectiveness.forEach((i) => print(i.b.typeKey + " " + i.a.toString()));

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 3.0,
          right: SizeConfig.blockSizeHorizontal * 3.0,
        ),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisSpacing: SizeConfig.blockSizeHorizontal * 5.0,
          mainAxisSpacing: SizeConfig.blockSizeVertical * 4.0,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: teamEffectiveness.length,
          children: teamEffectiveness.map((pair) {
            return pair.b.getIcon();
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _threats();
  }
}
