import 'package:easy_localization/easy_localization.dart';

extension TranslationExtension on String {
  /// Converts the string key into the localized text based on current locale.
  /// This wrapper decouples feature packages from `easy_localization`.
  String get localize => this.tr();
  
  /// Translates with arguments
  String localizeWithArgs(List<String> args) => this.tr(args: args);
}
