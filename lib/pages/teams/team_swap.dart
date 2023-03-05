// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';
import '../../modules/data/pogo_data.dart';
import '../../pogo_objects/pokemon.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/buttons/pokemon_action_button.dart';
import '../../widgets/nodes/pokemon_node.dart';
import '../../pogo_objects/pokemon_team.dart';

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
  final UserPokemon swap;

  @override
  _TeamSwapState createState() => _TeamSwapState();
}

class _TeamSwapState extends State<TeamSwap> {
  late List<UserPokemon> _pokemonTeam;
  late UserPokemon _swap;

  Widget _buildFooter(BuildContext context, int index) {
    void _onSwap(Pokemon swapPokemon) {
      setState(() {
        _pokemonTeam[index] = _swap;
        _swap = swapPokemon as UserPokemon;
      });
    }

    return PokemonActionButton(
      pokemon: _pokemonTeam[index],
      label: 'Swap Out',
      icon: Icon(
        Icons.swap_horiz_rounded,
        size: Sizing.blockSizeHorizontal * 5.0,
        color: Colors.white,
      ),
      onPressed: _onSwap,
    );
  }

  Widget _buildFloatingActionButton() {
    return GradientButton(
      onPressed: () {
        _saveTeam();
        Navigator.pop(context);
      },
      child: Icon(
        Icons.clear,
        size: Sizing.icon2,
      ),
      width: Sizing.screenWidth * .85,
      height: Sizing.blockSizeVertical * 8.5,
    );
  }

  void _saveTeam() {
    PogoData.updatePokemonTeamSync(
      widget.team,
      newPokemonTeam: _pokemonTeam,
    );
  }

  @override
  void initState() {
    super.initState();
    _pokemonTeam = widget.team.getOrderedPokemonList();
    _swap = widget.swap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: Sizing.blockSizeVertical * 1.0,
          left: Sizing.blockSizeHorizontal * 2.0,
          right: Sizing.blockSizeHorizontal * 2.0,
        ),
        child: ListView(
          children: [
            // The Pokemon to swap out
            PokemonNode.small(pokemon: _swap),

            SizedBox(
              height: Sizing.blockSizeVertical * 2.0,
            ),

            Center(
              child: Text(
                'Team Swap',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),

            // Horizontal divider
            Divider(
              height: Sizing.blockSizeVertical * 5.0,
              thickness: Sizing.blockSizeHorizontal * 1.0,
              indent: Sizing.blockSizeHorizontal * 5.0,
              endIndent: Sizing.blockSizeHorizontal * 5.0,
            ),

            // List of the current selected team
            ListView.builder(
              shrinkWrap: true,
              itemCount: _pokemonTeam.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: Sizing.blockSizeVertical * .5,
                    bottom: Sizing.blockSizeVertical * .5,
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
              height: Sizing.blockSizeVertical * 5.0,
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
