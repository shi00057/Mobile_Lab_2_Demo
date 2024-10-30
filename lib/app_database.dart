import 'package:floor/floor.dart';
import 'dart:async';
import 'todo_item_dao.dart';
import 'todo_item.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [TodoItem])
abstract class AppDatabase extends FloorDatabase {
  TodoItemDao get todoItemDao;
}
