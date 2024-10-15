import 'dart:async'; // Import for Stream and Timer
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'clock_in_page.dart'; // Import ClockInPage

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the AppBar
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
            SizedBox(height: kToolbarHeight), // Space for the AppBar height

            // Profile Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // Replace with profile image URL
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'BONIFASIUS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '1231231',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Live Time
            StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) {
                String formattedTime = _formatTime(DateTime.now());
                return Text(
                  formattedTime,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(height: 5),

            // Live Date
            StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) {
                String formattedDate = _formatDate(DateTime.now());
                return Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                );
              },
            ),
            const SizedBox(height: 15),

            // Clock In Button
            Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onTap: () {
                    // Navigate to ClockInPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClockInPage()),
                    );
                  },
                  child: Container(
                    width: 148, // Width of the button
                    height: 148, // Height of the button
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFFFD83A), // Custom yellow color for shade 300
                          Color(0xFFFDF0A1), // Custom yellow color for shade 100
                        ],
                        center: Alignment(0.0, 0.0), // Center of the gradient
                        radius: 1.0, // Radius of the gradient
                      ),
                      shape: BoxShape.circle, // Make it circular
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          offset: Offset(4, 4), // Position of the shadow
                          blurRadius: 8, // How much the shadow will be blurred
                          spreadRadius: 1, // How much the shadow will spread
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'img/clockin.png', // Path to the clockin image
                          width: 48, // Set the desired width of the image
                          height: 48, // Set the desired height of the image
                        ),
                        const SizedBox(height: 8), // Add space between image and text
                        const Text(
                          'CLOCK IN',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w300,
                          ),
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
                      // Implement Take Time Off function
                      _showMessage(context, 'Take Time Off berhasil');
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey,
                      child: const Text(
                        'Take Time Off',
                        style: TextStyle(fontSize: 8, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Location Information
            const Text(
              'Location: Unknown - Khalid',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Clock In / Debug iOS App / Clock Out
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionColumn(Icons.login, 'Clock In'),
                _buildActionColumn(Icons.flag, 'Debug iOS App'),
                _buildActionColumn(Icons.logout, 'Clock Out'),
              ],
            ),
            const SizedBox(height: 20),

            // Event Information
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Column(
                children: const [
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFD83A), // Custom yellow color for shade 300
              Color(0xFFFDF0A1), // Custom yellow color for shade 100
            ],
            begin: Alignment.topCenter, // Start of the gradient
            end: Alignment.bottomCenter, // End of the gradient
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: 1, // Mark active tab
          selectedItemColor: Colors.yellow, // Color for the selected item
          unselectedItemColor: Colors.grey, // Color for unselected items
          items: const [
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
      ),
    );
  }

  // Function to show SnackBar message
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Function to format time (hh:mm:ss)
  static String _formatTime(DateTime dateTime) {
    return "${_twoDigits(dateTime.hour)} : ${_twoDigits(dateTime.minute)}";
  }

  // Function to format date (day, month date)
  static String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM d').format(dateTime);
  }

  // Helper to ensure two digits for hours and minutes
  static String _twoDigits(int n) {
    return n >= 10 ? "$n" : "0$n";
  }

  // Helper to build action columns
  Column _buildActionColumn(IconData icon, String label) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return RadialGradient(
              colors: [
                Color(0xFFFFD83A), // Custom yellow color for shade 300
                Color(0xFFFDF0A1), // Custom yellow color for shade 100
              ],
              center: Alignment(0.0, 0.0), // Center of the gradient
              radius: 1.0, // Radius of the gradient
            ).createShader(bounds);
          },
          child: Icon(
            icon,
            size: 40,
            color: Colors.white, // Color is set to white so the gradient is visible
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
