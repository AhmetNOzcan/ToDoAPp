#!/bin/bash
# setup.sh - Initial setup script for the ToDo App Workspace

echo "🚀 Bootstrapping ToDo App Workspace..."

# 1. Fetch dependencies for the entire Dart workspace
echo "📦 Resolving workspace dependencies..."
flutter pub get

# 2. Generate Easy Localization keys
echo "🌐 Generating localization keys..."
cd packages/core || exit
sh scripts/generate_localization.sh
cd ../..

echo "✅ Setup complete! You can now run the app or execute tests."
