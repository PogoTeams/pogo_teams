// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import 'empty_node.dart';
import 'move_node.dart';
import '../../configs/size_config.dart';
import '../../data/pokemon/pokemon.dart';
import '../../data/cup.dart';
import '../pvp_stats.dart';
import '../dropdowns/move_dropdowns.dart';
import '../traits_icons.dart';
import '../colored_container.dart';
import '../formatted_pokemon_name.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Any Pokemon information being displayed in the app is done so through a
PokemonNode. The node can take many different forms depending on the context.
-------------------------------------------------------------------------------
*/

class PokemonNode extends StatelessWidget {
  PokemonNode.square({
    Key? key,
    required this.pokemon,
    this.onPressed,
    this.onEmptyPressed,
    this.emptyTransparent = false,
    this.padding,
  }) : super(key: key) {
    cup = null;
    dropdowns = false;
    rating = false;

    width = SizeConfig.blockSizeHorizontal * 25.0;
    height = SizeConfig.blockSizeHorizontal * 25.0;

    if (pokemon == null) return;

    body = _SquareNodeBody(pokemon: pokemon!);
  }

  PokemonNode.small({
    Key? key,
    required this.pokemon,
    this.onPressed,
    this.onEmptyPressed,
    this.onMoveChanged,
    this.emptyTransparent = false,
    this.padding,
    this.dropdowns = true,
    this.rating = false,
  }) : super(key: key) {
    width = SizeConfig.screenWidth * .95;
    height = SizeConfig.blockSizeVertical * 14.0;

    body = _SmallNodeBody(
      pokemon: pokemon!,
      dropdowns: dropdowns,
      onMoveChanged: onMoveChanged,
      rating: rating,
    );
  }

  PokemonNode.large({
    Key? key,
    required this.pokemon,
    this.onPressed,
    this.onEmptyPressed,
    this.onMoveChanged,
    this.cup,
    this.footer,
    this.emptyTransparent = false,
    this.padding,
  }) : super(key: key) {
    width = SizeConfig.screenWidth * .95;
    height = SizeConfig.screenHeight * .2;
    dropdowns = false;
    rating = false;

    if (pokemon == null) return;

    body = _LargeNodeBody(
      pokemon: pokemon!,
      cup: cup,
      footer: footer,
      onMoveChanged: onMoveChanged,
    );
  }

  final Pokemon? pokemon;
  late final VoidCallback? onPressed;
  late final VoidCallback? onEmptyPressed;
  late final VoidCallback? onMoveChanged;

  late final double width;
  late final double height;

  late final Cup? cup;

  late final Widget body;
  late final Widget? footer;
  final bool emptyTransparent;
  final EdgeInsets? padding;
  late final bool dropdowns;
  late final bool rating;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: pokemon == null
          ? EmptyNode(
              onPressed: onEmptyPressed,
              emptyTransparent: emptyTransparent,
            )
          : ColoredContainer(
              padding: padding ??
                  EdgeInsets.only(
                    top: SizeConfig.blockSizeHorizontal * .5,
                    left: SizeConfig.blockSizeHorizontal * 2.0,
                    right: SizeConfig.blockSizeHorizontal * 2.0,
                    bottom: SizeConfig.blockSizeHorizontal * .5,
                  ),
              pokemon: pokemon!,
              child: onPressed == null
                  ? body
                  : MaterialButton(
                      onPressed: onPressed,
                      child: body,
                    ),
            ),
    );
  }
}

class _SquareNodeBody extends StatelessWidget {
  const _SquareNodeBody({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pokemon name
        FormattedPokemonName(
          name: pokemon.speciesName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: SizeConfig.h3,
            fontWeight: FontWeight.bold,
            fontFamily: DefaultTextStyle.of(context).style.fontFamily,
          ),
          suffixStyle: TextStyle(
            fontSize: SizeConfig.p,
            fontFamily: DefaultTextStyle.of(context).style.fontFamily,
          ),
        ),

        // A line divider
        Divider(
          color: Colors.white,
          thickness: SizeConfig.blockSizeHorizontal * 0.2,
        ),

        TraitsIcons(
          pokemon: pokemon,
          scale: .7,
        ),

        MoveDots(moveColors: pokemon.getMoveColors()),
      ],
    );
  }
}

class _SmallNodeBody extends StatelessWidget {
  const _SmallNodeBody({
    Key? key,
    required this.pokemon,
    required this.dropdowns,
    required this.onMoveChanged,
    required this.rating,
  }) : super(key: key);

  final Pokemon pokemon;
  final bool dropdowns;
  final VoidCallback? onMoveChanged;
  final bool rating;

  // Display the Pokemon's name perfect PVP ivs and typing icon(s)
  // If rating is true, place the rating in the upper left corner
  Row _buildNodeHeader(Pokemon pokemon) {
    if (rating) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pokemon cup - specific rating
          // Used for the ratings pages
          Text(
            pokemon.getRatingString(),
            style: TextStyle(
              fontSize: SizeConfig.h1,
              fontWeight: FontWeight.bold,
            ),
          ),

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
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.blockSizeVertical * .5,
        left: SizeConfig.blockSizeHorizontal * 2.0,
        right: SizeConfig.blockSizeHorizontal * 2.0,
        bottom: SizeConfig.blockSizeVertical * 1.5,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNodeHeader(pokemon),

          // A line divider
          Divider(
            color: Colors.white,
            thickness: SizeConfig.blockSizeHorizontal * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          dropdowns
              ? MoveDropdowns(
                  pokemon: pokemon,
                  onChanged: onMoveChanged,
                )
              : MoveNodes(pokemon: pokemon),
        ],
      ),
    );
  }
}

class _LargeNodeBody extends StatelessWidget {
  const _LargeNodeBody({
    Key? key,
    required this.pokemon,
    required this.cup,
    required this.footer,
    this.onMoveChanged,
  }) : super(key: key);

  final Pokemon pokemon;
  final Cup? cup;
  final Widget? footer;
  final VoidCallback? onMoveChanged;

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
    return Padding(
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
          _buildNodeHeader(pokemon, cup),

          // A line divider
          Divider(
            color: Colors.white,
            thickness: SizeConfig.blockSizeHorizontal * 0.2,
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          MoveDropdowns(
            pokemon: pokemon,
            onChanged: onMoveChanged,
          ),

          footer ?? Container(),
        ],
      ),
    );
  }
}
