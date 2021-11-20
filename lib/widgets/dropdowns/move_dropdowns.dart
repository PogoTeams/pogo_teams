// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../data/pokemon/move.dart';
import '../../data/pokemon/pokemon.dart';
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
This class manages the 3 dropdown menu buttons cooresponding to a Pokemon's :
Fast Move
Charge Move 1
Charge Move 2

For each move is it's own dropdown, which dynamically renders the option given
the Pokemon.
-------------------------------------------------------------------------------
*/

class MoveDropdowns extends StatefulWidget {
  const MoveDropdowns({
    Key? key,
    required this.pokemon,
    required this.fastMoveNames,
    required this.chargedMoveNames,
    required this.onNodeChanged,
  }) : super(key: key);

  final Pokemon pokemon;

  // Lists of the moves a Pokemon can learn
  final List<String> fastMoveNames;
  final List<String> chargedMoveNames;

  final VoidCallback onNodeChanged;

  @override
  _MoveDropdownsState createState() => _MoveDropdownsState();
}

class _MoveDropdownsState extends State<MoveDropdowns> {
  // List of dropdown items for fast moves
  late List<DropdownMenuItem<Move>> fastMoveOptions;

  // List of charged move names
  // These lists will filter out the selected move from the other list
  // This prevents the user from selecting the same charge move twice
  late List<Move> chargedMoveNamesL;
  late List<Move> chargedMoveNamesR;

  // List of dropdown items for charged moves
  late List<DropdownMenuItem<Move>> chargedMoveOptionsL;
  late List<DropdownMenuItem<Move>> chargedMoveOptionsR;

  // Setup the move dropdown items
  void _initializeMoveData() {
    fastMoveOptions = _generateDropdownItems(widget.pokemon.fastMoves);

    _updateChargedMoveOptions();
  }

  // Upon initial build, update, or dropdown onChanged callback
  // Filter the left and right charged move lists for the dropdowns
  void _updateChargedMoveOptions() {
    chargedMoveNamesL = widget.pokemon.chargedMoves
        .where((move) =>
            move.moveId != widget.pokemon.selectedChargedMoves[1].moveId)
        .toList();

    chargedMoveNamesR = widget.pokemon.chargedMoves
        .where((move) =>
            move.moveId != widget.pokemon.selectedChargedMoves[0].moveId)
        .toList();

    chargedMoveOptionsL = _generateDropdownItems(chargedMoveNamesL);
    chargedMoveOptionsR = _generateDropdownItems(chargedMoveNamesR);
  }

  // Generate the list of dropdown items from moveOptionNames
  // Called for each of the 3 move dropdowns
  List<DropdownMenuItem<Move>> _generateDropdownItems(
      List<Move> moveOptionNames) {
    return moveOptionNames.map<DropdownMenuItem<Move>>((Move move) {
      return DropdownMenuItem<Move>(
        value: move,
        child: Center(
          child: Text(
            move.name,
            style: TextStyle(
              fontFamily: DefaultTextStyle.of(context).style.fontFamily,
              fontSize: SizeConfig.p,
            ),
          ),
        ),
      );
    }).toList();
  }

  // Called on first build
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MoveDropdown(
          label: 'F A S T',
          move: widget.pokemon.selectedFastMove,
          options: fastMoveOptions,
          onChanged: (Move? newFastMove) {
            setState(() {
              widget.pokemon.updateSelectedFastMove(newFastMove);
              widget.onNodeChanged();
            });
          },
        ),
        MoveDropdown(
          label: 'C H A R G E  1',
          move: widget.pokemon.selectedChargedMoves[0],
          options: chargedMoveOptionsL,
          onChanged: (Move? newChargedMove) {
            setState(() {
              widget.pokemon.updateSelectedChargedMove(0, newChargedMove);
              _updateChargedMoveOptions();
              widget.onNodeChanged();
            });
          },
        ),
        MoveDropdown(
          label: 'C H A R G E  2',
          move: widget.pokemon.selectedChargedMoves[1],
          options: chargedMoveOptionsR,
          onChanged: (Move? newChargedMove) {
            setState(() {
              widget.pokemon.updateSelectedChargedMove(1, newChargedMove);
              _updateChargedMoveOptions();
              widget.onNodeChanged();
            });
          },
        ),
      ],
    );
  }
}

// The label and dropdown button for a given move
// The _MovesDropdownsState will dynamically generate 3 of the nodes
class MoveDropdown extends StatelessWidget {
  const MoveDropdown({
    Key? key,
    required this.label,
    required this.move,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final Move move;
  final List<DropdownMenuItem<Move>> options;
  final Function(Move?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Move name
        Text(
          label,
          style: TextStyle(
            fontSize: SizeConfig.p,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),

        // Dropdown button
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              value: move,
              icon: const Icon(Icons.arrow_drop_down_circle),
              iconSize: SizeConfig.blockSizeHorizontal * 4.0,
              style: TextStyle(
                fontSize: SizeConfig.p,
                fontFamily: DefaultTextStyle.of(context).style.fontFamily,
              ),
              items: options,
              onChanged: onChanged,
            ),
          ),
          padding: EdgeInsets.only(
            right: SizeConfig.blockSizeVertical * .7,
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
            color: move.type.typeColor,
          ),
        ),
      ],
    );
  }
}
