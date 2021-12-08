// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../configs/size_config.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/cup.dart';
import '../pvp_stats.dart';
import '../dropdowns/move_dropdowns.dart';
import '../traits_icons.dart';
import '../colored_container.dart';

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/

class PokemonNode extends StatelessWidget {
  PokemonNode.square({
    Key? key,
    required this.pokemon,
    required this.nodeIndex,
    required this.onEmptyPressed,
  }) : super(key: key) {
    cup = null;

    width = SizeConfig.blockSizeHorizontal * 23.0;
    height = SizeConfig.blockSizeHorizontal * 23.0;

    if (pokemon == null) return;

    body = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pokemon name
        Text(
          pokemon!.speciesName,
          textAlign: TextAlign.center,
        ),

        // A line divider
        Divider(
          color: Colors.white,
          thickness: SizeConfig.blockSizeHorizontal * 0.2,
        ),

        MoveDots(moveColors: pokemon!.getMoveColors()),
      ],
    );
  }

  PokemonNode.small({
    Key? key,
    required this.pokemon,
  }) : super(key: key) {
    nodeIndex = 0;
    onEmptyPressed = () {};

    width = SizeConfig.screenWidth * .95;
    height = SizeConfig.blockSizeVertical * 14.0;

    body = Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * .5,
        left: SizeConfig.blockSizeHorizontal * 2.0,
        right: SizeConfig.blockSizeHorizontal * 2.0,
        bottom: SizeConfig.blockSizeVertical * 1.5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNodeHeader(pokemon!, null),

          // A line divider
          Divider(
            color: Colors.white,
            thickness: SizeConfig.blockSizeHorizontal * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          MoveDropdowns(pokemon: pokemon!),
        ],
      ),
    );
  }

  PokemonNode.large({
    Key? key,
    required this.pokemon,
    required this.nodeIndex,
    required this.onEmptyPressed,
    this.cup,
    this.footer,
  }) : super(key: key) {
    width = SizeConfig.screenWidth * .95;
    height = SizeConfig.screenHeight * .2;

    if (pokemon == null) return;

    body = Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * 1.0,
        left: SizeConfig.blockSizeHorizontal * 2.0,
        right: SizeConfig.blockSizeHorizontal * 2.0,
        bottom: SizeConfig.blockSizeVertical * .2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pokemon name, perfect IVs, and typing icons
          _buildNodeHeader(pokemon!, cup),

          // A line divider
          Divider(
            color: Colors.white,
            thickness: SizeConfig.blockSizeHorizontal * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          MoveDropdowns(pokemon: pokemon!),

          footer ?? Container(),
        ],
      ),
    );
  }

  final Pokemon? pokemon;
  late final int nodeIndex;
  late final VoidCallback onEmptyPressed;

  late final double width;
  late final double height;

  late final Cup? cup;

  late final Widget body;
  late final Widget? footer;

  // Display the Pokemon's name perfect PVP ivs and typing icon(s)
  Row _buildNodeHeader(Pokemon pokemon, Cup? cup) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pokemon name
        Text(
          pokemon.speciesName,
          style: TextStyle(
            fontSize: SizeConfig.h1,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Traits Icons
        TraitsIcons(pokemon: pokemon),

        // The perfect IVs for this Pokemon given the selected cup
        cup == null
            ? Container()
            : PvpStats(
                perfectStats: pokemon.getPerfectPvpStats(cup.cp),
              ),

        // Typing icon(s)
        Container(
          alignment: Alignment.topRight,
          height: SizeConfig.blockSizeHorizontal * 8.0,
          child: Row(
            children: pokemon.getTypeIcons(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: pokemon == null
          ? SquareEmptyNode(
              onPressed: onEmptyPressed,
            )
          : ColoredContainer(
              padding: EdgeInsets.only(
                top: SizeConfig.blockSizeHorizontal * .5,
                left: SizeConfig.blockSizeHorizontal * 2.2,
                right: SizeConfig.blockSizeHorizontal * 2.2,
                bottom: SizeConfig.blockSizeHorizontal * .5,
              ),
              pokemon: pokemon!,
              child: body,
            ),
    );
  }
}

class SquareEmptyNode extends StatelessWidget {
  const SquareEmptyNode({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: SizeConfig.blockSizeHorizontal * 0.5,
        ),
        borderRadius:
            BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2.0),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Icon(
          Icons.add,
          size: SizeConfig.blockSizeHorizontal * 15.0,
        ),
      ),
    );
  }
}

class MoveDots extends StatelessWidget {
  const MoveDots({
    Key? key,
    required this.moveColors,
  }) : super(key: key);

  final List<Color> moveColors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: moveColors
          .map(
            (color) => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: SizeConfig.blockSizeHorizontal * 0.3,
                ),
                color: color,
                borderRadius: BorderRadius.circular(100),
              ),
              height: SizeConfig.blockSizeHorizontal * 4.0,
              width: SizeConfig.blockSizeHorizontal * 4.0,
            ),
          )
          .toList(),
    );
  }
}
