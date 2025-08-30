import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 68,
      backgroundColor: Colors.green.shade50,
      indicatorColor: Colors.green.shade200.withValues(alpha: 0.7),
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      animationDuration: const Duration(milliseconds: 500),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: currentIndex == 0
                ? Icon(Icons.home_rounded, key: const ValueKey('home_filled'), color: Colors.green.shade700)
                : Icon(Icons.home_outlined, key: const ValueKey('home_outlined'), color: Colors.green.shade400),
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: currentIndex == 1
                ? Icon(Icons.flag_rounded, key: const ValueKey('flag_filled'), color: Colors.green.shade700)
                : Icon(Icons.flag_outlined, key: const ValueKey('flag_outlined'), color: Colors.green.shade400),
          ),
          label: 'Quests',
        ),
        NavigationDestination(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: currentIndex == 2
                ? Icon(Icons.eco_rounded, key: const ValueKey('eco_filled'), color: Colors.green.shade700)
                : Icon(Icons.person_outline, key: const ValueKey('person_outlined'), color: Colors.green.shade400),
          ),
          label: 'Profile',
        ),
      ],
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          );
        }
        return TextStyle(
          color: Colors.green.shade400,
        );
      }),
    );
  }
}