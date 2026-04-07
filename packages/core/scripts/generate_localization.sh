#!/bin/bash
# Run from packages/core
echo "Generating easy_localization keys..."
dart run easy_localization:generate -S assets/translations -O lib/src/localization -f keys -o locale_keys.g.dart
echo "Done!"
