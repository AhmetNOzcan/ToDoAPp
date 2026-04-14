import 'package:core/core.dart'; // Inherits easy localization config
import 'package:flutter/material.dart';

import 'app.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await MonorepoAssetResolver.instance.init();
  
  await initDependencies();
  runApp(
    MonorepoLocalizationProvider(
      child: TodoLiteApp(),
    ),
  );
}
