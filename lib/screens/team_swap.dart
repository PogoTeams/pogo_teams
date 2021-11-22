// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../configs/size_config.dart';
import '../data/pokemon/pokemon.dart';
import '../widgets/buttons/exit_button.dart';
import '../widgets/buttons/pokemon_action_button.dart';
import '../widgets/nodes/pokemon_nodes.dart';
import '../data/pokemon/pokemon_team.dart';

/*
-------------------------------------------------------------------------------
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
  late List<Pokemon> _teamList;
  late Pokemon _swap;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _teamList = widget.team.getPokemonTeam();
    _swap = widget.swap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1.0,
            left: SizeConfig.blockSizeHorizontal * 2.0,
            right: SizeConfig.blockSizeHorizontal * 2.0,
          ),
          child: ListView(
            children: [
              // The Pokemon to swap out
              CompactPokemonNode(pokemon: _swap),

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
                itemCount: _teamList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * .5,
                      bottom: SizeConfig.blockSizeVertical * .5,
                    ),
                    child: FooterPokemonNode(
                      key: UniqueKey(),
                      pokemon: _teamList[index],
                      // Swap Pokemon
                      footerChild: PokemonActionButton(
                        pokemon: _teamList[index],
                        label: 'Swap Out',
                        icon: Icon(
                          Icons.swap_horiz_rounded,
                          size: SizeConfig.blockSizeHorizontal * 5.0,
                          color: Colors.white,
                        ),
                        onPressed: (newSwapPokemon) {
                          setState(() {
                            _changed = true;
                            _teamList[index] = _swap;
                            _swap = newSwapPokemon;
                          });
                        },
                      ),
                    ),
                  );
                },
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        ),
      ),
      // Exit to Team Builder button
      floatingActionButton: ExitButton(
        onPressed: () {
          if (_changed) {
            Navigator.pop(
              context,
              _teamList,
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
