import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
    _saveData();
    super.dispose();
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _firstNameController.text = _preferences.getString('firstName') ?? '';
      _lastNameController.text = _preferences.getString('lastName') ?? '';
      _phoneNumberController.text = _preferences.getString('phoneNumber') ?? '';
      _emailController.text = _preferences.getString('email') ?? '';
    });
  }

  void _saveData() {
    _preferences.setString('firstName', _firstNameController.text);
    _preferences.setString('lastName', _lastNameController.text);
    _preferences.setString('phoneNumber', _phoneNumberController.text);
    _preferences.setString('email', _emailController.text);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showAlertDialog('URL not supported on this device');
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        title: const Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Welcome Back ${_preferences.getString('login') ?? ''}'),
            const SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    _launchURL('tel:${_phoneNumberController.text}');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.message),
                  onPressed: () {
                    _launchURL('sms:${_phoneNumberController.text}');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () {
                    _launchURL('mailto:${_emailController.text}');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
