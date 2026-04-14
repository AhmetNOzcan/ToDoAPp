// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'monorepo_asset_resolver.dart';

/// Type-safe references to Lottie JSON animation assets.
///
/// Convention: `assets/json/dt_{name}.json`
///
/// Base assets live in `packages/core/assets/json/`.
/// Override: place a file at `apps/{shell}/assets/json/dt_{name}.json`
/// (same convention as localization overrides).
///
/// ```dart
/// LottieAsset.loading.toWidget(height: 100, repeat: true);
/// ```
enum LottieAsset {
  loading;

  String get path => 'assets/json/dt_$name.json';

  Widget toWidget({
    double? height,
    double? width,
    BoxFit? fit,
    bool repeat = false,
  }) =>
      Lottie.asset(
        path,
        package: MonorepoAssetResolver.instance.packageFor(path),
        height: height,
        width: width,
        fit: fit,
        repeat: repeat,
      );

  /// All paths — used by [MonorepoAssetResolver.init] at startup.
  static List<String> get allPaths => values.map((e) => e.path).toList();
}
