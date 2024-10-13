import 'package:flutter/material.dart';

void main() {
  runApp(ChangePasswordApp());
}

class ChangePasswordApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change Password',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangePasswordScreen(),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
               'img/logo.png',
                height: 100,
                width: 200,  
              ),
              const SizedBox(height: 5), 

                Align(
                alignment: Alignment.centerLeft, 
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left, 
                ),
              ),
              SizedBox(height: 0),
              Align(
                alignment: Alignment.centerLeft, // Agar subjudul juga rata kiri
                child: Text(
                  'Change your password to secure your account',
                  textAlign: TextAlign.left, // Ubah menjadi rata kiri jika diinginkan
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 40), // Ruang sebelum kolom formulir // Space between title and form fields
              
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Old Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 5),
              OldPasswordField(), 
              const SizedBox(height: 5),

             
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              NewPasswordField(), 
              const SizedBox(height: 10),

              
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Confirm New Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ConfirmPasswordField(), 
              const SizedBox(height: 30),

              
              ChangePasswordButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class OldPasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: '',
        hintText: 'Input your old password',
      ),
      obscureText: true,
    );
  }
}

class NewPasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: '',
        hintText: 'Input your new password',
      ),
      obscureText: true,
    );
  }
}

class ConfirmPasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: '',
        hintText: 'Confirm your new password',
      ),
      obscureText: true,
    );
  }
}

class ChangePasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 267,
      height: 50,
      child: TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully')),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 246, 214, 71), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
