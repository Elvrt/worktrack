import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:worktrack/homepage/clock_in_page.dart';
import 'package:worktrack/homepage/clock_out_page.dart';
import 'package:worktrack/navbar.dart';
import 'package:worktrack/timeOffPage/timeOffForm.dart';
import 'package:worktrack/login.dart';

class ScreenfinishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finish Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FinishPage(),
    );
  }
}

class FinishPage extends StatefulWidget {
  @override
  _FinishPage createState() => _FinishPage();
}

class _FinishPage extends State<FinishPage> {
  String employeeName = "Loading...";
  String employeeNumber = "Loading...";
  String profileImageUrl = "";
  List<Map<String, String>> events = [];
  String eventTime = "Loading...";
  String eventInformation = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchProfile();
    fetchEventData();
  }

  Future<void> fetchProfile() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${urlDomain}api/home',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          employeeName = data['employee']['name'] ?? 'Unknown';
          employeeNumber = data['employee']['employee_number'] ?? 'N/A';
          profileImageUrl = data['employee']['profile'] ?? '';
        });
      } else {
        setState(() {
          employeeName = "Failed to load";
          employeeNumber = "N/A";
          profileImageUrl = "";
        });
      }
    } catch (e) {
      setState(() {
        employeeName = "Error loading profile";
        employeeNumber = "N/A";
        profileImageUrl = "";
      });
    }
  }

  Future<void> fetchEventData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${urlDomain}api/home',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          events.clear(); // Bersihkan daftar sebelumnya
          if (data['event'] != null && data['event'].isNotEmpty) {
            for (var event in data['event']) {
              events.add({
                'event_date': event['event_date'] ?? 'Unknown date',
                'event_time': event['event_time'] ?? 'Unknown time',
                'information': event['information'] ?? 'No details',
              });
            }
          } else {
            events.add({
              'event_date': 'No upcoming events',
              'event_time': '',
              'information': '',
            });
          }
        });
      } else {
        setState(() {
          events.add({
            'event_date': 'Failed to load',
            'event_time': '',
            'information': '',
          });
        });
      }
    } catch (e) {
      setState(() {
        events.add({
          'event_date': 'Error loading event',
          'event_time': '',
          'information': '',
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: kToolbarHeight),
            _buildProfileSection(),
            SizedBox(height: 10),
            _buildLiveTime(),
            SizedBox(height: 5),
            _buildLiveDate(),
            SizedBox(height: 15),
            _buildClockInButton(context),
            SizedBox(height: 10),
            Text(
              'Location: Unknown - Khalid',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            _buildActionButtons(),
            SizedBox(height: 20),
            _buildEventInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    // Ensure name is limited to 10 characters, and add '...' if truncated
    String displayName = employeeName.length > 10
        ? '${employeeName.substring(0, 10)}...'
        : employeeName;

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: profileImageUrl.isNotEmpty
              ? NetworkImage(profileImageUrl)
              : AssetImage('img/default_profile.png')
                  as ImageProvider, // Fallback image
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              employeeNumber,
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

 Widget _buildClockInButton(BuildContext context, {bool isEnabled = true}) {
  return Stack(
    alignment: Alignment.center,
    children: [
      // The main button container
      InkWell(
        onTap: isEnabled
            ? () {
                // No action or navigation when clicked
                // You can leave this empty to do nothing
              }
            : null, // Do nothing if not enabled
        child: Container(
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0xFFE0E0E0), // Light gray color (center)
                  Color(0xFFB0B0B0), // Darker gray color (outer)
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
                  'CLOCK OUT',
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
    return Column(
      children: [
        // First Row with Icons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIconColumn(Icons.history, '08:23'),
            _buildIconColumn(Icons.local_fire_department, 'Debug iOS'),
            _buildIconColumn(Icons.update, '17:20'),
          ],
        ),

        SizedBox(height: 10), // Vertical spacing between rows

        // Second Row with Text Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTextColumn('Clock In'),
            _buildTextColumn('Goal'),
            _buildTextColumn('Clock Out'),
          ],
        ),
      ],
    );
  }

// Helper method to build columns for icons and text
  Widget _buildIconColumn(IconData icon, String text) {
    return SizedBox(
      width: 100, // Fixed width for each column
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.yellow), // Icon with color
          SizedBox(height: 5), // Space between icon and text
          Text(text, style: TextStyle(fontSize: 16)), // Text below icon
        ],
      ),
    );
  }

// Helper method to build columns for text labels
  Widget _buildTextColumn(String label) {
    return SizedBox(
      width: 100, // Fixed width for each column
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ), // Bold text labels
        ],
      ),
    );
  }

  // Event Info Widget
  Widget _buildEventInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Events',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          events.isNotEmpty
              ? ListView.separated(
                  shrinkWrap:
                      true, // Agar ListView tidak memenuhi seluruh layar
                  physics: NeverScrollableScrollPhysics(), // Non-scrollable
                  itemCount: events.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[400],
                    thickness: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            event['event_date'] ?? '',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 80,
                          child: Text(
                            event['event_time'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 4,
                          child: Text(
                            event['information'] ?? '',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    );
                  },
                )
              : const Text(
                  'No events available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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
