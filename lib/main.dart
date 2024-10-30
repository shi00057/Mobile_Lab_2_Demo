import 'package:flutter/material.dart';
import 'app_database.dart';
import 'todo_item.dart';
import 'todo_item_dao.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final AppDatabase database;

  const MyHomePage({Key? key, required this.title, required this.database}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TodoItemDao _todoDao;
  List<TodoItem> _items = [];
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _todoDao = widget.database.todoItemDao;
    _loadItems();
  }

  void _loadItems() async {
    _items = await _todoDao.getAllTodos();
    setState(() {});
  }

  void _addItem() async {
    if (_inputController.text.isNotEmpty) {
      final newItem = TodoItem(description: _inputController.text);
      await _todoDao.insertTodoItem(newItem);
      _inputController.clear();
      _loadItems();
    }
  }

  void _deleteItem(TodoItem item) async {
    await _todoDao.deleteTodoItem(item);
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text("Add"),
                ),
                Flexible(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: "Enter a todo item",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return GestureDetector(
                    onLongPress: () => _deleteItem(item),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Item $index:"),
                        Text(item.description),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
