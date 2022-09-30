// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';

/*
-------------------------------------------------------------------- @PogoTeams
An empty node indicates an empty space in a Pokemon Team. Depending on the
context, this empty node can be tapped to apply various callbacks. The empty
node can also be completely emptyTransparent. All PokemonNodes use an empty node
when their Pokemon ref is null.
-------------------------------------------------------------------------------
*/

class EmptyNode extends StatelessWidget {
  const EmptyNode({
    Key? key,
    required this.onPressed,
    required this.emptyTransparent,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final bool emptyTransparent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: emptyTransparent ? Colors.transparent : Colors.white54,
          width: Sizing.blockSizeHorizontal * 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: MaterialButton(
        onPressed: onPressed,

        // Evaluate button transparency
        child: emptyTransparent
            ? Container()
            : Icon(
                Icons.add,
                color: Colors.white54,
                size: Sizing.blockSizeHorizontal * 15.0,
              ),
      ),
    );
  }
}
