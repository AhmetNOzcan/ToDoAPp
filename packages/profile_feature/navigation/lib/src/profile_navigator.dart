import 'package:flutter/widgets.dart';

abstract class ProfileNavigator {
  void goToRoot(BuildContext context);
  void pushRoot(BuildContext context);
  bool matches(String location);
  String get initialLocation;
}
