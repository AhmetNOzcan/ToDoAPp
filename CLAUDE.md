# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
# Dependencies (run from root — packages use path deps so this covers everything)
flutter pub get

# Run the app
flutter run

# Lint
flutter analyze

# Run all tests (per-package, no monorepo tool)
cd packages/core && flutter test
cd packages/todo_feature && flutter test
cd packages/profile_feature && flutter test

# Run a single test file
cd packages/todo_feature && flutter test test/presentation/bloc/todo_list_bloc_test.dart

# Run a single test by name
cd packages/todo_feature && flutter test --name "emits loaded when LoadTodos succeeds"
```

There is no melos, Makefile, or CI config. Standard `flutter` CLI is used for everything.

## Architecture

Multi-package Flutter app using **Clean Architecture + BLoC**:

```
lib/                          # App shell: main.dart, app.dart (GoRouter + bottom nav), DI init
packages/
  core/                       # Shared: DatabaseHelper (sqflite), AppTheme, FeatureModule contract,
                              #         service locator (GetIt), TodoStatsProvider interface
  todo_feature/               # Todo CRUD feature
  profile_feature/            # User profile feature
```

Each feature package follows the same internal structure:

```
lib/src/
  data/
    datasources/              # Abstract + Impl (talk to sqflite Database directly)
    models/                   # Extend domain entities, add fromMap/toMap
    repositories/             # Implement domain repository contracts
  domain/
    entities/                 # Immutable Equatable value objects with copyWith
    repositories/             # Abstract repository interfaces
    usecases/                 # Single-responsibility callable classes (call() method)
  presentation/
    bloc/                     # BLoC + Events + State (status enum pattern: initial/loading/loaded/error)
    pages/                    # Full-screen widgets
    widgets/                  # Reusable UI components
  *_module.dart               # FeatureModule impl: registers DI + declares GoRouter routes
```

## Dependency Injection

**GetIt service locator** — the global instance lives in `core` (`sl` from `service_locator.dart`).

- `lib/di/injection.dart` bootstraps: registers Database and app documents path, then calls `module.registerDependencies(sl)` for each feature module.
- Feature modules register: data sources and repositories as **lazy singletons**, use cases and BLoCs as **factories**.
- BLoCs are created inside each module's route definitions via `BlocProvider(create: (_) => sl<XBloc>())`, so each navigation creates a fresh BLoC instance.

## Routing

`GoRouter` with a `ShellRoute` for persistent bottom navigation. Each `FeatureModule` exposes `List<RouteBase> get routes` which are spread into the shell. Routes wrap pages with `BlocProvider` to inject the BLoC.

## Database

SQLite via `sqflite`. Schema managed in `DatabaseHelper._onCreate` (version 1, no migrations yet). Tables: `todos`, `user_profile`.

## Testing Conventions

- Mocking: **mocktail** (not mockito)
- BLoC tests: use `blocTest` from `bloc_test` package
- Test file structure mirrors source structure under `test/`
- All dependencies are constructor-injected, making mocking straightforward
