import 'package:core/core.dart';

@LazySingleton(as: Logger)
@Named("TodoLogger")
class TodoLogger implements Logger {
  @override
  void log() {
    print("Hello todo logger");
  }
}
