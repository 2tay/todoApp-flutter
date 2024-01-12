import 'dart:convert';
import 'package:flutter/material.dart';
import 'home.dart'; // Import your home.dart file
import 'register.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<List<Map<String, dynamic>>> readUserData() async {
    final response =
        await http.get(Uri.parse('http://localhost:8000/users'));

    if (response.statusCode == 200) {
      // Parse the response body
      final List<dynamic> data = json.decode(response.body);

      // Convert data to List<Map<String, dynamic>>
      List<Map<String, dynamic>> userData =
          List<Map<String, dynamic>>.from(data);

      return userData;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load user data');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                // Read user data from the API
                List<Map<String, dynamic>> userData = await readUserData();

                // Check if the entered username and password match any user
                bool isValidUser = userData.any((user) =>
                    user['username'] == _usernameController.text &&
                    user['password'] == _passwordController.text);

                if (isValidUser) {
                  // Navigate to the home screen if the user is valid
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                } else {
                  // Show a snackbar for invalid login
                  _showSnackBar('Invalid username or password');
                }

                // Clear textfields after the submit
                _usernameController.clear();
                _passwordController.clear();

              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                'Don\'t have an account? Register here',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
