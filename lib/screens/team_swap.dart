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
import '../data/cup.dart';
import '../widgets/buttons/exit_button.dart';
import '../widgets/nodes/pokemon_nodes.dart';
import '../widgets/buttons/compact_pokemon_node_button.dart';
import '../widgets/buttons/filter_button.dart';
import '../data/pokemon/pokemon_team.dart';
import '../data/globals.dart' as globals;

/*
-------------------------------------------------------------------------------
A list of Pokemon are displayed here, which will filter based on text input.
Every Pokemon node displayed can be tapped, from which that Pokemon reference
will be returned via the Navigator.pop.
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
  late List<Pokemon> editableList;

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final Pokemon pokemon = editableList.removeAt(oldIndex);
      editableList.insert(newIndex, pokemon);
    });
  }

  @override
  void initState() {
    super.initState();
    editableList = widget.team.getPokemonTeam();
    editableList.add(widget.swap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 2.0,
            right: SizeConfig.blockSizeHorizontal * 2.0,
          ),
          child: Center(
            child: ReorderableListView.builder(
              itemCount: editableList.length,
              itemBuilder: (context, index) {
                if (index == editableList.length - 1) {
                  return Container(
                    key: UniqueKey(),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.yellow[400]!,
                        width: SizeConfig.blockSizeHorizontal * 1.3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow,
                          spreadRadius: SizeConfig.blockSizeHorizontal * 1.4,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                          SizeConfig.blockSizeHorizontal * 2.5),
                    ),
                    child: CompactPokemonNode(
                      key: UniqueKey(),
                      pokemon: editableList[index],
                    ),
                  );
                }

                return CompactPokemonNode(
                  key: UniqueKey(),
                  pokemon: editableList[index],
                );
              },
              onReorder: _onReorder,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        ),
      ),
      // Exit to Team Builder button
      floatingActionButton: ExitButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
