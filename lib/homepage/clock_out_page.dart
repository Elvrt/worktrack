import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'finish_page.dart';


void main() {
  runApp(ClockOutApp());
}

class ClockOutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clock In App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClockOutPage(),
    );
  }
}
class ClockOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
       
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(DateTime.now()),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatDate(DateTime.now()),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Clock Out',
                style: TextStyle(color: Colors.black, fontSize: 24,letterSpacing: 4,fontFamily: 'inter',fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Title of Your Activity Today',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Describe Your Activity Today',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Take a Screenshot of Your Activity (jpg,jpeg,png)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 225, 203, 11),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Navigate to HomePageAfterClockIn
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => finishpage()),
                    );
                  },
                child: Text(
                  'Clock Out',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM d').format(dateTime);
  }
}