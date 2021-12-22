// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../configs/size_config.dart';
import '../../data/pokemon/pokemon.dart';
import '../../widgets/buttons/exit_button.dart';
import '../../widgets/buttons/pokemon_action_button.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../data/pokemon/pokemon_team.dart';

/*
-------------------------------------------------------------------- @PogoTeams
The user will be able to swap any of the current Pokemon in their team with
the swap Pokemon. Movesets may also be edited here.
-------------------------------------------------------------------------------
*/

class TeamSwap extends StatefulWidget {
  const TeamSwap({
    Key? key,
    required this.team,
    required this.swap,
  }) : super(key: key);

  final PokemonTeam team;
  final Pokemon swap;

  @override
  _TeamSwapState createState() => _TeamSwapState();
}

class _TeamSwapState extends State<TeamSwap> {
  late List<Pokemon> _pokemonTeam;
  late Pokemon _swap;
  bool _changed = false;

  Widget _buildFooter(BuildContext context, int index) {
    void _onSwap(Pokemon swapPokemon) {
      setState(() {
        _changed = true;
        _pokemonTeam[index] = _swap;
        _swap = swapPokemon;
      });
    }

    return PokemonActionButton(
      pokemon: _pokemonTeam[index],
      label: 'Swap Out',
      icon: Icon(
        Icons.swap_horiz_rounded,
        size: SizeConfig.blockSizeHorizontal * 5.0,
        color: Colors.white,
      ),
      onPressed: _onSwap,
    );
  }

  @override
  void initState() {
    super.initState();
    _pokemonTeam = widget.team.getPokemonTeam();
    _swap = widget.swap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical * 1.0,
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            // The Pokemon to swap out
            PokemonNode.small(pokemon: _swap),

            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),

            Center(
              child: Text(
                'Team Swap',
                style: TextStyle(
                  fontSize: SizeConfig.h2,
                  fontWeight: FontWeight.bold,
                  letterSpacing: SizeConfig.blockSizeHorizontal * .5,
                ),
              ),
            ),

            // Horizontal divider
            Divider(
              height: SizeConfig.blockSizeVertical * 5.0,
              thickness: SizeConfig.blockSizeHorizontal * 1.0,
              indent: SizeConfig.blockSizeHorizontal * 5.0,
              endIndent: SizeConfig.blockSizeHorizontal * 5.0,
            ),

            // List of the current selected team
            ListView.builder(
              shrinkWrap: true,
              itemCount: _pokemonTeam.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * .5,
                    bottom: SizeConfig.blockSizeVertical * .5,
                  ),
                  child: PokemonNode.large(
                    pokemon: _pokemonTeam[index],
                    footer: _buildFooter(context, index),
                  ),
                );
              },
              physics: const NeverScrollableScrollPhysics(),
            ),

            SizedBox(
              height: SizeConfig.blockSizeVertical * 5.0,
            ),
          ],
        ),
      ),

      // Exit to Team Builder button
      floatingActionButton: SizedBox(
        width: SizeConfig.screenWidth * .87,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel exit button
            ExitButton(
              key: UniqueKey(),
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.red[400]!,
            ),

            // Confirm exit button
            ExitButton(
              key: UniqueKey(),
              onPressed: () {
                if (_changed) {
                  Navigator.pop(
                    context,
                    _pokemonTeam,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.check),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
