import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_feature_navigation/todo_feature_navigation.dart';

import 'di/injection.dart';

class TodoLiteApp extends StatelessWidget {
  TodoLiteApp({super.key});

  late final GoRouter _router = GoRouter(
    initialLocation: TodoRoutes.locationList(),
    routes: [...featureModules.expand((m) => m.routes)],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Todo Lite',
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
