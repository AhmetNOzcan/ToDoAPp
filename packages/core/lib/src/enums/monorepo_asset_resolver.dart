import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'png_asset.dart';
import 'svg_asset.dart';
import 'lottie_asset.dart';

/// Resolves asset paths with app-shell override support.
///
/// Mirrors [MonorepoAssetLoader] for localization: base assets live in
/// `core`, app shells can override by placing a file at the same path
/// under their own `assets/` directory.
///
/// **Override convention (same as localization):**
/// ```
/// Base:     packages/core/assets/images/img_logo.png
/// Override: apps/todo_pro/assets/images/img_logo.png
/// ```
///
/// Initialize once at app startup (after `WidgetsFlutterBinding`):
/// ```dart
/// await MonorepoAssetResolver.instance.init();
/// ```
class MonorepoAssetResolver {
  MonorepoAssetResolver._();
  static final MonorepoAssetResolver instance = MonorepoAssetResolver._();

  /// Paths that the app shell overrides (probed at startup).
  final Set<String> _shellOverrides = {};

  bool _initialized = false;

  /// Probe which core assets the running app shell overrides.
  ///
  /// Call this once during app startup. It iterates all registered enum
  /// paths and checks if the shell's asset bundle contains an override.
  Future<void> init() async {
    if (_initialized) return;

    final allAssetPaths = [
      ...PngAsset.allPaths,
      ...SvgAsset.allPaths,
      ...LottieAsset.allPaths,
    ];

    for (final path in allAssetPaths) {
      try {
        await rootBundle.load(path);
        // Shell has this asset → will be loaded directly (no package prefix)
        _shellOverrides.add(path);
        debugPrint('MonorepoAssetResolver: shell override found → $path');
      } catch (_) {
        // Shell does not override this asset → core's version will be used
      }
    }

    _initialized = true;
    debugPrint(
      'MonorepoAssetResolver: ${_shellOverrides.length} override(s) found '
      'out of ${allAssetPaths.length} asset(s)',
    );
  }

  /// Returns `true` if the running app shell provides its own version
  /// of this asset.
  bool hasOverride(String path) => _shellOverrides.contains(path);

  /// Returns the effective `package` value for [Image.asset] / [SvgPicture.asset].
  ///
  /// - `null` → load from app shell (override exists)
  /// - `'core'` → load from core package (no override)
  String? packageFor(String path) => hasOverride(path) ? null : 'core';
}
