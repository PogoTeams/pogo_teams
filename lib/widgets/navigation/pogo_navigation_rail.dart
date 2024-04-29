// flutter
import 'package:flutter/material.dart';

// recipio
import '../../app/ui/sizing.dart';
import '../../pages/pogo_pages.dart';
import '../../utils/animations.dart';
import '../transitions/nav_rail_transition.dart';

class PogoNavigationRail extends StatelessWidget {
  const PogoNavigationRail({
    super.key,
    required this.railAnimation,
    required this.railFabAnimation,
    required this.destinations,
    required this.selectedIndex,
    required this.backgroundColor,
    this.onDestinationSelected,
  });

  final RailAnimation railAnimation;
  final RailFabAnimation railFabAnimation;
  final List<PogoPages> destinations;
  final int selectedIndex;
  final Color backgroundColor;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavRailTransition(
      animation: railAnimation,
      backgroundColor: backgroundColor,
      child: NavigationRail(
        selectedIndex: selectedIndex,
        backgroundColor: backgroundColor,
        onDestinationSelected: onDestinationSelected,
        groupAlignment: Sizing.railGroupAlignment,
        destinations: destinations.map((d) {
          return NavigationRailDestination(
            icon: d.icon,
            label: Text(d.displayName),
          );
        }).toList(),
      ),
    );
  }
}
