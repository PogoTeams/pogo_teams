// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../data/pokemon/pokemon.dart';
import '../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
These icons will appear in a row in a Pokemon's node. Here are the current
possible icons :
XL - XL candy Pokemon
Flame - Shadow Pokemon
Start - Meta relevant Pokemon
-------------------------------------------------------------------------------
*/

class TraitsIcons extends StatelessWidget {
  const TraitsIcons({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          pokemon.isXs ? const XlIcon() : Container(),
          pokemon.isShadow ? const ShadowIcon() : Container(),
          MetaIcon(rating: pokemon.rating),
        ],
      ),
    );
  }
}

class XlIcon extends StatelessWidget {
  const XlIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(blockSize * 2.5),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: blockSize * 2.0,
          right: blockSize * 2.0,
        ),
        child: SizedBox(
          height: SizeConfig.blockSizeVertical * 3.0,
          child: Center(
            child: Text(
              'X L',
              style: TextStyle(
                fontSize: SizeConfig.h3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShadowIcon extends StatelessWidget {
  const ShadowIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;
    return Padding(
      padding: EdgeInsets.only(
        left: blockSize * 2.0,
        right: blockSize * 2.0,
      ),
      child: Icon(
        Icons.local_fire_department_rounded,
        color: Colors.purple[900]!,
      ),
    );
  }
}

class MetaIcon extends StatelessWidget {
  const MetaIcon({Key? key, required this.rating}) : super(key: key);

  final num rating;

  Color _getRatingColor() {
    if (rating > 650) {
      return Colors.yellow[600]!;
    }

    return Colors.blue[700]!;
  }

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return rating > 600
        ? Padding(
            padding: EdgeInsets.only(
              left: blockSize * 2.0,
              right: blockSize * 2.0,
            ),
            child: Icon(
              Icons.star,
              color: _getRatingColor(),
            ),
          )
        : Container();
  }
}
