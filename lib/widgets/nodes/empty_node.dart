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
    required this.role,
    required this.onPressed,
  }) : super(key: key);

  final String role;
  final VoidCallback onPressed;

  // Team roles are color coded, this will determine the color of this node
  Color _getRoleColor() {
    switch (role) {
      case 'lead':
        return Colors.green[300]!;

      case 'mid':
        return Colors.yellow[300]!;

      case 'closer':
        return Colors.orange[300]!;

      default:
        break;
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;
    final roleColor = _getRoleColor();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: roleColor,
          width: blockSize * 0.8,
        ),
        borderRadius: BorderRadius.circular(blockSize * 2.5),
      ),
      child: TextButton.icon(
        label: Text(
          role,
          style: TextStyle(
            fontSize: SizeConfig.h1,
            color: Colors.white,
          ),
        ),
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
