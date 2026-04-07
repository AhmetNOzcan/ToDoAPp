#!/bin/bash
# Must be run from apps/todo_pro directory

echo "Generating easy_localization keys..."
dart run easy_localization:generate -S assets/translations -O ../../packages/core/lib/src/localization -f keys -o locale_keys.g.dart

echo "Done! The locale_keys.g.dart file has been placed in packages/core/lib/src/localization/"
