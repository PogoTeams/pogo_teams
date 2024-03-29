// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../modules/ui/sizing.dart';
import '../../enums/rankings_categories.dart';

/*
-------------------------------------------------------------------- @PogoTeams
A floating action button that is docked at the bottom right of the Pokemon
search screen. This button allows the user to sort the list by various
PVP related categories.
-------------------------------------------------------------------------------
*/

class RankingsCategoryButton extends StatelessWidget {
  const RankingsCategoryButton({
    Key? key,
    required this.onSelected,
    required this.selectedCategory,
    this.size,
    this.dex = false,
  }) : super(key: key);

  final void Function(RankingsCategories) onSelected;
  final RankingsCategories selectedCategory;
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
      child: PopupMenuButton<RankingsCategories>(
        position: PopupMenuPosition.over,
        onSelected: onSelected,
        icon: const Icon(Icons.sort_sharp),
        iconSize: _size / 2,

        // Category options
        itemBuilder: (BuildContext context) {
          final items = <PopupMenuEntry<RankingsCategories>>[
            PopupMenuItem<RankingsCategories>(
              value: RankingsCategories.overall,
              child: PopupItem(
                category: RankingsCategories.overall,
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<RankingsCategories>(
              value: RankingsCategories.leads,
              child: PopupItem(
                category: RankingsCategories.leads,
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<RankingsCategories>(
              value: RankingsCategories.switches,
              child: PopupItem(
                category: RankingsCategories.switches,
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<RankingsCategories>(
              value: RankingsCategories.closers,
              child: PopupItem(
                category: RankingsCategories.closers,
                selectedCategory: selectedCategory,
              ),
            ),
          ];

          // Optionally add dex
          // This option is excluded in the rankings page
          if (dex) {
            items.add(
              PopupMenuItem<RankingsCategories>(
                value: RankingsCategories.dex,
                child: PopupItem(
                  category: RankingsCategories.dex,
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

  final RankingsCategories category;
  final RankingsCategories selectedCategory;

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
