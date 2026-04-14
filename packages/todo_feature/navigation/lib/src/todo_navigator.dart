import 'package:flutter/widgets.dart';

abstract class TodoNavigator {
  void goToList(BuildContext context);
  void pushList(BuildContext context);
  void goToDetail(BuildContext context, {required int id});
  void pushDetail(BuildContext context, {required int id});
  bool matches(String location);
  String get initialLocation;
}
