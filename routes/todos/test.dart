import 'package:dart_frog/dart_frog.dart';
import 'package:todos_data_source/todos_data_source.dart';

import '../../database/postgres.dart';

Future<Response> onRequest(RequestContext context) async {
    final connection = conn;

    if (connection.isClosed){
        await connection.open();
    }

    final results = await connection.query('SELECT * FROM newtable');
    final todos = results.map((row) {
        final map = row.toColumnMap();
        return {
            'id': map['id'],
            'title': map['title'],
            'description': map['description'],
            'isCompleted': map['isCompleted'],
        };
    }).toList();

    return Response.json(body: todos);
}
