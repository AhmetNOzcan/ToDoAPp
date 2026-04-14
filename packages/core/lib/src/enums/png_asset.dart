// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'monorepo_asset_resolver.dart';

/// Type-safe references to PNG / raster image assets.
///
/// Convention: `assets/images/img_{name}.png`
///
/// Base assets live in `packages/core/assets/images/`.
/// Override: place a file at `apps/{shell}/assets/images/img_{name}.png`
/// (same convention as localization overrides).
///
/// ```dart
/// PngAsset.more_birds.toWidget(height: 150, fit: BoxFit.cover);
/// ```
enum PngAsset {
  profile_placeholder,
  more_birds;

  String get path => 'assets/images/img_$name.png';

  Image toWidget({
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
  }) =>
      Image.asset(
        path,
        package: MonorepoAssetResolver.instance.packageFor(path),
        height: height,
        width: width,
        color: color,
        fit: fit,
      );

  /// All paths — used by [MonorepoAssetResolver.init] at startup.
  static List<String> get allPaths => values.map((e) => e.path).toList();
}
