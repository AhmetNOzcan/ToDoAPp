# PR Review Guide

This guide codifies the architectural decisions in this monorepo so reviewers can catch violations early. Every checklist item maps to a real design choice — not a generic best practice.

---

## 1. Package & Layer Boundaries

### Dependency Direction

The package system enforces `presentation → domain ← data`. A PR that breaks this is a structural regression.

| Check | What to look for |
|-------|-----------------|
| Domain stays pure Dart | `domain/pubspec.yaml` must NOT depend on `flutter`, `sqflite`, `path_provider`, or any data/presentation package |
| Data depends only on its own domain | `todo_feature_data` may import `todo_feature_domain` but never `todo_feature_presentation` or another feature's data |
| Presentation depends on its own domain + data only | `todo_feature_presentation` may import `todo_feature_domain` and `todo_feature_data`, never another feature's data or presentation |
| Core is feature-agnostic | `packages/core/pubspec.yaml` must NOT reference any feature package |
| Cross-feature deps go through domain contracts | If feature B needs data from feature A, it imports `feature_a_domain` — never `feature_a_data` or `feature_a_presentation` |

**Red flags in diffs:**
- A new `import 'package:todo_feature_data/...'` inside `profile_feature_presentation`
- Any feature package appearing in `core/pubspec.yaml`
- `import 'package:flutter/...'` inside a `domain` package

---

## 2. Feature Isolation

Each feature is a self-contained vertical slice. Adding or removing a feature should not require touching core or other features.

| Check | What to look for |
|-------|-----------------|
| Own database file | New features must create their own `*_database.dart` with a unique `.db` filename — never extend an existing feature's database |
| Own DI module | Each layer (`domain`, `data`, `navigation`, `presentation`) must have its own `*_di.module.dart` registered via `@InjectableInit.microPackage()` |
| Own NavGraph | New features must implement `NavGraph` from core and register it as a `@LazySingleton(as: NavGraph)` with a `@Named` qualifier |
| Own Navigator | Route constants live in a `*_routes.dart`, navigator contract in an abstract class, impl in `*_navigator_impl.dart` |
| No shared tables | Features must not read from or write to another feature's database tables |

**Red flags in diffs:**
- Adding a column to `todo_database.dart` for profile-related data
- A feature's DI module registering another feature's classes
- A new route defined outside a NavGraph implementation

---

## 3. Barrel Exports

Each package controls its public API through a single barrel file (`lib/<package_name>.dart`). Internal implementation details must not leak.

| Check | What to look for |
|-------|-----------------|
| Data layer hides internals | `todo_feature_data.dart` should only export its DI module — never `TodoDatabase`, `TodoModel`, or `TodoLocalDataSource` directly |
| Domain exports contracts + entities | Entities, repository interfaces, use cases, and cross-feature contracts are exported. Nothing else |
| Consumers use barrel imports | External code imports `package:todo_feature_domain/todo_feature_domain.dart`, not `package:todo_feature_domain/src/entities/todo.dart` |

**Red flags in diffs:**
- A `src/` path appearing in an import from outside the package
- Database helpers or data source implementations being added to a barrel export
- Model classes exported from the data layer barrel

---

## 4. Dependency Injection

### Registration Rules

| Registration | When to use | Example |
|-------------|------------|---------|
| `@injectable` (factory) | BLoCs, use cases — fresh instance per request | `TodoListBloc`, `GetTodos` |
| `@lazySingleton` | Database helpers, data sources, repositories — shared instance | `TodoDatabase`, `TodoRepositoryImpl` |
| `@module` abstract class | Binding an impl to multiple interfaces, or wrapping third-party classes | `TodoRepositoryBindings`, `ProfileThirdPartyModule` |
| `@preResolve` | Async setup that must complete before DI graph is ready | `ProfileEnvironmentModule.appDocumentsPath` |

| Check | What to look for |
|-------|-----------------|
| BLoCs are factories | BLoCs annotated with `@lazySingleton` would share state across navigations — must be `@injectable` |
| Repositories are lazy singletons | A repository registered as `@injectable` would create duplicate DB connections |
| Multi-interface binding uses `@module` | If a class implements two contracts (e.g., `TodoRepository` + `TodoStatsProvider`), a `@module` with binding methods is required — not two separate registrations |
| App shell lists all external modules | `injection.dart` in the app shell must include every feature layer's module in `externalPackageModulesBefore`, in correct order (domain → data → navigation → presentation) |
| Named dependencies match | `@Named('appDocumentsPath')` at injection site must match the `@Named` at registration |

**Red flags in diffs:**
- `@lazySingleton` on a BLoC class
- `@injectable` on a database helper or repository
- A new feature module missing from the app shell's `@InjectableInit`
- Direct `sl.registerSingleton(...)` calls instead of using `injectable` annotations

---

## 5. Routing

| Check | What to look for |
|-------|-----------------|
| Routes defined in NavGraph | All routes must be returned from a `NavGraph.build()` implementation — never added directly to `GoRouter` in the app shell |
| BlocProvider wraps each route | Route builders must create BLoCs via `BlocProvider(create: (_) => sl<XBloc>())` — never reuse a BLoC across routes |
| Route constants are centralized | Path patterns and names live in `*_routes.dart` — no hardcoded path strings in widgets or navigation calls |
| Navigator contract is abstract | Navigation calls in widgets go through the abstract navigator (e.g., `sl<TodoNavigator>().pushDetail(context, id: 42)`) — never `context.go('/todos/42')` directly |
| App shells compose, not define | `todo_lite` and `todo_pro` call `sl.getAll<NavGraph>()` — they should not contain feature-specific route logic |

**Red flags in diffs:**
- `context.go('/todos/...')` in a widget file
- A GoRoute defined inside `app.dart` instead of a NavGraph
- A BLoC created outside a `BlocProvider` in a route builder
- Hardcoded path strings outside `*_routes.dart`

---

## 6. BLoC Patterns

### State Design

All BLoCs follow the status enum pattern:

```dart
enum XStatus { initial, loading, loaded, error }
```

| Check | What to look for |
|-------|-----------------|
| Status enum exists | Every BLoC state must have a status enum with at least `initial`, `loading`, `loaded`, `error` |
| State extends Equatable | Missing `Equatable` causes BLoC to emit duplicate states or skip rebuilds |
| `copyWith` method exists | State mutations must use `copyWith` — never construct a new state from scratch (loses other fields) |
| `props` includes all fields | A field missing from `props` makes equality checks ignore it — causes silent bugs |

### Event Design

| Check | What to look for |
|-------|-----------------|
| Sealed class hierarchy | Events must use `sealed class` for exhaustive matching |
| Events extend Equatable | Ensures event deduplication works correctly |
| Events carry only the data needed | An event should not carry the entire state — just the parameters for the action |

### Handler Design

| Check | What to look for |
|-------|-----------------|
| Loading state emitted first | Every async handler must emit `status: loading` before awaiting |
| Error caught in handler | Try-catch in the handler, converting to `status: error` with `errorMessage` |
| Use cases called, not repositories | BLoC handlers call injected use cases — never repositories directly |
| Reload-after-mutation pattern | After `AddTodo`, `ToggleTodo`, `DeleteTodo`, the BLoC re-dispatches `LoadTodos` to refresh the list |

**Red flags in diffs:**
- A BLoC importing a repository directly
- A handler that awaits without emitting `loading` first
- A state class without `copyWith`
- A non-sealed event base class

---

## 7. Domain Layer

### Entities

| Check | What to look for |
|-------|-----------------|
| Extends Equatable | All entities must extend `Equatable` with a complete `props` list |
| All fields are `final` | Entities are immutable value objects |
| `copyWith` provided | Needed for state updates without losing fields |
| Constructor uses `const` | Enable compile-time constants where possible |
| No Flutter imports | Domain entities are pure Dart |

### Use Cases

| Check | What to look for |
|-------|-----------------|
| Single responsibility | One use case = one action. `GetTodos` should not also filter or sort |
| `call()` method | Use cases are callable classes — `await getTodos()` not `await getTodos.execute()` |
| Constructor-injected repository | No `sl.get<>()` inside use cases — only constructor injection |
| Annotated `@injectable` | Use cases are factories (new instance per injection) |

### Repository Contracts

| Check | What to look for |
|-------|-----------------|
| Abstract class in domain | Repository interfaces live in `domain/lib/src/repositories/` |
| Returns domain entities | Never returns models, maps, or database-specific types |
| No implementation details | No `sqflite`, `Database`, or data-layer types in the signature |

### Cross-Feature Contracts

| Check | What to look for |
|-------|-----------------|
| Lives in the data-owner's domain | `TodoStatsProvider` is in `todo_feature_domain`, not in `core` or `profile_feature_domain` |
| Minimal surface area | Only expose what the consumer actually needs — not the full repository |
| Bound via `@module` | The data layer binds the impl to both the internal repo interface and the cross-feature contract |

**Red flags in diffs:**
- A cross-feature contract placed in `core`
- A consumer depending on the producer's data layer for a cross-feature need
- A use case with more than one public method

---

## 8. Data Layer

### Models

| Check | What to look for |
|-------|-----------------|
| Extends domain entity | `TodoModel extends Todo` — models are entity + serialization |
| `fromMap` factory | Converts database row to model. Boolean fields map from `int` (0/1) |
| `toMap` method | Converts model to database row. Excludes `id` when null (for inserts) |
| `fromEntity` factory | Converts domain entity to model for persistence |
| DateTime as ISO string | `createdAt.toIso8601String()` for storage, `DateTime.parse()` for retrieval |

### Data Sources

| Check | What to look for |
|-------|-----------------|
| Abstract + Impl pattern | Interface and implementation in the same file or directory |
| Takes database helper, not `Database` | Constructor receives `TodoDatabase`, not `Database` — lazy initialization via `await _db.database` |
| Registered as `@LazySingleton(as: Interface)` | Impl bound to its abstract interface |
| Returns models, not entities | Data sources work with `TodoModel`, repositories convert to `Todo` |

### Database Helpers

| Check | What to look for |
|-------|-----------------|
| Unique database filename | Each feature uses a distinct `.db` file — `todo_feature.db`, `profile_feature.db` |
| Lazy initialization | `Database? _database` with `??=` pattern in the getter |
| Schema in `_onCreate` | Table definitions live in the helper, not in data sources |
| `close()` method | Clean shutdown support |
| Registered as `@lazySingleton` | One database connection per feature |

### Repositories

| Check | What to look for |
|-------|-----------------|
| Implements domain contract | `TodoRepositoryImpl implements TodoRepository` |
| Converts entity ↔ model | `TodoModel.fromEntity(todo)` on the way in, returns domain entity on the way out |
| No business logic | Repositories are pass-through — transformation logic belongs in use cases |
| Implements cross-feature contracts | If the repo also serves as a `TodoStatsProvider`, it must implement both interfaces |

**Red flags in diffs:**
- A data source taking `Database` directly instead of the feature database helper
- A model that doesn't extend its domain entity
- Business logic (filtering, sorting, validation) inside a repository
- `toMap` including `id` unconditionally (would overwrite auto-increment)

---

## 9. Localization

| Check | What to look for |
|-------|-----------------|
| No hardcoded strings | All user-visible text must use `LocaleKeys.keyName.localize` |
| Key added to all locale files | New keys must appear in both `en-US.json` and `tr-TR.json` in `packages/core/assets/translations/` |
| Generated keys regenerated | After adding keys, `locale_keys.g.dart` must be regenerated via `sh packages/core/scripts/generate_localization.sh` |
| Shell overrides are optional | App shells may override core strings but are not required to |
| Uses `localize` extension | Code uses `.localize` (the custom extension), not `.tr()` directly — this decouples features from `easy_localization` |

**Red flags in diffs:**
- `Text('Save')` instead of `Text(LocaleKeys.save.localize)`
- A key present in `en-US.json` but missing from `tr-TR.json`
- Direct `.tr()` calls instead of `.localize`
- `locale_keys.g.dart` not updated after new keys were added

---

## 10. Asset Management

| Check | What to look for |
|-------|-----------------|
| Enum value added | New assets must have a corresponding enum value in `PngAsset`, `SvgAsset`, or `LottieAsset` in `packages/core/lib/src/enums/` |
| File naming convention | `img_{name}.png`, `ic_{name}.svg`, `dt_{name}.json` — enum name maps to file name |
| Base file in core | The default asset lives in `packages/core/assets/{images,icon,json}/` |
| Uses `toWidget()` | Code uses `SvgAsset.settings.toWidget(...)` — never `SvgPicture.asset('...')` with a hardcoded path |
| Shell override follows convention | If an app shell overrides an asset, the file goes in `apps/{shell}/assets/` with the exact same relative path |
| Shell pubspec includes folder | Override folders must be declared in the shell's `pubspec.yaml` under `flutter.assets` |

**Red flags in diffs:**
- `Image.asset('assets/images/img_logo.png')` instead of `PngAsset.logo.toWidget()`
- An asset file added without a corresponding enum value
- An enum value added without the matching file in `packages/core/assets/`
- Missing `package:` parameter in manual asset loading

---

## 11. Testing

### General Rules

| Check | What to look for |
|-------|-----------------|
| Uses `mocktail`, not `mockito` | All mocks must use `class MockX extends Mock implements X {}` from `mocktail` |
| Domain tests use `dart test` | Domain packages are pure Dart — `flutter test` would fail or be unnecessary |
| Test file mirrors source path | `lib/src/bloc/todo_list_bloc.dart` → `test/bloc/todo_list_bloc_test.dart` |
| AAA pattern | Tests follow Arrange-Act-Assert (or Given-When-Then) structure |
| Fallback values registered | Complex types used with `any()` or `captureAny()` need `registerFallbackValue()` in `setUpAll` |

### BLoC Tests

| Check | What to look for |
|-------|-----------------|
| Uses `blocTest` | BLoC tests use `blocTest<XBloc, XState>(...)` from `bloc_test` |
| Tests initial state | A plain `test()` verifying `bloc.state` matches the default constructor |
| Tests happy path | `setUp` stubs success → `act` dispatches event → `expect` checks `[loading, loaded]` |
| Tests error path | `setUp` stubs exception → `expect` checks `[loading, error]` with error message |
| Uses `seed` for pre-loaded state | When testing mutations on existing data, `seed: () => ...` sets initial state |
| Verifies use case calls | `verify: (_) { verify(() => mockUseCase()).called(1); }` |
| Fresh BLoC per test | A `buildBloc()` helper creates a new instance — never share BLoC instances across tests |

### Use Case Tests

| Check | What to look for |
|-------|-----------------|
| Mocks repository only | Use cases are tested with a mocked repository — no database or data source involved |
| Tests success return value | Verify the use case returns what the repository returns |
| Tests exception propagation | Verify that repository exceptions bubble up unchanged |
| Verifies single interaction | `verify(...).called(1)` + `verifyNoMoreInteractions(...)` |

### Model Tests

| Check | What to look for |
|-------|-----------------|
| Round-trip test | `fromMap(model.toMap()) == model` |
| Null id handling | `toMap` excludes `id` when null; `fromMap` handles null `id` |
| Boolean-int mapping | `isCompleted: true` → `is_completed: 1` and vice versa |
| `fromEntity` test | Entity → Model conversion preserves all fields |

### Repository Tests

| Check | What to look for |
|-------|-----------------|
| Mocks data source, not database | Repository tests never touch `Database` or `TodoDatabase` |
| Verifies entity→model conversion | Uses `captureAny()` to inspect the model passed to the data source |
| Returns domain entities | Ensures the repository returns `Todo`, not `TodoModel` |

---

## 12. App Shell Rules

| Check | What to look for |
|-------|-----------------|
| Shell is thin | App shells contain only `main.dart`, `app.dart`, and `di/injection.dart` — no business logic, no widgets beyond the shell scaffold |
| DI modules in correct order | `externalPackageModulesBefore` lists domain → data → navigation → presentation for each feature |
| Startup sequence correct | `WidgetsFlutterBinding.ensureInitialized()` → `EasyLocalization.ensureInitialized()` → `MonorepoAssetResolver.instance.init()` → `initDependencies()` → `runApp()` |
| todo_lite excludes profile | `todo_lite` must NOT depend on any `profile_feature_*` package |
| todo_pro includes all features | `todo_pro` must include both feature stacks in DI and routing |
| ShellRoute only in todo_pro | `todo_lite` uses flat routes; `todo_pro` uses `ShellRoute` with bottom nav |

**Red flags in diffs:**
- Business logic or widget code inside an app shell
- `profile_feature_*` appearing in `todo_lite/pubspec.yaml`
- DI modules listed out of order (presentation before domain would fail at runtime)
- `MonorepoAssetResolver.instance.init()` missing from startup

---

## Quick Reference: Common PR Mistakes

| Mistake | Why it matters |
|---------|---------------|
| Importing `src/` paths from another package | Breaks encapsulation; internal APIs can change without notice |
| Putting a cross-feature contract in `core` | Core must stay feature-agnostic; contracts belong in the data owner's domain |
| Using `context.go('/path')` in a widget | Hardcodes routes; breaks when paths change; bypasses the navigator contract |
| Registering a BLoC as singleton | Shares mutable state across navigations — causes stale data bugs |
| Adding columns to another feature's DB | Violates feature isolation; creates hidden coupling |
| Skipping `localize` for UI text | Breaks i18n; makes the app untranslatable |
| Using `Image.asset()` with a string path | Bypasses the monorepo asset resolver; breaks shell overrides |
| Testing with `mockito` instead of `mocktail` | Inconsistent with the rest of the codebase; `mocktail` doesn't need codegen |
| Calling a repository directly from a BLoC | Bypasses the use case layer; business logic ends up in the presentation layer |
| Missing `fromEntity` on a new model | Repository can't convert domain entities to models for persistence |
