import 'package:flutter/material.dart';

void main() => runApp(FaceVerificationApp());

class FaceVerificationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FaceVerificationScreen(),
    );
  }
}

class FaceVerificationScreen extends StatelessWidget {
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
            // Back button action
          },
        ),
      ),
      body: Center(
        // This ensures the content is centered
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instruction text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Please look into camera and hold still",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),

            // Face scanning area
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),

            SizedBox(height: 50),

            // Verifying face text
            Text(
              "Verifying your face ...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 20),

            // Camera button with custom image
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.yellow[600],
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'img/camera.png', // Use the custom image
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
