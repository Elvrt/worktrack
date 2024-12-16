import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:worktrack/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:worktrack/faceRecog.dart';
import 'package:camera/camera.dart';
import 'dart:async';

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
  String projectTitle = "Loading...";
  String projectDescription = "Loading...";
  String locationDescription =
      " + Click to get Location"; // Initial text for location
  bool isLoading = false;

  // Fetch Goal Data
  Future<void> fetchGoalData() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${urlDomain}api/absence/goal', // Replace with your actual API endpoint
        options: Options(
          headers: {
            'Authorization':
                'Bearer $authToken', // Replace with your valid token
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

  // Request location permission
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      setState(() {
        locationDescription = 'Location permission denied.';
      });
    } else if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationDescription =
            'Location permission permanently denied. Please enable it in app settings.';
      });
    } else {
      // Permission granted, proceed with fetching location
      _getCurrentLocation();
    }
  }

  // Get current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || permission == LocationPermission.denied) {
      await _requestLocationPermission();
      return Future.error(
          'Location service is not enabled or permission denied');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      return Future.error('Failed to get location: $e');
    }
  }

  // Get address from coordinates
  Future<String> _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      return '${place.locality}, ${place.country}';
    } catch (e) {
      return 'Failed to get address: $e';
    }
  }

  // Navigate to Face Recognition Screen
  Future<void> navigateToFaceRecognition(
      Position position, String address) async {

    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () =>
          cameras.first,
    );

    final isVerified = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaceVerificationScreen(camera: frontCamera, address: address),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchGoalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
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
                  overflow: TextOverflow.visible,
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
                  overflow: TextOverflow.visible,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Location',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    Position position = await _getCurrentLocation();
                    String address = await _getAddressFromCoordinates(position);
                    setState(() {
                      locationDescription =
                          address; // Update location when clicked
                    });
                  } catch (e) {
                    setState(() {
                      locationDescription = 'Error getting location.';
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    locationDescription,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
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
                      : () async {
                          try {
                            Position position = await _getCurrentLocation();
                            String address =
                                await _getAddressFromCoordinates(position);
                            await navigateToFaceRecognition(position, address);
                          } catch (e) {
                            setState(() {
                              projectDescription = 'Error occurred: $e';
                            });
                          }
                        },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Clock In',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Build live time and date widget
  Widget _buildLiveTimeAndDate() {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();

        final now = snapshot.data!;
        final time = DateFormat('hh:mm a').format(now);
        final date = DateFormat('EEEE, dd MMM yyyy').format(now);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}
