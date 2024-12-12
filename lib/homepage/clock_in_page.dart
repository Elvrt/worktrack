import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:worktrack/homepage/home_screen.dart';
import 'package:worktrack/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  // Clock In with location and address
  Future<void> clockIn() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Get user's current location
      Position position = await _getCurrentLocation();

      // Get the address of the current location
      String address = await _getAddressFromCoordinates(position);

      // Update project description with location info
      setState(() {
        projectDescription = 'Location: $address';
        locationDescription = address; // Update location description
      });

      final dio = Dio();
      final response = await dio.post(
        '${urlDomain}api/absence/clockin', // Ensure this matches the correct endpoint
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': address, // Include the address in the request
        },
      );

      if (response.statusCode == 200) {
        // Successfully clocked in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Handle failure scenario
        setState(() {
          projectDescription =
              'Failed to clock in: ${response.data['message']}';
        });
      }
    } catch (e) {
      // Handle any errors that occur during the clock-in process
      setState(() {
        projectDescription = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                  Position position = await _getCurrentLocation();
                  String address = await _getAddressFromCoordinates(position);
                  setState(() {
                    locationDescription =
                        address; // Update location when clicked
                  });
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
                  onPressed: isLoading ? null : clockIn,
                  child: Text(
                    isLoading ? 'Clocking In...' : 'Clock In',
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
