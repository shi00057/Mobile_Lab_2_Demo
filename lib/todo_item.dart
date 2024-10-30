import 'package:floor/floor.dart';

@entity
class TodoItem {
  @primaryKey
  final int? id;
  final String description;

  TodoItem({this.id, required this.description});
}
