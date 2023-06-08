import 'package:dart_frog/dart_frog.dart';
import 'package:database_todos_data_source/database_todos_data_source.dart';
import 'package:todos_data_source/todos_data_source.dart';

final _dataSource = DatabaseTodosDataSource();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<TodosDataSource>((_) => _dataSource));
}