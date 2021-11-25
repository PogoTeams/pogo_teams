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
        ],
      ),
    );
  }
}

class XlIcon extends StatelessWidget {
  const XlIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius:
            BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.5),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 2.0,
          right: SizeConfig.blockSizeHorizontal * 2.0,
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
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 2.0,
        right: SizeConfig.blockSizeHorizontal * 2.0,
      ),
      child: Icon(
        Icons.local_fire_department_rounded,
        color: Colors.purple[900]!,
      ),
    );
  }
}

// Currently unused, but may prove to be useful
class MetaIcon extends StatelessWidget {
  const MetaIcon({Key? key, required this.rating}) : super(key: key);

  final num rating;

  @override
  Widget build(BuildContext context) {
    return rating > 650
        ? Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.blockSizeHorizontal * 2.0,
              right: SizeConfig.blockSizeHorizontal * 2.0,
            ),
            child: Icon(
              Icons.star_rounded,
              color: Colors.yellow[600],
            ),
          )
        : Container();
  }
}
