import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fetch the available cameras before initializing the app
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(FaceVerificationApp(camera: firstCamera));
}

class FaceVerificationApp extends StatelessWidget {
  final CameraDescription camera;

  FaceVerificationApp({required this.camera});

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

  FaceVerificationScreen({required this.camera});

  @override
  _FaceVerificationScreenState createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    // Initialize the controller and handle errors
    _initializeControllerFuture = _controller.initialize().catchError((error) {
      // Handle the error here (e.g., show an error message)
      print("Camera initialization error: $error");
      // You might want to navigate back or show a message to the user
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
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
            Navigator.of(context).pop(); // Go back to the previous screen
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
            // Display the camera preview
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

                // Camera preview
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
                Text(
                  "Verifying your face ...",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),

                // Image Button (replaced the camera icon with an image)
                GestureDetector(
                  onTap: () async {
                    try {
                      await _initializeControllerFuture;
                      // Capture image when image button is pressed
                      final image = await _controller.takePicture();
                      // Handle the captured image for face verification
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10), // Space between the image and the border
                    decoration: BoxDecoration(
                      color: Colors.yellow[600], // Yellow background color
                      shape: BoxShape.circle, // Circular shape
                      border: Border.all( // White border around the button
                        color: Colors.white,
                        width: 5,
                      ),
                    ),
                    child: Image.asset(
                      'img/camera.png', // Ensure this path is correct
                      height: 40, // Adjust the size of the camera icon
                      width: 40,
                    ),
                  ),
                ),
              ],
            );
          } else {
            // If the camera is still loading, show a loading spinner
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}