import 'package:dart_frog/dart_frog.dart';
import 'package:todos_data_source/todos_data_source.dart';

import '../../database/postgres.dart';


Future<Response> onRequest(RequestContext context) async {
  final connection = conn;

  final todo = Todo.fromJson(
    await context.request.json() as Map<String, dynamic>,
  );

  final results = await connection.query(
    'INSERT INTO newtable (title, description, isCompleted) '
        'VALUES (@title, @description, @isCompleted) RETURNING *',
    substitutionValues: {
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted,
    },
  );

  final insertedTodo = Todo.fromMap(results.single.toColumnMap());

  return Response.json(
    body: insertedTodo.toJson(),
  );
}