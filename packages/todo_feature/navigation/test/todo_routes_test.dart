import 'package:flutter_test/flutter_test.dart';
import 'package:todo_feature_navigation/src/todo_navigator_impl.dart';
import 'package:todo_feature_navigation/todo_feature_navigation.dart';

void main() {
  group('TodoRoutes', () {
    test('path patterns are stable', () {
      expect(TodoRoutes.pathList, '/todos');
      expect(TodoRoutes.pathDetail, '/todos/:id');
    });

    test('route names are stable', () {
      expect(TodoRoutes.nameList, 'todo_list');
      expect(TodoRoutes.nameDetail, 'todo_detail');
    });
  });

  group('TodoNavigatorImpl', () {
    final navigator = TodoNavigatorImpl();

    test('initialLocation points at the todo list', () {
      expect(navigator.initialLocation, '/todos');
    });

    test('matches recognises list and detail locations', () {
      expect(navigator.matches('/todos'), isTrue);
      expect(navigator.matches('/todos/5'), isTrue);
      expect(navigator.matches('/todos/123/something'), isTrue);
    });

    test('matches rejects unrelated locations', () {
      expect(navigator.matches('/profile'), isFalse);
      expect(navigator.matches('/'), isFalse);
      expect(navigator.matches(''), isFalse);
    });
  });
}
