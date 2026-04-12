import 'package:flutter/material.dart';
import 'package:core/core.dart'; // Inherits easy_localization context

import 'app.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await MonorepoAssetResolver.instance.init();

  await initDependencies();

  runApp(MonorepoLocalizationProvider(child: TodoProApp()));
}
