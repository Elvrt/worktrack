  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:worktrack/homepage/finish_page.dart';


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
     @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight:150, // Sesuaikan tinggi AppBar
      automaticallyImplyLeading: false, // Nonaktifkan back button default
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Atau sesuaikan dengan navigasi Anda
            },
          ),
          _buildLiveTimeAndDate(),
        ],
      ),
    ),
        body: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Clock Out',
                  style: TextStyle(color: Colors.black, fontSize: 24,letterSpacing: 4,fontFamily: 'inter',fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              Text(
                ' Title of Your Activity Today',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                ' Describe Your Activity Today',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                ' Take a Screenshot of Your Activity (jpg,jpeg,png)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 218, 26),
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
    return DateFormat('HH:mm').format(dateTime); // Format jam:menit
  }

  // Format tanggal
  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMM dd').format(dateTime); // Contoh: Wednesday, Feb 11
  }

 // model tanggal dan waktu
  Widget _buildLiveTimeAndDate() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(now),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 1),
            Text(
              _formatDate(now),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
          ],
        );
      },
    );
  }
  }