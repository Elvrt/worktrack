import 'package:flutter/material.dart';

class KaryawanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karyawan'),
      ),
      body: Center(
        child: Text(
          'Selamat datang di halaman Karyawan!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
