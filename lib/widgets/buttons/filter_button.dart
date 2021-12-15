// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Local Imports
import '../../configs/size_config.dart';

/*
-------------------------------------------------------------------------------
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

  final void Function(dynamic) onSelected;
  final String selectedCategory;
  final double? size;
  final bool dex;

  @override
  Widget build(BuildContext context) {
    final _size = size ?? SizeConfig.blockSizeHorizontal * 14.0;

    return Container(
      height: _size,
      width: _size,
      decoration: BoxDecoration(
        color: Colors.teal,
        border: Border.all(
          color: Colors.white,
          width: SizeConfig.blockSizeHorizontal * .7,
        ),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        icon: const Icon(Icons.sort_sharp),
        iconSize: _size / 2,

        // Category options
        itemBuilder: (BuildContext context) {
          final items = <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'overall',
              child: PopupItem(
                category: 'overall',
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<String>(
              value: 'leads',
              child: PopupItem(
                category: 'leads',
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<String>(
              value: 'attackers',
              child: PopupItem(
                category: 'attackers',
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<String>(
              value: 'closers',
              child: PopupItem(
                category: 'closers',
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<String>(
              value: 'chargers',
              child: PopupItem(
                category: 'chargers',
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<String>(
              value: 'consistency',
              child: PopupItem(
                category: 'consistency',
                selectedCategory: selectedCategory,
              ),
            ),
            PopupMenuItem<String>(
              value: 'switches',
              child: PopupItem(
                category: 'switches',
                selectedCategory: selectedCategory,
              ),
            ),
          ];

          // Optionally add dex
          // This option is excluded in the rankings page
          // since PvPoke only ranks a subset of the dex
          if (dex) {
            items.add(
              PopupMenuItem<String>(
                value: 'dex',
                child: PopupItem(
                  category: 'dex',
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

  final String category;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return category == selectedCategory
        ? Text(category, style: const TextStyle(color: Colors.yellow))
        : Text(category);
  }
}
