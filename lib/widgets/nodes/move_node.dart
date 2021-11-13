// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../data/pokemon/move.dart';
import '../../configs/size_config.dart';

class MoveNode extends StatelessWidget {
  const MoveNode({
    Key? key,
    required this.move,
  }) : super(key: key);

  final Move move;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        move.name,
        style: TextStyle(
          fontFamily: DefaultTextStyle.of(context).style.fontFamily,
          fontSize: SizeConfig.h3,
        ),
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
    );
  }
}
