// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class FormattedPokemonName extends StatelessWidget {
  const FormattedPokemonName({
    Key? key,
    required this.name,
    required this.style,
    this.textAlign = TextAlign.start,
    this.suffixStyle,
  }) : super(key: key);

  final String name;
  final TextStyle style;
  final TextAlign textAlign;
  final TextStyle? suffixStyle;

  @override
  Widget build(BuildContext context) {
    if (name.contains('(')) {
      String _name;
      String _suffix;

      int trimIndex = name.indexOf('(');
      _suffix = name.replaceRange(0, trimIndex - 1, '');
      _name = name.replaceRange(trimIndex - 1, name.length, '');

      return RichText(
        textAlign: textAlign,
        text: TextSpan(
          text: _name,
          children: [
            TextSpan(
              text: _suffix,
              style: suffixStyle,
            ),
          ],
          style: style,
        ),
      );
    }

    return Text(
      name,
      style: style,
      textAlign: textAlign,
    );
  }
}
