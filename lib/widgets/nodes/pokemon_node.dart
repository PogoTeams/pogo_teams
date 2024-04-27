// Flutter
import 'package:flutter/material.dart';

// Local Imports
import 'empty_node.dart';
import 'move_node.dart';
import '../../model/pokemon.dart';
import '../../model/cup.dart';
import '../pvp_stats.dart';
import '../dropdowns/move_dropdowns.dart';
import '../traits_icons.dart';
import '../colored_container.dart';
import '../formatted_pokemon_name.dart';
import '../../modules/stats.dart';
import '../../app/ui/sizing.dart';
import '../../app/ui/pogo_colors.dart';
import '../../app/ui/pogo_icons.dart';

/*
-------------------------------------------------------------------- @PogoTeams
Any Pokemon information being displayed in the app is done so through a
PokemonNode. The node can take many different forms depending on the context.
-------------------------------------------------------------------------------
*/

class PokemonNode extends StatelessWidget {
  PokemonNode.square({
    super.key,
    required this.pokemon,
    required BuildContext context,
    this.onPressed,
    this.onEmptyPressed,
    this.emptyTransparent = false,
    this.padding,
    this.lead = false,
  }) {
    width = Sizing.screenWidth(context) * .25;
    height = Sizing.screenWidth(context) * .25;
    cup = null;
    dropdowns = false;

    if (pokemon == null) return;

    body = _SquareNodeBody(pokemon: pokemon!);
  }

  PokemonNode.small({
    super.key,
    required this.pokemon,
    required BuildContext context,
    this.onPressed,
    this.onEmptyPressed,
    this.onMoveChanged,
    this.emptyTransparent = false,
    this.padding,
    this.dropdowns = true,
    this.rating,
    this.lead = false,
  }) {
    width = double.infinity;
    height = Sizing.screenHeight(context) * .15;

    body = _SmallNodeBody(
      pokemon: pokemon!,
      dropdowns: dropdowns,
      onMoveChanged: onMoveChanged,
      rating: rating,
    );
  }

  PokemonNode.large({
    super.key,
    required this.pokemon,
    required BuildContext context,
    this.onPressed,
    this.onEmptyPressed,
    this.onMoveChanged,
    this.cup,
    this.footer,
    this.emptyTransparent = false,
    this.padding,
    this.lead = false,
  }) {
    width = double.infinity;
    height = Sizing.screenHeight(context) * .24;
    dropdowns = false;

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

  late final Cup? cup;

  late final Widget body;
  late final Widget? footer;
  final bool emptyTransparent;
  final EdgeInsets? padding;
  late final double width;
  late final double height;
  late final bool dropdowns;
  late final String? rating;
  late final bool lead;

  Widget _buildPokemonNode(BuildContext context) {
    return pokemon == null
        ? EmptyNode(
            onPressed: onEmptyPressed,
            emptyTransparent: emptyTransparent,
          )
        : ColoredContainer(
            padding: padding ?? EdgeInsets.zero,
            pokemon: pokemon!.getBase(),
            child: onPressed == null
                ? body
                : MaterialButton(
                    onPressed: onPressed,
                    child: body,
                  ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: lead
          ? Stack(
              fit: StackFit.passthrough,
              children: [
                _buildPokemonNode(context),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 25.0,
                    height: Sizing.screenWidth(context) * .15,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2),
                        bottomRight: Radius.circular(2),
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          'Lead',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : _buildPokemonNode(context),
    );
  }
}

class _SquareNodeBody extends StatelessWidget {
  const _SquareNodeBody({
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizing.screenHeight(context) * .01,
        bottom: Sizing.screenHeight(context) * .01,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Pokemon name
          Flexible(
            flex: 3,
            child: FittedBox(
              child: FormattedPokemonName(
                pokemon: pokemon.getBase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
                suffixStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),

          Flexible(
            flex: 1,
            child: TraitsIcons(
              pokemon: pokemon.getBase(),
              scale: .7,
            ),
          ),

          Flexible(
            child: MoveDots(
              moveColors: PogoColors.getPokemonMovesetColors(pokemon.moveset()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallNodeBody extends StatelessWidget {
  const _SmallNodeBody({
    required this.pokemon,
    required this.dropdowns,
    required this.onMoveChanged,
    this.rating,
  });

  final Pokemon pokemon;
  final bool dropdowns;
  final VoidCallback? onMoveChanged;
  final String? rating;

  // Display the Pokemon's name perfect PVP ivs and typing icon(s)
  // If rating is true, place the rating in the upper left corner
  Row _buildNodeHeader(BuildContext context, Pokemon pokemon) {
    if (rating == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pokemon name
          FittedBox(
            child: FormattedPokemonName(
              pokemon: pokemon.getBase(),
              suffixDivider: '  ',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
              suffixStyle: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Traits Icons
          TraitsIcons(pokemon: pokemon.getBase()),

          // Typing icon(s)
          Container(
            alignment: Alignment.topRight,
            child: Row(
              children:
                  PogoIcons.getPokemonTypingIcons(pokemon.getBase().typing),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pokemon cup - specific rating
        // Used for the ratings pages
        Text(
          rating!,
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        // Pokemon name
        FittedBox(
          child: FormattedPokemonName(
            pokemon: pokemon.getBase(),
            suffixDivider: '  ',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
            suffixStyle: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        // Traits Icons
        TraitsIcons(pokemon: pokemon.getBase()),

        // Typing icon(s)
        Container(
          alignment: Alignment.topRight,
          child: Row(
            children: PogoIcons.getPokemonTypingIcons(pokemon.getBase().typing),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10.0,
        1.0,
        10.0,
        10.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: _buildNodeHeader(context, pokemon),
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          Flexible(
            flex: 2,
            child: dropdowns
                ? MoveDropdowns(
                    pokemon: pokemon,
                    onChanged: onMoveChanged,
                  )
                : MoveNodes(pokemon: pokemon),
          ),
        ],
      ),
    );
  }
}

class _LargeNodeBody extends StatelessWidget {
  const _LargeNodeBody({
    required this.pokemon,
    required this.cup,
    required this.footer,
    this.onMoveChanged,
  });

  final Pokemon pokemon;
  final Cup? cup;
  final Widget? footer;
  final VoidCallback? onMoveChanged;

  // Display the Pokemon's name perfect PVP ivs and typing icon(s)
  Row _buildNodeHeader(BuildContext context, Pokemon pokemon, Cup? cup) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pokemon name
        FittedBox(
          child: FormattedPokemonName(
            pokemon: pokemon.getBase(),
            suffixDivider: '\n',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
            suffixStyle: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        // Traits Icons
        TraitsIcons(pokemon: pokemon.getBase()),

        // The perfect IVs for this Pokemon given the selected cup
        cup == null
            ? Container()
            : PvpStats(
                cp: Stats.calculateCP(pokemon.getBase().stats, pokemon.ivs),
                ivs: pokemon.ivs,
              ),

        // Typing icon(s)
        Container(
          alignment: Alignment.topRight,
          child: Row(
            children: PogoIcons.getPokemonTypingIcons(pokemon.getBase().typing),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10.0,
        10.0,
        10.0,
        1.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pokemon name, perfect IVs, and typing icons
          Flexible(
            flex: 1,
            child: _buildNodeHeader(context, pokemon, cup),
          ),

          // The dropdowns for the Pokemon's moves
          // Defaults to the most meta relavent moves
          Flexible(
            flex: 2,
            child: MoveDropdowns(
              pokemon: pokemon,
              onChanged: onMoveChanged,
            ),
          ),

          if (footer != null) footer!,
        ],
      ),
    );
  }
}
