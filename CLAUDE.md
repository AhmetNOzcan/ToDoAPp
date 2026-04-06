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
# Domain packages are pure Dart — use `dart test`. All others use `flutter test`.
cd packages/core && flutter test
cd packages/todo_feature/domain && dart test
cd packages/todo_feature/data && flutter test
cd packages/todo_feature/presentation && flutter test
cd packages/profile_feature/domain && dart test
cd packages/profile_feature/data && flutter test
cd packages/profile_feature/presentation && flutter test

# Run a single test file
cd packages/todo_feature/presentation && flutter test test/bloc/todo_list_bloc_test.dart

# Run a single test by name
cd packages/todo_feature/presentation && flutter test --name "emits loaded when LoadTodos succeeds"
```

There is no melos, Makefile, or CI config. Standard `flutter` CLI is used for everything.

## Architecture

Multi-package Flutter app using **Clean Architecture + BLoC**. Each feature is split into three sibling packages — one per layer — so dependency direction is enforced by the package system:

```
apps/
  todo_lite/                  # App shell: depends on todo_feature_presentation
  todo_pro/                   # App shell: depends on todo_feature_presentation + profile_feature_presentation
packages/
  core/                       # Shared: AppTheme, FeatureModule contract, service locator (GetIt)
  todo_feature/
    domain/                   # todo_feature_domain: entities, repository contracts, use cases, TodoStatsProvider (pure Dart, no Flutter dep)
    data/                     # todo_feature_data:   database, datasources, models, repository impls (depends on domain)
    presentation/             # todo_feature_presentation: BLoCs, pages, widgets, TodoModule (depends on domain + data)
  profile_feature/
    domain/                   # profile_feature_domain (pure Dart, no Flutter dep)
    data/                     # profile_feature_data (depends on profile_feature_domain)
    presentation/             # profile_feature_presentation (depends on profile_feature_domain + _data + todo_feature_domain)
```

Each layer package follows the same internal structure:

```
lib/src/
  # data layer
  database/                 # Feature-owned sqflite helper (opens its own .db file, manages schema)
  datasources/              # Abstract + Impl (resolve sqflite Database lazily via the feature helper)
  models/                   # Extend domain entities, add fromMap/toMap
  repositories/             # Implement domain repository contracts

  # domain layer
  entities/                 # Immutable Equatable value objects with copyWith
  repositories/             # Abstract repository interfaces
  usecases/                 # Single-responsibility callable classes (call() method)

  # presentation layer
  bloc/                     # BLoC + Events + State (status enum pattern: initial/loading/loaded/error)
  pages/                    # Full-screen widgets
  widgets/                  # Reusable UI components
  *_module.dart             # FeatureModule impl: registers DI + declares GoRouter routes (lives in presentation)
```

## Dependency Injection

**GetIt service locator** — the global instance lives in `core` (`sl` from `service_locator.dart`).

- `lib/di/injection.dart` bootstraps app-level singletons (e.g. `appDocumentsPath` for the profile feature), then calls `module.registerDependencies(sl)` for each feature module.
- Feature modules register their own database helper, data sources, and repositories as **lazy singletons**, use cases and BLoCs as **factories**. The app shell does not know about feature-specific databases.
- BLoCs are created inside each module's route definitions via `BlocProvider(create: (_) => sl<XBloc>())`, so each navigation creates a fresh BLoC instance.

## Routing

`GoRouter` with a `ShellRoute` for persistent bottom navigation. Each `FeatureModule` exposes `List<RouteBase> get routes` which are spread into the shell. Routes wrap pages with `BlocProvider` to inject the BLoC.

## Cross-feature contracts

When one feature needs data from another, the contract lives in the **domain** package of the feature that owns the data, not in `core`. For example, `TodoStatsProvider` is exported from `todo_feature_domain` and consumed by `profile_feature_presentation` (which depends on `todo_feature_domain` only for that contract). `core` stays free of feature-specific knowledge, and the consumer never has to depend on the producer's data or presentation layer.

## Database

SQLite via `sqflite`. **Each feature owns its own database file and schema** — there is no shared database helper. Adding a feature does not require touching `core` or any other feature.

- `todo_feature_data` → `todo_feature.db`, schema in `packages/todo_feature/data/lib/src/database/todo_database.dart` (table: `todos`)
- `profile_feature_data` → `profile_feature.db`, schema in `packages/profile_feature/data/lib/src/database/profile_database.dart` (table: `user_profile`, seeded with one row so `update` by `id=1` always succeeds)

Each feature helper exposes `Future<Database> get database` and lazily opens on first access. Data sources depend on the feature helper (not a `Database`) and `await helper.database` per call. Both schemas are at version 1, no migrations yet.

## Testing Conventions

- Mocking: **mocktail** (not mockito)
- BLoC tests: use `blocTest` from `bloc_test` package
- Test file structure mirrors source structure under `test/`
- All dependencies are constructor-injected, making mocking straightforward
