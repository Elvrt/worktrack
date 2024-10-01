import 'dart:async'; // Import untuk Stream dan Timer
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk DateFormat

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Ganti dengan URL gambar profil
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BONIFASIUS',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '1231231',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            // Live Time
            StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) {
                String formattedTime = _formatTime(DateTime.now());
                return Text(
                  formattedTime,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                );
              },
            ),
            SizedBox(height: 5),
            // Live Date
            StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) {
                String formattedDate = _formatDate(DateTime.now());
                return Text(
                  formattedDate,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                );
              },
            ),
            SizedBox(height: 15),
            // Clock In Button
            Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Implementasi fungsi clock in
                    _showMessage(context, 'Clock In berhasil');
                  },
                  child: CircleAvatar(
                    radius: 74,
                    backgroundColor: Colors.yellow,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.face, size: 48),
                        Text(
                          'CLOCK IN',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      // Implementasi fungsi Take Time Off
                      _showMessage(context, 'Take Time Off berhasil');
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey,
                      child: Text(
                        'Take Time Off',
                        style: TextStyle(fontSize: 8, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Location Information
            Text(
              'Location: Unknown - Khalid',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            // Clock In / Debug iOS App / Clock Out Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    // Implementasi fungsi Clock In
                    _showMessage(context, 'Clock In ditekan');
                  },
                  child: Column(
                    children: [
                      Icon(Icons.login, size: 40, color: Colors.yellow),
                      SizedBox(height: 5),
                      Text('Clock In', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Implementasi fungsi Debug iOS App
                    _showMessage(context, 'Debug iOS App ditekan');
                  },
                  child: Column(
                    children: [
                      Icon(Icons.flag, size: 40, color: Colors.yellow),
                      SizedBox(height: 5),
                      Text('Debug iOS App', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Implementasi fungsi Clock Out
                    _showMessage(context, 'Clock Out ditekan');
                  },
                  child: Column(
                    children: [
                      Icon(Icons.logout, size: 40, color: Colors.yellow),
                      SizedBox(height: 5),
                      Text('Clock Out', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Event Information
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  Text(
                    'Event',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('14 Feb 2024', style: TextStyle(fontSize: 16)),
                      Text('13:00', style: TextStyle(fontSize: 16)),
                      Text('Meeting with HRD', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Untuk menandai tab yang aktif
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan pesan SnackBar
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Fungsi untuk format waktu (hh:mm:ss)
  String _formatTime(DateTime dateTime) {
    return "${_twoDigits(dateTime.hour)} : ${_twoDigits(dateTime.minute)}";
  }

  // Fungsi untuk format tanggal (hari, bulan tanggal)
  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM d').format(dateTime);
  }

  // Helper untuk memastikan dua digit pada jam dan menit
  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
