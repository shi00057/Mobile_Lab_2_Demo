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

  var items = <String>["Finish this Lab", "Finish this Quiz"];
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
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, rowNum){
                    return GestureDetector(
                      onLongPress: (){
                        setState(() {
                          items.removeAt(rowNum);
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(" Item ${rowNum}:"),
                          Text("${items[rowNum]}")
                        ],
                      ),
                    );
                  }),
            )

          ],
        ),
      ),

    );
  }
}