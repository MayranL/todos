library globals;

import 'package:postgres/postgres.dart';

String globalVar = "Educative";


final conn = PostgreSQLConnection('localhost', 5432, 'postgres',
    username: 'postgres', password: 'postgres');
