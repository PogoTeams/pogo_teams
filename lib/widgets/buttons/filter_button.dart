// Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return PopupMenuButton<String>(
      onSelected: onSelected,
      icon: const Icon(Icons.sort_rounded),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'attackers',
          child: PopupItem(
            category: 'attackers',
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
          value: 'closers',
          child: PopupItem(
            category: 'closers',
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
          value: 'leads',
          child: PopupItem(
            category: 'leads',
            selectedCategory: selectedCategory,
          ),
        ),
        PopupMenuItem<String>(
          value: 'overall',
          child: PopupItem(
            category: 'overall',
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
      ],
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
