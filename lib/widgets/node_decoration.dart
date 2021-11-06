import 'package:flutter/material.dart';
import '../data/pokemon.dart';
import '../configs/size_config.dart';

// If the pokemon is monotype, color the node to this type
// For duotyping, render a linear gradient between the type colors
BoxDecoration buildDecoration(Pokemon pokemon,
    {Border? border, double borderRadius = 2.5}) {
  if (pokemon.typing.isMonoType()) {
    return BoxDecoration(
      color: pokemon.getTypeColors()[0],
      border: border,
      borderRadius:
          BorderRadius.circular(SizeConfig.blockSizeHorizontal * borderRadius),
    );
  }

  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: pokemon.getTypeColors(),
      tileMode: TileMode.clamp,
    ),
    border: border,
    borderRadius:
        BorderRadius.circular(SizeConfig.blockSizeHorizontal * borderRadius),
  );
}
