import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  var imageSource = 'Images/question-mark.png';

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }
  @override
  void dispose() {

    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _checkPassword() {
    String password = _passwordController.text;
    setState(() {
      if (password == 'QWERTY123') {
        imageSource = 'Images/idea.png';
      } else {
        imageSource = 'Images/stop.png';
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          TextField(
            controller: _loginController,
            decoration: const InputDecoration(
              hintText: 'Login',
              border: OutlineInputBorder(),
            ),
          ),


          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
            ),

            ),
            ElevatedButton(

                onPressed: _checkPassword,

              child: const Text('Login'),

            ),
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
            ),

          ],
        ),
      ),
    );
  }
}
