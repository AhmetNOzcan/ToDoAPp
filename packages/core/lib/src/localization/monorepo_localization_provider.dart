import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'monorepo_asset_loader.dart';

class MonorepoLocalizationProvider extends StatelessWidget {
  final Widget child;

  const MonorepoLocalizationProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations',
      assetLoader: const MonorepoAssetLoader(corePath: 'packages/core/assets/translations'),
      fallbackLocale: const Locale('en', 'US'),
      child: child,
    );
  }
}
