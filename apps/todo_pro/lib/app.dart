import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profile_feature_navigation/profile_feature_navigation.dart';
import 'package:todo_feature_navigation/todo_feature_navigation.dart';

class TodoProApp extends StatelessWidget {
  TodoProApp({super.key});

  late final GoRouter _router = GoRouter(
    initialLocation: sl<TodoNavigator>().initialLocation,
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            _ScaffoldWithBottomNav(child: child),
        routes: sl
            .getAll<NavGraph>()
            .expand((g) => g.build())
            .toList(growable: false),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Todo Pro',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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

class _ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithBottomNav({required this.child});

  @override
  Widget build(BuildContext context) {
    final todoNav = sl<TodoNavigator>();
    final profileNav = sl<ProfileNavigator>();
    final tabs = <_TabDescriptor>[
      _TabDescriptor(
        icon: Icons.checklist_rounded,
        label: LocaleKeys.tasks.localize,
        matches: todoNav.matches,
        go: todoNav.goToList,
      ),
      _TabDescriptor(
        icon: Icons.person_outline,
        label: LocaleKeys.profile.localize,
        matches: profileNav.matches,
        go: profileNav.goToRoot,
      ),
    ];

    final location = GoRouterState.of(context).uri.toString();
    var selectedIndex = 0;
    for (var i = 0; i < tabs.length; i++) {
      if (tabs[i].matches(location)) {
        selectedIndex = i;
        break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => tabs[index].go(context),
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}
