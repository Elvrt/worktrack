import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:worktrack/homepage/home_screen.dart';
import 'package:worktrack/login.dart';

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

class ClockInPage extends StatefulWidget {
  @override
  _ClockInPageState createState() => _ClockInPageState();
}

class _ClockInPageState extends State<ClockInPage> {
  String location = "Unknown";
  String coordinates = "";
  String projectTitle = "Loading...";
  String projectDescription = "Loading...";
  bool isLoading = false;

  // Fetch Goal Data
  Future<void> fetchGoalData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${urlDomain}api/absence/goal',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          projectTitle =
              data['data']['goal']['project_title'] ?? 'No Project Title Found';
          projectDescription = data['data']['goal']['project_description'] ??
              'No Project Description Found';
        });
      } else {
        setState(() {
          projectTitle = 'Error loading project title';
          projectDescription = 'Error loading project description';
        });
      }
    } catch (e) {
      setState(() {
        projectTitle = 'Failed to load project title';
        projectDescription = 'Failed to load description';
      });
    }
  }

  // Fetch Current Location
  Future<void> fetchLocationAndSendToAbsence() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          location = "Location services are disabled";
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          setState(() {
            location = "Permission denied";
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        coordinates = "${position.latitude}, ${position.longitude}";
      });

      // Reverse geocode coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      setState(() {
        location = "${place.locality}, ${place.country}";
      });

      // Send location to absence table
      final dio = Dio();
      final response = await dio.post(
        '${urlDomain}/api/absence/clockin',
        data: {
          'location': location,
          'coordinates': coordinates,
        },
      );

      if (response.statusCode == 200) {
        print('Location successfully sent: ${response.data}');
      } else {
        print('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching location or sending data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGoalData();
    fetchLocationAndSendToAbsence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 150,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            _buildLiveTimeAndDate(),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                enabled: false,
                decoration: InputDecoration(
                  hintText: location,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Goal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Project Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  projectTitle,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  softWrap: true,
                  overflow:
                      TextOverflow.visible,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Project Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  projectDescription,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  softWrap: true,
                  overflow:
                      TextOverflow.visible,
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
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        },
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Clock In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'inter'),
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
    return DateFormat('EEEE, MMM dd').format(dateTime);
  }

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
