#!/bin/bash
# setup.sh - Initial setup script for the ToDo App Workspace

set -e

echo "🚀 Bootstrapping ToDo App Workspace..."

# 1. Fetch dependencies for the entire Dart workspace
echo "📦 Resolving workspace dependencies..."
flutter pub get

# 2. Generate Easy Localization keys
echo "🌐 Generating localization keys..."
(cd packages/core && sh scripts/generate_localization.sh)

# 3. Generate injectable bindings.
#
# build_runner runs per-package. Each layer that hosts an
# `@InjectableInit.microPackage()` (domain + data + presentation, per
# feature) needs its own invocation, plus each app for the top-level
# `@InjectableInit` that composes them. The generator follows the import
# graph, so cross-package types are validated at app composition time.
echo "🔧 Generating injectable bindings..."
for pkg in \
  packages/todo_feature/domain \
  packages/todo_feature/data \
  packages/todo_feature/presentation \
  packages/profile_feature/domain \
  packages/profile_feature/data \
  packages/profile_feature/presentation \
  apps/todo_lite \
  apps/todo_pro; do
  echo "  → $pkg"
  (cd "$pkg" && dart run build_runner build --delete-conflicting-outputs)
done

echo "✅ Setup complete! You can now run the app or execute tests."
