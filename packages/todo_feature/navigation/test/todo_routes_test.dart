import 'package:flutter_test/flutter_test.dart';
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

    test('locationList builds the list URL', () {
      expect(TodoRoutes.locationList(), '/todos');
    });

    test('locationDetail builds the URL GoRoute will match', () {
      expect(TodoRoutes.locationDetail(42), '/todos/42');
      expect(TodoRoutes.locationDetail(0), '/todos/0');
    });

    test('matches recognises list and detail locations', () {
      expect(TodoRoutes.matches('/todos'), isTrue);
      expect(TodoRoutes.matches('/todos/5'), isTrue);
      expect(TodoRoutes.matches('/todos/123/something'), isTrue);
    });

    test('matches rejects unrelated locations', () {
      expect(TodoRoutes.matches('/profile'), isFalse);
      expect(TodoRoutes.matches('/'), isFalse);
      expect(TodoRoutes.matches(''), isFalse);
    });
  });
}
