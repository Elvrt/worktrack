import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:worktrack/homepage/home_screen.dart';
import 'package:worktrack/login.dart';
import 'dart:async';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fetch the available cameras before initializing the app
  final cameras = await availableCameras();
  final frontCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.front,
    orElse: () =>
        cameras.first, // Default to first camera if front is not available
  );

  runApp(FaceVerificationApp(camera: frontCamera));
}

class FaceVerificationApp extends StatelessWidget {
  final CameraDescription camera;
  final String address;

  FaceVerificationApp({required this.camera, required this.address});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FaceVerificationScreen(camera: camera),
    );
  }
}

class FaceVerificationScreen extends StatefulWidget {
  final CameraDescription camera;
  final String address;

  FaceVerificationScreen({required this.camera, required this.address});

  @override
  _FaceVerificationScreenState createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isLoading = false;
  String? resultMessage;
  late TextEditingController usernameController;

  Future<void> fetchProfile() async {
    final dio = Dio();
    final response = await dio.get(
      '${urlDomain}api/employee/show',
      options: Options(
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      ),
    );

    final data = response.data['data'];
    setState(() {
      usernameController.text = data['user']['username'] ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    // Initialize the controller and handle errors
    _initializeControllerFuture = _controller.initialize().catchError((error) {
      print("Camera initialization error: $error");
    });

    usernameController = TextEditingController();
    fetchProfile();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureAndSendImage() async {
    try {
      setState(() {
        isLoading = true;
        resultMessage = null;
      });

      await _initializeControllerFuture;

      // Capture the image
      final image = await _controller.takePicture();

      // Load the captured image
      final imageBytes = await File(image.path).readAsBytes();
      img.Image originalImage = img.decodeImage(imageBytes)!;

      // Rotate the image by -90 degrees (to fix the orientation)
      img.Image fixedImage = img.copyRotate(originalImage, angle: 360);

      // Save the rotated image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final fixedImagePath = '${tempDir.path}/fixed_captured_image.jpg';
      await File(fixedImagePath).writeAsBytes(img.encodeJpg(fixedImage));

      // Send the fixed image to the API
      final response = await _sendImageToAPI(File(fixedImagePath));

      // Validate the response with username
      final personName = response["person_name"];
      final isMatch =personName.trim().toLowerCase() == usernameController.text.trim().toLowerCase();

      setState(() {
        resultMessage = isMatch
            ? "Verification successful! Welcome, $personName."
            : "Verification failed! Try Again!";
        isLoading = false;
      });

      if (isMatch) {
        await Future.delayed(Duration(seconds: 4)); // Show success message briefly
        await clockIn(widget.address);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print("Error capturing and sending image: $e");
      setState(() {
        resultMessage = "Error capturing or sending image.";
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _sendImageToAPI(File imageFile) async {
    final uri = Uri.parse(
        "http://192.168.1.21:80/recognize/"); // Android Emulator address
    final request = http.MultipartRequest("POST", uri);

    // Add the image file to the request
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    // Send the request
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    // Decode the JSON response
    return jsonDecode(responseBody) as Map<String, dynamic>;
  }

  Future<void> clockIn(String address) async {
    try {
      setState(() {
        isLoading = true;
      });

      final dio = Dio();
      final response = await dio.post(
        '${urlDomain}api/absence/clockin',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
        data: {
          'address': address,
        },
      );

      if (response.statusCode == 200) {
        print("Clock-in successful");
      } else {
        setState(() {
          resultMessage = 'Failed to clock in: ${response.data['message']}';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Please look into the camera and hold still",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CameraPreview(_controller),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        resultMessage ?? "Press the button to verify your face",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: isLoading ? null : _captureAndSendImage,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                    ),
                    child: Image.asset(
                      'img/camera.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
