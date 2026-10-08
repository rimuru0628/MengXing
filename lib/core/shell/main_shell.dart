import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/kuromi_theme.dart';
import '../l10n/locale_provider.dart';

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: KColors.bg,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: KColors.bg,
          border: Border(
              top: BorderSide(color: KColors.divider.withOpacity(0.6))),
          boxShadow: [
            BoxShadow(
              color: KColors.primary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (i) {
            navigationShell.goBranch(
              i,
              initialLocation: i == navigationShell.currentIndex,
            );
          },
          backgroundColor: Colors.transparent,
          indicatorColor: KColors.primary.withOpacity(0.2),
          shadowColor: Colors.transparent,
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: s.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.directions_walk_outlined),
              selectedIcon: const Icon(Icons.directions_walk_rounded),
              label: s.navWalk,
            ),
            NavigationDestination(
              icon: const Icon(Icons.fitness_center_outlined),
              selectedIcon: const Icon(Icons.fitness_center_rounded),
              label: s.navExercise,
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart_rounded),
              label: s.navProgress,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: s.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
