import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/profile': (context) => const ProfilePage(),
      },
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
  late SharedPreferences _preferences;
  var imageSource = 'Images/question-mark.png';

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    _initPreferences();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Initialize SharedPreferences
  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _loadSavedCredentials();
  }

  // Load saved login and password from SharedPreferences
  void _loadSavedCredentials() {
    setState(() {
      _loginController.text = _preferences.getString('login') ?? '';
      _passwordController.text = _preferences.getString('password') ?? '';

      // Show Snackbar with Undo button
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login details loaded'),
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Clear TextFields but keep SharedPreferences unchanged
              setState(() {
                _loginController.clear();
                _passwordController.clear();
              });
            },
          ),
        ),
      );
    });
  }

  // Save login and password to SharedPreferences
  void _saveCredentials(String login, String password) {
    _preferences.setString('login', login);
    _preferences.setString('password', password);
  }

  // Check the entered password and update UI based on result
  void _checkPassword() {
    String password = _passwordController.text;
    String login = _loginController.text;
    setState(() {
      if (password == '123456' && login == 'Kai') {
        imageSource = 'Images/idea.png';
        _showSnackbar('Login successful!');
        _showSaveDialog(); // Call to show confirmation dialog for saving credentials
      } else {
        imageSource = 'Images/stop.png';
        _showSnackbar('Incorrect password, try again.');
      }
    });
  }

  // Show Snackbar message to provide feedback
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  // Display a dialog to confirm if the user wants to save credentials
  void _showSaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Credentials?'),
          content: const Text('Do you want to save your login credentials?'),
          actions: <Widget>[
            // Save credentials if user selects "Yes"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveCredentials(_loginController.text, _passwordController.text);
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('Yes'),
            ),
            // Completely remove saved credentials if user selects "No"
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Clear TextFields
                _loginController.clear();
                _passwordController.clear();
                // Remove credentials from SharedPreferences
                _preferences.remove('login');
                _preferences.remove('password');
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
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
            // Login TextField
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
                hintText: 'Login',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Password TextField
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: false,
            ),
            const SizedBox(height: 20),
            // Login Button
            ElevatedButton(
              onPressed: _checkPassword,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            // Display Image based on login result
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _initPreferences();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Initialize SharedPreferences
  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _loadSavedData();
  }

  // Load saved data from SharedPreferences
  void _loadSavedData() {
    setState(() {
      _firstNameController.text = _preferences.getString('firstName') ?? '';
      _lastNameController.text = _preferences.getString('lastName') ?? '';
      _phoneNumberController.text = _preferences.getString('phoneNumber') ?? '';
      _emailController.text = _preferences.getString('email') ?? '';
    });
  }

  // Save data to SharedPreferences
  void _saveData() {
    _preferences.setString('firstName', _firstNameController.text);
    _preferences.setString('lastName', _lastNameController.text);
    _preferences.setString('phoneNumber', _phoneNumberController.text);
    _preferences.setString('email', _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome Back, ${_preferences.getString('login') ?? ''}'),
            const SizedBox(height: 20),
            // First Name TextField
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                hintText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Last Name TextField
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                hintText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Phone Number TextField with buttons
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () async {
                    final phoneNumber = _phoneNumberController.text;
                    final url = 'tel:$phoneNumber';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      _showAlertDialog('This device does not support phone calls.');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.message),
                  onPressed: () async {
                    final phoneNumber = _phoneNumberController.text;
                    final url = 'sms:$phoneNumber';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      _showAlertDialog('This device does not support SMS.');
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Email Address TextField with button
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () async {
                    final email = _emailController.text;
                    final url = 'mailto:$email';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      _showAlertDialog('This device does not support sending emails.');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show alert dialog
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unsupported Feature'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}