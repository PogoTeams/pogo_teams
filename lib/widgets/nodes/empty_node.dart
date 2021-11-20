// Dart Imports
import 'dart:ui';

// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
An icon button indicating that the user can add a Pokemon to the current node
Once a Pokemon is added, the node will become a PokemonNode
-------------------------------------------------------------------------------
*/

class EmptyNode extends StatelessWidget {
  const EmptyNode({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: blockSize * 0.8,
        ),
        borderRadius: BorderRadius.circular(blockSize * 2.5),
      ),
      child: IconButton(
        icon: Icon(
          Icons.add,
          size: blockSize * 8.5,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
