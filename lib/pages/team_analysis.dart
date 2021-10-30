import 'package:flutter/material.dart';
import 'package:pogo_teams/buttons/exit_button.dart';
import '../data/pogo_data.dart';
import '../configs/size_config.dart';

class TeamAnalysis extends StatelessWidget {
  TeamAnalysis({
    Key? key,
    required this.pokemonTeam,
    required this.selectedLeague,
  }) : super(key: key);

  List<Pokemon> pokemonTeam;
  final League selectedLeague;

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                color: selectedLeague.leagueColor,
              ),
              child: Text(selectedLeague.title),
            ),
            SizedBox(
              height: blockSize * 2.5,
            ),
            Expanded(
              child: ListView(
                  children: pokemonTeam.map<CompactPokemonNode>((pokemon) {
                return CompactPokemonNode(pokemon: pokemon);
              }).toList()),
            ),
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

  Row _buildNodeHeader(Pokemon pokemon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2.0),
          alignment: Alignment.topRight,
          child: Text(
            pokemon.getTypeString(),
            style: TextStyle(
              fontSize: SizeConfig.h2,
              fontStyle: FontStyle.italic,
            ),
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
        top: blockSize * 1.0,
        right: blockSize * 2.5,
        bottom: blockSize * 8.5,
        left: blockSize * 2.5,
      ),
      decoration: BoxDecoration(
        color: pokemon.typeColor,
        //borderRadius: BorderRadius.circular(blockSize * 2.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNodeHeader(pokemon),
        ],
      ),
    );
  }
}
