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
  }) : super(key: key);

  final void Function(dynamic) onSelected;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    final double blockSize = SizeConfig.blockSizeHorizontal;

    return Container(
      height: blockSize * 14.0,
      width: blockSize * 14.0,
      decoration: BoxDecoration(
        color: Colors.teal,
        border: Border.all(
          color: Colors.white,
          width: blockSize * .7,
        ),
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        icon: const Icon(Icons.sort_sharp),
        iconSize: blockSize * 7.0,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
          PopupMenuItem<String>(
            value: 'dex',
            child: PopupItem(
              category: 'dex',
              selectedCategory: selectedCategory,
            ),
          ),
        ],
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
