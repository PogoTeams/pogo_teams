// Flutter Imports
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';
import '../../enums/pokemon_filters.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A floating action button that is docked at the bottom right of the Pokemon
search screen. This button allows the user to sort the list by various
PVP related categories.
-------------------------------------------------------------------------------
*/

class FilterButton extends StatelessWidget {
  const FilterButton({
    Key? key,
    required this.onSelected,
    required this.selectedCategory,
    this.size,
    this.dex = false,
  }) : super(key: key);

  final void Function(PokemonFilters) onSelected;
  final PokemonFilters selectedCategory;
  final double? size;
  final bool dex;

  @override
  Widget build(BuildContext context) {
    final _size = size ?? Sizing.blockSizeHorizontal * 14.0;

    return Container(
      height: _size,
      width: _size,
      decoration: BoxDecoration(
        color: Colors.teal,
        border: Border.all(
          color: Colors.white,
          width: Sizing.blockSizeHorizontal * .7,
        ),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<PokemonFilters>(
        onSelected: onSelected,
        icon: const Icon(Icons.sort_sharp),
        iconSize: _size / 2,

        // Category options
        itemBuilder: (BuildContext context) {
          final items = <PopupMenuEntry<PokemonFilters>>[
            PopupMenuItem<PokemonFilters>(
              value: PokemonFilters.overall,
              child: PopupItem(
                category: PokemonFilters.overall,
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<PokemonFilters>(
              value: PokemonFilters.leads,
              child: PopupItem(
                category: PokemonFilters.leads,
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<PokemonFilters>(
              value: PokemonFilters.switches,
              child: PopupItem(
                category: PokemonFilters.switches,
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<PokemonFilters>(
              value: PokemonFilters.closers,
              child: PopupItem(
                category: PokemonFilters.closers,
                selectedCategory: selectedCategory,
              ),
            ),
          ];

          // Optionally add dex
          // This option is excluded in the rankings page
          if (dex) {
            items.add(
              PopupMenuItem<PokemonFilters>(
                value: PokemonFilters.dex,
                child: PopupItem(
                  category: PokemonFilters.dex,
                  selectedCategory: selectedCategory,
                ),
              ),
            );
          }

          return items;
        },
      ),
    );
  }
}

class PopupItem extends StatelessWidget {
  const PopupItem({
    Key? key,
    required this.category,
    required this.selectedCategory,
  }) : super(key: key);

  final PokemonFilters category;
  final PokemonFilters selectedCategory;

  @override
  Widget build(BuildContext context) {
    return category == selectedCategory
        ? Text(
            category.displayName,
            style: const TextStyle(color: Colors.yellow),
          )
        : Text(category.displayName);
  }
}
