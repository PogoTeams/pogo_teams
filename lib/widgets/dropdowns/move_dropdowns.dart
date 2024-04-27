// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../model/move.dart';
import '../../model/pokemon.dart';
import '../../app/ui/sizing.dart';
import '../../app/ui/pogo_colors.dart';

/*
-------------------------------------------------------------------- @PogoTeams
This class manages the 3 dropdown menu buttons cooresponding to a Pokemon's :
- Fast Move
- Charge Move 1
- Charge Move 2

For each move is it's own dropdown, which renders the options given the
Pokemon's possible movesets.
-------------------------------------------------------------------------------
*/

class MoveDropdowns extends StatefulWidget {
  MoveDropdowns({
    super.key,
    required this.pokemon,
    this.onChanged,
  });

  final Pokemon pokemon;
  final VoidCallback? onChanged;

  // Lists of the moves a Pokemon can learn
  late final List<String> fastMoveIds = pokemon.fastMoveIds();
  late final List<String> chargedMoveIds = pokemon.chargeMoveIds();

  @override
  _MoveDropdownsState createState() => _MoveDropdownsState();
}

class _MoveDropdownsState extends State<MoveDropdowns> {
  // List of dropdown items for fast moves
  late List<DropdownMenuItem<Move>> fastMoveOptions;

  // List of charged move names
  // These lists will filter out the selected move from the other list
  // This prevents the user from selecting the same charge move twice
  late List<Move> chargedMovesL;
  late List<Move> chargedMovesR;

  // List of dropdown items for charged moves
  late List<DropdownMenuItem<Move>> chargedMoveOptionsL;
  late List<DropdownMenuItem<Move>> chargedMoveOptionsR;

  // Setup the move dropdown items
  void _initializeMoveData() {
    fastMoveOptions = _generateDropdownItems(
        widget.pokemon.getBase().getFastMoves().toList());

    _updateChargedMoveOptions();
  }

  // Upon initial build, update, or dropdown onChanged callback
  // Filter the left and right charged move lists for the dropdowns
  void _updateChargedMoveOptions() {
    chargedMovesL = widget.pokemon
        .getBase()
        .getChargeMoves()
        .where(
            (move) => !move.isSameMove(widget.pokemon.getSelectedChargeMoveR()))
        .toList();

    chargedMovesR = widget.pokemon
        .getBase()
        .getChargeMoves()
        .where(
            (move) => !move.isSameMove(widget.pokemon.getSelectedChargeMoveL()))
        .toList();

    chargedMoveOptionsL = _generateDropdownItems(chargedMovesL);
    chargedMoveOptionsR = _generateDropdownItems(chargedMovesR);
  }

  // Generate the list of dropdown items from moveOptionNames
  // Called for each of the 3 move dropdowns
  List<DropdownMenuItem<Move>> _generateDropdownItems(List<Move> moves) {
    return moves.map<DropdownMenuItem<Move>>(
      (Move move) {
        return DropdownMenuItem<Move>(
          value: move,
          child: Padding(
            padding: EdgeInsets.only(
              left: Sizing.blockSizeHorizontal * 2.0,
              right: Sizing.blockSizeHorizontal * 2.0,
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  widget.pokemon.getBase().getFormattedMoveName(move),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initializeMoveData();
  }

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
          move: widget.pokemon.getSelectedFastMove(),
          options: fastMoveOptions,
          onChanged: (Move? newFastMove) {
            setState(() {
              if (newFastMove != null) {
                widget.pokemon.selectedFastMoveId = newFastMove.moveId;
              }
              if (widget.onChanged != null) widget.onChanged!();
            });
          },
        ),
        MoveDropdown(
          label: 'C H A R G E  1',
          move: widget.pokemon.getSelectedChargeMoveL(),
          options: chargedMoveOptionsL,
          onChanged: (Move? newChargedMove) {
            setState(() {
              if (newChargedMove != null) {
                widget.pokemon.selectedChargeMoveIds.first =
                    newChargedMove.moveId;
              }
              _updateChargedMoveOptions();
              if (widget.onChanged != null) widget.onChanged!();
            });
          },
        ),
        MoveDropdown(
          label: 'C H A R G E  2',
          move: widget.pokemon.getSelectedChargeMoveR(),
          options: chargedMoveOptionsR,
          onChanged: (Move? newChargedMove) {
            setState(() {
              if (newChargedMove != null) {
                widget.pokemon.selectedChargeMoveIds.last =
                    newChargedMove.moveId;
              }
              _updateChargedMoveOptions();
              if (widget.onChanged != null) widget.onChanged!();
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
    super.key,
    required this.label,
    required this.move,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final Move move;
  final List<DropdownMenuItem<Move>> options;
  final Function(Move?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Move label
        FittedBox(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),

        // Dropdown button
        Container(
          padding: EdgeInsets.only(
            right: Sizing.blockSizeVertical * .7,
          ),
          margin: EdgeInsets.only(
            top: Sizing.blockSizeVertical * .7,
          ),
          width: Sizing.scrnwidth * .28,
          height: Sizing.blockSizeVertical * 3.5,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1.1,
            ),
            borderRadius: BorderRadius.circular(100),
            color: PogoColors.getPokemonTypeColor(move.type.typeId),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              value: move,
              icon: const Icon(Icons.arrow_drop_down_circle),
              iconSize: Sizing.blockSizeHorizontal * 4.0,
              style: Theme.of(context).textTheme.bodySmall,
              items: options,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
