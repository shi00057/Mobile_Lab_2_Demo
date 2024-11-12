import 'package:flutter/material.dart';
import 'app_database.dart'; // import your database class
import 'todo_item.dart';   // import your item model
import 'todo_item_dao.dart'; // import your DAO interface

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

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

  const MyHomePage({super.key, required this.title, required this.database});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TodoItemDao _todoDao;
  List<TodoItem> _items = [];
  final TextEditingController _input = TextEditingController();

  @override
  void initState() {
    super.initState();
    _todoDao = widget.database.todoItemDao;
    _loadItems();
  }

  // Loads items from the database
  void _loadItems() async {
    _items = await _todoDao.getAllTodos();
    setState(() {});
  }

  // Adds a new item to the list and database
  void _addItem() async {
    if (_input.text.isNotEmpty) {
      final newItem = TodoItem(description: _input.text);
      await _todoDao.insertTodoItem(newItem); // Save to database
      _input.clear();
      _loadItems(); // Reload items from database
    }
  }

  // Deletes an item from the list and database
  void _deleteItem(TodoItem item) async {
    await _todoDao.deleteTodoItem(item); // Delete from database
    _loadItems(); // Reload items from database
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
                    controller: _input,
                    decoration: InputDecoration(
                      hintText: "Enter a todo item",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _items.isEmpty
                  ? Center(
                child: Text(
                  "There are no items in the list",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, rowNum) {
                  final item = _items[rowNum];
                  return GestureDetector(
                    onLongPress: () {
                      // Show a dialog to confirm deletion
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete Item"),
                            content: Text("Are you sure you want to delete this item?"),
                            actions: [
                              // If "No" is pressed, close the dialog without deleting the item
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text("No"),
                              ),
                              // If "Yes" is pressed, delete the item and close the dialog
                              TextButton(
                                onPressed: () {
                                  _deleteItem(item); // Delete from list and database
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Item $rowNum:"),
                            Text(item.description)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}