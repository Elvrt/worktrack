import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:worktrack/faceRecog.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class ClockOutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clock Out App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            Colors.white, // Set default background color to white
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Set app bar background to white
          elevation: 0,
        ),
      ),
      home: ClockOutPage(),
    );
  }
}

class ClockOutPage extends StatefulWidget {
  @override
  _ClockOutPageState createState() => _ClockOutPageState();
}

class _ClockOutPageState extends State<ClockOutPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;
  CameraDescription? frontCamera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      setState(() {
        frontCamera = camera;
      });
    } catch (e) {
      print('Error initializing cameras: $e');
    }
  }

  void _navigateToFaceRecog() {
    if (frontCamera != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FaceVerificationScreen(
            camera: frontCamera!,
            titleController: _titleController,
            descriptionController: _descriptionController,
          ),
        ),
      );
    } else {
      // Tampilkan pesan error jika kamera tidak tersedia
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera not available')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Ensure the Scaffold background is white
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              _buildLiveTimeAndDate(),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Clock Out',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Title of Your Activity Today',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter activity title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Describe Your Activity Today',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter activity description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 239, 218, 26),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: isLoading ? null : _navigateToFaceRecog,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Clock Out',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);
  String _formatDate(DateTime dateTime) =>
      DateFormat('EEEE, MMM dd').format(dateTime);

  Widget _buildLiveTimeAndDate() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_formatTime(now),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 1),
            Text(_formatDate(now), style: const TextStyle(fontSize: 12)),
          ],
        );
      },
    );
  }
}
