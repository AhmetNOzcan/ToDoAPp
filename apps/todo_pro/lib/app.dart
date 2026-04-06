import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_feature_navigation/profile_feature_navigation.dart';
import 'package:todo_feature_navigation/todo_feature_navigation.dart';

import 'di/injection.dart';

class TodoProApp extends StatelessWidget {
  TodoProApp({super.key});

  late final GoRouter _router = GoRouter(
    initialLocation: TodoRoutes.locationList(),
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            _ScaffoldWithBottomNav(child: child),
        routes: [
          ...featureModules.expand((m) => m.routes),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Todo Pro',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _TabDescriptor {
  const _TabDescriptor({
    required this.icon,
    required this.label,
    required this.matches,
    required this.go,
  });

  final IconData icon;
  final String label;
  final bool Function(String location) matches;
  final void Function(BuildContext context) go;
}

const List<_TabDescriptor> _tabs = <_TabDescriptor>[
  _TabDescriptor(
    icon: Icons.checklist_rounded,
    label: 'Todos',
    matches: TodoRoutes.matches,
    go: TodoNavigation.goToList,
  ),
  _TabDescriptor(
    icon: Icons.person_outline,
    label: 'Profile',
    matches: ProfileRoutes.matches,
    go: ProfileNavigation.goToRoot,
  ),
];

class _ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithBottomNav({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (var i = 0; i < _tabs.length; i++) {
      if (_tabs[i].matches(location)) return i;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    _tabs[index].go(context);
  }
}
