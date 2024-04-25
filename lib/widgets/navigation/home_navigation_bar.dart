// flutter
import 'package:flutter/material.dart';

// recipio
import '../../pages/pogo_pages.dart';
import '../../tools/animations.dart';
import '../transitions/bottom_bar_transition.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    super.key,
    required this.barAnimation,
    required this.destinations,
    required this.selectedIndex,
    required this.backgroundColor,
    this.onDestinationSelected,
  });

  final BarAnimation barAnimation;
  final List<PogoPages> destinations;
  final int selectedIndex;
  final Color backgroundColor;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return BottomBarTransition(
      animation: barAnimation,
      backgroundColor: backgroundColor,
      child: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: backgroundColor,
        elevation: 0,
        destinations: destinations.map<NavigationDestination>((d) {
          return NavigationDestination(
            icon: d.icon,
            label: d.name,
          );
        }).toList(),
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
