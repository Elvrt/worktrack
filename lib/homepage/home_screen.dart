import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worktrack/homepage/clock_in_page.dart'; 
import 'package:worktrack/navbar.dart';
import 'package:worktrack/timeOffPage/timeOffForm.dart';

void main() {
  runApp(HomeScreenPage());
}

class HomeScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clock In App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend the body behind the AppBar
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  // Main body of the screen
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: kToolbarHeight), // Space for the AppBar height
          
          // Profile Section
          _buildProfileSection(),
          
          const SizedBox(height: 10),
          
          // Live Time
          _buildLiveTime(),
          
          const SizedBox(height: 5),
          
          // Live Date
          _buildLiveDate(),
          
          const SizedBox(height: 15),
          
          // Clock In Button with Time Off Button
          _buildClockInButton(context),
          
          const SizedBox(height: 10),
          
          // Location Information
          const Text(
            'Location: Unknown - Khalid',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons (Clock In, Debug iOS, Clock Out)
          _buildActionButtons(),
          
          const SizedBox(height: 20),
          
          // Event Information
          _buildEventInfo(),
        ],
      ),
    );
  }

  // Profile Section
  Widget _buildProfileSection() {
    return Row(
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
    );
  }

  // Live Time Stream
  Widget _buildLiveTime() {
    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1)),
      builder: (context, snapshot) {
        String formattedTime = _formatTime(DateTime.now());
        return Text(
          formattedTime,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        );
      },
    );
  }

  // Live Date Stream
  Widget _buildLiveDate() {
    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1)),
      builder: (context, snapshot) {
        String formattedDate = _formatDate(DateTime.now());
        return Text(
          formattedDate,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        );
      },
    );
  }

  // Clock In Button with Time Off Button
  Widget _buildClockInButton(BuildContext context) {
    return Stack(
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
            width: 148, 
            height: 148,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0xFFFFD83A),
                  Color(0xFFFDF0A1),
                ],
                center: Alignment(0.0, 0.0), 
                radius: 1.0,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(4, 4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'img/clockin.png',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(height: 8),
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
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => timeOff()),
              );
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
    );
  }

  // Action Buttons (Clock In, Debug iOS, Clock Out)
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionColumn(Icons.login, 'Clock In'),
        _buildActionColumn(Icons.flag, 'Debug iOS App'),
        _buildActionColumn(Icons.logout, 'Clock Out'),
      ],
    );
  }

  // Event Info Widget
  Widget _buildEventInfo() {
    return Container(
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
    );
  }

  // Helper to build action columns
  Column _buildActionColumn(IconData icon, String label) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return RadialGradient(
              colors: [
                Color(0xFFFFD83A),
                Color(0xFFFDF0A1),
              ],
              center: Alignment(0.0, 0.0),
              radius: 1.0,
            ).createShader(bounds);
          },
          child: Icon(
            icon,
            size: 40,
            color: Colors.white, 
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
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
}
