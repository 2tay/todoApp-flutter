import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/model/user.dart';
import 'login.dart'; 
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

Future<void> postData(User data) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data.toJson()),
  );

  if (response.statusCode == 201) {
    print('Data posted successfully');
  } else {
    throw Exception('Failed to post Data');
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
              controller: _fullnameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
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
                User newUser = User(username: _usernameController.text, fullname: _fullnameController.text, password: _passwordController.text);
                try {
                  await postData(newUser);
                  print('Data posted successfully');
                  
                  // Clear text fields
                  _usernameController.clear();
                  _fullnameController.clear();
                  _passwordController.clear();

                  // Navigate to login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );

                } catch (e) {
                  print('Error: $e');
                }
              },
              child: Text('Register'),
            ),

            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Already have an account? Login here',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
