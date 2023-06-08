// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:database_todos_data_source/database_todos_data_source.dart';

void main() {
  group('DatabaseTodosDataSource', () {
    test('can be instantiated', () {
      expect(DatabaseTodosDataSource(), isNotNull);
    });
  });
}
