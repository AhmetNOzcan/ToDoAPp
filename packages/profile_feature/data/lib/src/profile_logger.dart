import 'package:core/core.dart';

@LazySingleton(as: Logger)
@Named("ProfileLogger")
class ProfileLogger implements Logger {
  @override
  void log() {
    print("Hello profile logger");
  }
}
