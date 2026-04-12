// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'monorepo_asset_resolver.dart';

/// Type-safe references to SVG icon assets.
///
/// Convention: `assets/icon/ic_{name}.svg`
///
/// Base assets live in `packages/core/assets/icon/`.
/// Override: place a file at `apps/{shell}/assets/icon/ic_{name}.svg`
/// (same convention as localization overrides).
///
/// ```dart
/// SvgAsset.settings.toWidget(height: 24, color: Colors.white);
/// ```
enum SvgAsset {
  settings,
  back,
  add,
  lock;

  String get path => 'assets/icon/ic_$name.svg';

  SvgPicture toWidget({
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
  }) =>
      SvgPicture.asset(
        path,
        package: MonorepoAssetResolver.instance.packageFor(path),
        height: height,
        width: width,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        fit: fit ?? BoxFit.contain,
      );

  /// All paths — used by [MonorepoAssetResolver.init] at startup.
  static List<String> get allPaths => values.map((e) => e.path).toList();
}
