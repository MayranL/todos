import 'package:postgres/postgres.dart';
import 'package:todos_data_source/todos_data_source.dart';
import 'package:uuid/uuid.dart';


/// An in-memory implementation of the [TodosDataSource] interface.
class DatabaseTodosDataSource implements TodosDataSource {
  /// Connect the database-> Todo
  final conn = PostgreSQLConnection('localhost', 5432, 'postgres',
      username: 'postgres', password: 'postgres');

  Future<bool> isConnectionOpen() async {
    final connection = conn;

    if (connection.isClosed){
      await connection.open();
      return true;
    }
    return true;
  }


  @override
  Future<Todo> create(Todo todo) async {

    await isConnectionOpen();

    final uuid = const Uuid().v4();
    final id = uuid.toString(); // Obtient la représentation de chaîne de caractères de l'UUID

    final createdTodo = todo.copyWith(id: id);

    final results = await conn.query(
      'INSERT INTO newtable (title, description, iscompleted) '
          'VALUES (@title, @description, @iscompleted) RETURNING *',
      substitutionValues: {
        'title': createdTodo.title,
        'description': createdTodo.description,
        'iscompleted': createdTodo.isCompleted,
      },
    );
    Todo todo2 = Todo(title: results.single[0],description: results.single[1],id: results.single[2].toString(), isCompleted: results.single[3]);
    return todo2;
  }


  @override
  Future<List<Todo>> readAll() async {
    isConnectionOpen();

    final results = await conn.query('SELECT * FROM newtable');
    print("Le résultat");
    print(results);
    final todos = results.map((row) => row.toColumnMap()).toList();

    List<Todo> todosq = [
      Todo(id: '1', title: 'Todo 1', description: 'Description du Todo 1', isCompleted: false),
      Todo(id: '2', title: 'Todo 2', description: 'Description du Todo 2', isCompleted: true),
      Todo(id: '3', title: 'Todo 3', description: 'Description du Todo 3', isCompleted: false),
    ];

    print(todosq);
    return todosq;
  }

  @override
  Future<Todo?> read(String id) async {
    isConnectionOpen();

    final results = await conn.query(
      'SELECT * FROM newtable WHERE id = @id',
      substitutionValues: {'id': id},
    );

    final todo = results.isNotEmpty ? Todo.fromMap(results.single.toColumnMap()) : null;

    return todo;
  }

  @override
  Future<Todo> update(String id, Todo todo) async {
    isConnectionOpen();

    await conn.query(
      'UPDATE newtable SET title = @title, description = @description, iscompleted = @isCompleted '
          'WHERE id = @id',
      substitutionValues: {
        'id': id,
        'title': todo.title,
        'description': todo.description,
        'isCompleted': todo.isCompleted,
      },
    );

    return todo;
  }

  @override
  Future<void> delete(String id) async {
    isConnectionOpen();

    await conn.query(
      'DELETE FROM newtable WHERE id = @id',
      substitutionValues: {'id': id},
    );
  }

}