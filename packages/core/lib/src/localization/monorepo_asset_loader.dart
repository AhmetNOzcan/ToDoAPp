import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class MonorepoAssetLoader extends AssetLoader {
  final String corePath;

  const MonorepoAssetLoader({required this.corePath});

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final fileName = '${locale.languageCode}-${locale.countryCode}.json';
    Map<String, dynamic> translations = {};

    // 1. Load base translations from the core package
    try {
      final coreString = await rootBundle.loadString('$corePath/$fileName');
      translations.addAll(json.decode(coreString) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('MonorepoAssetLoader: Core translations missing for $fileName');
    }

    // 2. Load app shell overrides if they exist
    try {
      final shellString = await rootBundle.loadString('$path/$fileName');
      final shellOverrides = json.decode(shellString) as Map<String, dynamic>;
      
      // Override core values with shell-specific values
      translations.addAll(shellOverrides);
      debugPrint('MonorepoAssetLoader: Successfully loaded overrides from $path');
    } catch (e) {
      // Silent catch since it's normal to not override logic
    }

    return translations;
  }
}
