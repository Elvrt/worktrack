import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:worktrack/homepage/home_screen.dart'; // Pastikan HomeScreenPage diimport

// URL konfigurasi
String urlDomain = "http://192.168.1.15:8000/";
String urlLogin = "${urlDomain}api/login";

// Global variable for the token
String? authToken;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  bool _rememberMe = false;

  Future<void> login() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        urlLogin,
        data: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        authToken = data['access_token']; // Simpan token ke global variable

        // Navigasi ke HomeScreenPage setelah login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreenPage(),
          ),
        );
      } else {
        setState(() {
          errorMessage = "Login failed: Incorrect credentials.";
        });
      }
    } on DioError catch (e) {
      setState(() {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.sendTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          errorMessage = "Connection timeout. Please try again.";
        } else if (e.type == DioErrorType.connectionError) {
          errorMessage = "Could not connect to server. Check your network.";
        } else if (e.response != null && e.response?.statusCode == 401) {
          errorMessage = "Unauthorized: Incorrect username or password.";
        } else {
          errorMessage = "An unexpected error occurred.";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'img/logo.png',
                  height: 120,
                ),
                SizedBox(height: 10),

                // Login Title
                Text(
                  'Login',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),

                // Subtitle
                Text(
                  'Login to continue using the app',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 30),

                // Username TextField
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Error Message
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),

                // Forgot Password & Remember me Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        Text('Remember me'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
