import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:pogo_teams/pogo_data.dart';
import 'package:pogo_teams/pokemon_search.dart';

// A column of 3 Team Nodes are displayed
// These nodes represent the Pokemon that are in a particular team
class TeamBuilder extends StatefulWidget {
  const TeamBuilder({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TeamBuilderState createState() => _TeamBuilderState();
}

class _TeamBuilderState extends State<TeamBuilder> {
  // The index cooresponding to the selected tab
  int _selectedTabIndex = 0;

  // The currently displayed app body
  // By initial default the 'Team Builder' body will display
  Widget appBody = Center(
    child: Column(
      children: <Widget>[
        TeamNode(),
        TeamNode(),
        TeamNode(),
      ],
    ),
  );

  void _onNavTap(int index) {
    setState(() {
      _selectedTabIndex = index;
      switch (index) {
        case 0:
          appBody = Center(
            child: Column(
              children: <Widget>[
                TeamNode(),
                TeamNode(),
                TeamNode(),
              ],
            ),
          );
          break;

        case 1:
          appBody = const Text('Analysis');
          break;

        case 2:
          appBody = const Text('Info');
          break;

        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: appBody,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Team Builder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Team Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Team Info',
          ),
        ],
        onTap: _onNavTap,
        currentIndex: _selectedTabIndex,
        selectedItemColor: Colors.cyan,
      ),
    );
  }
}

// A TeamNode is either an EmptyNode or PokemonNode
// An EmptyNode can be tapped by the user to add a Pokemon to it
// After a Pokemon is added it is a PokemonNode
class TeamNode extends StatefulWidget {
  const TeamNode({Key? key}) : super(key: key);

  @override
  _TeamNodeState createState() => _TeamNodeState();
}

class _TeamNodeState extends State<TeamNode> {
  // The Pokemon this node manages
  Pokemon? pokemon;

  // Open a new app page that allows the user to search for a given Pokemon
  // If a Pokemon is selected in that page, the Pokemon reference will be kept
  // The node will then populate all data related to that Pokemon
  _searchMode() async {
    final caughtPokemon = await Navigator.push(context,
        MaterialPageRoute<Pokemon>(builder: (BuildContext context) {
      return const PokemonSearch(title: 'POGO Search');
    }));

    // If a pokemon was returned from the search page, update the node
    if (caughtPokemon != null) {
      setState(() {
        pokemon = caughtPokemon;
      });
    }
  }

  // Revert a PokemonNode back to an EmptyNode
  _clearNode() {
    setState(() {
      pokemon = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pokemon == null) {
      return EmptyNode(onPressed: _searchMode);
    }

    return PokemonNode(
      pokemon: pokemon,
      searchMode: _searchMode,
      clear: _clearNode,
    );
  }
}

// An icon button indicating that the user can add a Pokemon to the current node
// Once a Pokemon is added, the node will become a PokemonNode
class EmptyNode extends StatelessWidget {
  const EmptyNode({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.add,
        ),
        iconSize: 70.0,
        tooltip: 'add a pokemon to your team',
        onPressed: onPressed,
      ),
    );
  }
}

class PokemonNode extends StatefulWidget {
  const PokemonNode({
    Key? key,
    required this.pokemon,
    required this.searchMode,
    required this.clear,
  }) : super(key: key);

  final VoidCallback searchMode;
  final VoidCallback clear;
  final Pokemon? pokemon;

  @override
  _PokemonNodeState createState() => _PokemonNodeState();
}

class _PokemonNodeState extends State<PokemonNode> {
  String? fastMove;
  String? chargedMoveL;
  String? chargedMoveR;

  List<String>? fastMoves;
  List<String>? chargedMovesL;
  List<String>? chargedMovesR;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fastMoves = widget.pokemon!.fastMoves;
    chargedMovesL = widget.pokemon!.chargedMoves;
    chargedMovesR = chargedMovesL;

    fastMove = widget.pokemon!.getMetaFastMove();
    chargedMoveL = chargedMovesL![0];
    chargedMoveR = chargedMovesR![0];

    if (widget.pokemon == null) {
      return EmptyNode(onPressed: widget.searchMode);
    }
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(10.0),
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        color: widget.pokemon!.typeColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: const EdgeInsets.all(1.0),
            padding: const EdgeInsets.all(7.0),
            alignment: Alignment.topLeft,
            child: Text(
              widget.pokemon!.speciesName,
              style: TextStyle(
                fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(1.0),
            padding: const EdgeInsets.all(7.0),
            alignment: Alignment.topRight,
            child: Text(
              widget.pokemon!.getTypeString(),
              style: TextStyle(
                fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ]),
        const Divider(
          color: Colors.white,
          thickness: 1.5,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          DropdownButton<String>(
            items: fastMoves!.map<DropdownMenuItem<String>>((String move) {
              return DropdownMenuItem<String>(
                value: move,
                child: Text(move),
              );
            }).toList(),
            value: fastMove,
            style: const TextStyle(fontSize: 11),
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() {
                fastMove = newValue;
              });
            },
          ),
          DropdownButton<String>(
            items: chargedMovesL!.map<DropdownMenuItem<String>>((String move) {
              return DropdownMenuItem<String>(
                value: move,
                child: Text(move),
              );
            }).toList(),
            value: chargedMoveL,
            style: const TextStyle(fontSize: 11),
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() {
                chargedMoveL = newValue as String;
              });
            },
          ),
          DropdownButton<String>(
            items: chargedMovesR!.map<DropdownMenuItem<String>>((String move) {
              return DropdownMenuItem<String>(
                value: move,
                child: Text(move),
              );
            }).toList(),
            value: chargedMoveR,
            style: const TextStyle(fontSize: 11),
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() {
                chargedMoveR = newValue as String;
              });
            },
          ),
        ]),
        /*
        const Divider(
          color: Colors.white,
          thickness: 1.5,
        ),
        */
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
            //alignment: Alignment.centerRight,
            onPressed: widget.clear,
            icon: const Icon(Icons.clear),
            tooltip: 'remove this pokemon from your team',
            iconSize: 30.0,
          ),
          IconButton(
            //alignment: Alignment.centerRight,
            onPressed: widget.searchMode,
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            tooltip: 'search for a different pokemon',
            iconSize: 30.0,
          ),
        ]),
      ]),
    );
  }
}
