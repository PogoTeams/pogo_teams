// Flutter
import 'package:flutter/material.dart';

// Local Imports
import '../../app/ui/sizing.dart';
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
    super.key,
    required this.onSelected,
    required this.selectedCategory,
    this.dex = false,
  });

  final void Function(RankingsCategories) onSelected;
  final RankingsCategories selectedCategory;
  final bool dex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizing.formFieldHeight,
      height: Sizing.formFieldHeight,
      decoration: BoxDecoration(
        color: Colors.teal,
        border: Border.all(
          color: Colors.white,
          width: Sizing.borderWidth,
        ),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<RankingsCategories>(
        position: PopupMenuPosition.over,
        onSelected: onSelected,
        icon: const Icon(Icons.sort_sharp),

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
    super.key,
    required this.category,
    required this.selectedCategory,
  });

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
