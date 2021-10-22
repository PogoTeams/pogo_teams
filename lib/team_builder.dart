import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'pogo_data.dart';
import 'pokemon_search.dart';
import 'gohub_info.dart';

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

  // The column of nodes for the current team
  final nodes = Column(
    children: const [TeamNode(), TeamNode(), TeamNode()],
  );

  // The currently displayed app body
  // By initial default the 'Team Builder' body will display
  late Widget appBody = Center(
    child: nodes,
  );

  // Branching to the different pages in the application
  // 0) Team Builder
  // 1) Team Analysis
  // 2) Team Info
  void _onNavTap(int index) {
    setState(() {
      _selectedTabIndex = index;
      switch (index) {
        case 0:
          appBody = Center(
            child: nodes,
          );
          break;

        case 1:
          appBody = const Text('Analysis');
          break;

        case 2:
          appBody = const GoHubInfo();
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
            label: 'GoHub Info',
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
    final caughtPokemon = await Navigator.push(
      context,
      MaterialPageRoute<Pokemon>(builder: (BuildContext context) {
        return const PokemonSearch(title: 'POGO Search');
      }),
    );

    // If a pokemon was returned from the search page, update the node
    // Should only be null when the user exits the search page using the app bar
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
    return (pokemon == null
        ? EmptyNode(
            onPressed: _searchMode,
          )
        : PokemonNode(
            pokemon: pokemon as Pokemon,
            searchMode: _searchMode,
            clear: _clearNode,
          ));
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
      margin: const EdgeInsets.only(top: 17.0, left: 14.0, right: 14.0),
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

// A node that is occupied by a Pokemon
// All necessary Pokemon GO information will be accessible in this node
class PokemonNode extends StatefulWidget {
  const PokemonNode({
    Key? key,
    required this.pokemon,
    required this.searchMode,
    required this.clear,
  }) : super(key: key);

  // The Pokemon this node currently manages
  final Pokemon pokemon;

  // Search for a new Pokemon
  final VoidCallback searchMode;

  // Remove the Pokemon and restore to an EmptyNode
  final VoidCallback clear;

  @override
  _PokemonNodeState createState() => _PokemonNodeState();
}

class _PokemonNodeState extends State<PokemonNode> {
  // Display the Pokemon's name and typing at the top of the node
  Row _buildNodeHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        margin: const EdgeInsets.all(1.0),
        padding: const EdgeInsets.all(7.0),
        alignment: Alignment.topLeft,
        child: Text(
          widget.pokemon.speciesName,
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
          widget.pokemon.getTypeString(),
          style: TextStyle(
            fontFamily: DefaultTextStyle.of(context).style.fontFamily,
            fontSize: 16.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    ]);
  }

  // Build a row of icon buttons at the bottom of a Pokemon's Node
  Row _buildNodeFooter() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 17.0, left: 14.0, right: 14.0),
      padding:
          const EdgeInsets.only(top: 7.0, bottom: 2.0, left: 10.0, right: 10.0),
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        color: widget.pokemon.typeColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildNodeHeader(),
        const Divider(
          color: Colors.white,
          thickness: 1.5,
        ),
        MoveDropdowns(
          fastMoves: widget.pokemon.fastMoves,
          chargedMoves: widget.pokemon.chargedMoves,
          fastMoveNames: widget.pokemon.getFastMoveNames(),
          chargedMoveNames: widget.pokemon.getChargedMoveNames(),
          metaFastMove: widget.pokemon.getMetaFastMove(),
          metaChargedMoves: widget.pokemon.getMetaChargedMoves(),
        ),
        _buildNodeFooter(),
      ]),
    );
  }
}

// This class manages the 3 dropdown menu buttons cooresponding to a Pokemon's :
// Fast Move
// Charge Move 1
// Charge Move 2
class MoveDropdowns extends StatefulWidget {
  const MoveDropdowns({
    Key? key,
    required this.fastMoves,
    required this.chargedMoves,
    required this.fastMoveNames,
    required this.chargedMoveNames,
    required this.metaFastMove,
    required this.metaChargedMoves,
  }) : super(key: key);

  final List<Move> fastMoves;
  final List<Move> chargedMoves;

  // Lists of the moves a Pokemon can learn
  final List<String> fastMoveNames;
  final List<String> chargedMoveNames;

  final Move metaFastMove;
  final List<Move> metaChargedMoves;

  @override
  _MoveDropdownsState createState() => _MoveDropdownsState();
}

class _MoveDropdownsState extends State<MoveDropdowns> {
  // The current selected moves
  late Move selectedFastMove;
  // 0: left charge move
  // 1: right charge move
  late List<Move> selectedChargedMoves;

  // List of dropdown items for fast moves
  late List<DropdownMenuItem<String>> fastMoveOptions;

  // List of charged move names
  // These lists will filter out the selected move from the other list
  // This prevents the user from selecting the same charge move twice
  late List<String> chargedMoveNamesL;
  late List<String> chargedMoveNamesR;

  // List of dropdown items for charged moves
  late List<DropdownMenuItem<String>> chargedMoveOptionsL;
  late List<DropdownMenuItem<String>> chargedMoveOptionsR;

  // Setup the move dropdown items
  void _initializeMoveData() {
    selectedFastMove = widget.metaFastMove;
    selectedChargedMoves = widget.metaChargedMoves;

    fastMoveOptions = _generateDropdownItems(widget.fastMoveNames);

    _updateChargedMoveOptions();
  }

  // Upon initial build, update, or dropdown onChanged callback
  // Filter the left and right charged move lists for the dropdowns
  void _updateChargedMoveOptions() {
    chargedMoveNamesL = widget.chargedMoveNames
        .where((moveName) => moveName != selectedChargedMoves[1].name)
        .toList();

    chargedMoveNamesR = widget.chargedMoveNames
        .where((moveName) => moveName != selectedChargedMoves[0].name)
        .toList();

    chargedMoveOptionsL = _generateDropdownItems(chargedMoveNamesL);
    chargedMoveOptionsR = _generateDropdownItems(chargedMoveNamesR);
  }

  // Generate the list of dropdown items from moveOptionNames
  // Called for each of the 3 move dropdowns
  List<DropdownMenuItem<String>> _generateDropdownItems(
      List<String> moveOptionNames) {
    return moveOptionNames.map<DropdownMenuItem<String>>((String moveName) {
      return DropdownMenuItem<String>(
        value: moveName,
        child: Center(
          child: Text(
            moveName,
            style: const TextStyle(
              fontSize: 8.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  // Called on first build
  @override
  void initState() {
    super.initState();

    _initializeMoveData();
  }

  // Called on any consecutive build
  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initializeMoveData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      MoveNode(
          label: 'F A S T',
          move: selectedFastMove,
          options: fastMoveOptions,
          onChanged: (String? newFastMove) {
            setState(() {
              selectedFastMove = widget.fastMoves
                  .firstWhere((move) => move.name == newFastMove!);
            });
          }),
      MoveNode(
          label: 'C H A R G E  1',
          move: selectedChargedMoves[0],
          options: chargedMoveOptionsL,
          onChanged: (String? newChargedMove) {
            setState(() {
              selectedChargedMoves[0] = widget.chargedMoves
                  .firstWhere((move) => move.name == newChargedMove!);

              _updateChargedMoveOptions();
            });
          }),
      MoveNode(
          label: 'C H A R G E  2',
          move: selectedChargedMoves[1],
          options: chargedMoveOptionsR,
          onChanged: (String? newChargedMove) {
            setState(() {
              selectedChargedMoves[1] = widget.chargedMoves
                  .firstWhere((move) => move.name == newChargedMove!);

              _updateChargedMoveOptions();
            });
          }),
    ]);
  }
}

// The label and dropdown button for a given move
// The _MovesDropdownsState will dynamically generate 3 of the nodes
class MoveNode extends StatelessWidget {
  const MoveNode({
    Key? key,
    required this.label,
    required this.move,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final Move move;
  final List<DropdownMenuItem<String>> options;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              value: move.name,
              icon: const Icon(Icons.arrow_drop_down),
              style: DefaultTextStyle.of(context).style,
              items: options,
              onChanged: onChanged,
            ),
          ),
          margin: const EdgeInsets.only(top: 10.0),
          width: 100.0,
          height: 30.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(50.0),
            color: move.typeColor,
          ),
        ),
      ],
    );
  }
}
