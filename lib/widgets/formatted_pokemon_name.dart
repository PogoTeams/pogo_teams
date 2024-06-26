// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local
import '../model/pokemon_base.dart';

/*
-------------------------------------------------------------------- @PogoTeams
For any Pokemon that have a portion of their name enclosed by "()", a
conditional formatting will occur. Ex. for Stunfisk (Galarian), different
formatting can occur for "Stunfisk" and "(Galarian)".
-------------------------------------------------------------------------------
*/

class FormattedPokemonName extends StatelessWidget {
  const FormattedPokemonName({
    super.key,
    required this.pokemon,
    required this.style,
    this.textAlign = TextAlign.start,
    this.suffixDivider = '\n',
    this.suffixStyle,
  });

  final PokemonBase pokemon;
  final TextStyle? style;
  final TextAlign textAlign;
  final String suffixDivider;
  final TextStyle? suffixStyle;

  @override
  Widget build(BuildContext context) {
    if (!pokemon.form.contains('normal')) {
      String form = pokemon.getFormattedForm();

      return RichText(
        textAlign: textAlign,
        text: TextSpan(
          text: pokemon.name,
          children: [
            TextSpan(
              text: suffixDivider + form,
              style: suffixStyle,
            ),
          ],
          style: style,
        ),
      );
    }

    return Text(
      pokemon.name,
      style: style,
      textAlign: textAlign,
    );
  }
}
