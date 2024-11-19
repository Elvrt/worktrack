import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worktrack/homepage/home_page_after_clock_in.dart';


void main() {
  runApp(ClockInApp());
}

class ClockInApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clock In App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClockInPage(),
    );
  }
}

class ClockInPage extends StatelessWidget {
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
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(DateTime.now()),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                _formatDate(DateTime.now()),
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 17),
              Center(
                child: Text(
                  'Clock In',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    letterSpacing: 4,
                    fontFamily: 'inter',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location: Unknown - Khalid',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Goal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Debug ios app',
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 218, 26),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePageAfterClockIn()),
                    );
                  },
                  child: Text(
                    'Clock In',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, fontFamily: 'inter'),
                  ),
                ),
              ),
            ],
          ),
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

