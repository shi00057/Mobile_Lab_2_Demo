import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var items = <String>[];
  TextEditingController _input = TextEditingController();


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

            Row(children: [
              ElevatedButton(onPressed: (){
                setState(() {
                  items.add(_input.value.text);
                  _input.text = "";
                });
              }, child: Text("Add"),),

              Flexible(child: TextField(
                controller: _input,
                decoration: InputDecoration(hintText: "Enter a search term"
                ,border: OutlineInputBorder(),),
              )),
            ],),

            Expanded(
              child: items.isEmpty
                  ? Center(
                child: Text(
                  "There are no items in the list.",gi
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, rowNum) {
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
                                  setState(() {
                                    items.removeAt(rowNum); // Delete the item from the list
                                  });
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
                            Text("${items[rowNum]}")
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