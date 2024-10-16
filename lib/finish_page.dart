import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class finishpage extends StatelessWidget {
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
                    // Navigate to ClockOutPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => finishpage()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 74,
                    backgroundColor: const Color.fromARGB(213, 210, 210, 210),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'img/clockin.png', // Path to the clockin image
                          width: 48, // Set the desired width of the image
                          height: 48, // Set the desired height of the image
                        ),
                        SizedBox(
                            height: 13), // Add space between image and text
                        Text(
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
            // Clock In / Debug iOS App / Clock Out
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.login, size: 40, color: Colors.yellow),
                    SizedBox(height: 5),
                    Text('Clock In', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.flag, size: 40, color: Colors.yellow),
                    SizedBox(height: 5),
                    Text('Debug iOS App', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.logout, size: 40, color: Colors.yellow),
                    SizedBox(height: 5),
                    Text('Clock Out', style: TextStyle(fontSize: 16)),
                  ],
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
        currentIndex: 1, // Mark active tab
        selectedItemColor: Colors.yellow, // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
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

  // Function to show SnackBar message
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Function to format time (hh:mm:ss)
  String _formatTime(DateTime dateTime) {
    return "${_twoDigits(dateTime.hour)} : ${_twoDigits(dateTime.minute)}";
  }

  // Function to format date (day, month date)
  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM d').format(dateTime);
  }

  // Helper to ensure two digits for hours and minutes
  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
