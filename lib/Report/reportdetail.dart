import 'package:flutter/material.dart';

void main() {
  runApp(const ReportDeail());
}

class ReportDeail extends StatelessWidget {
  const ReportDeail({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ReportPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'REPORT',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            fontFamily: 'Urbanist',
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black, // Adjust the color of the icon
          onPressed: () {
            // Add your back action here
          },
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 16.0), // Adjust padding as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.end, // Align text to the right
              children: const [
                Text(
                  '17:19',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Adjust color for visibility
                  ),
                ),
                Text(
                  'Wednesday, 11 Feb',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                    color: Colors.black, // Adjust color for visibility
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 51,
            decoration: BoxDecoration(
              color: Color(0x56FFD83A),
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              height: 51,
              decoration: BoxDecoration(
                color: Color(0xFFF2BC),
                border: Border.all(
                  color: Colors.black.withOpacity(0.1),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new),
                    color: Colors.black,
                    onPressed: () {
                      // Add your back action here
                    },
                  ),
                  Text(
                    '08 February 2024',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Colors.black,
                    onPressed: () {
                      // Add your next action here
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
          // clockin
          Container(
            width: 353,
            height: 57,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 353,
                    height: 57,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 25,
                  top: 10,
                  child: Icon(
                    Icons.history,
                    color: Colors.black,
                    size: 40.0,
                  ),
                ),
                Positioned(
                  left: 93,
                  top: 20,
                  child: Text(
                    'Clock In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      height: 1.0, // Adjusted from 0 for better text scaling
                    ),
                  ),
                ),
                Positioned(
                  left: 258,
                  top: 20,
                  child: Text(
                    '08:59',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0A750E),
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                      height: 1.0, // Adjusted from 0 for better text scaling
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // clockin
          Container(
            width: 353,
            height: 57,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 353,
                    height: 57,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 25,
                  top: 10,
                  child: Icon(
                    Icons.update,
                    color: Colors.black,
                    size: 40.0,
                  ),
                ),
                Positioned(
                  left: 93,
                  top: 20,
                  child: Text(
                    'Clock Out',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      height: 1.0, // Adjusted from 0 for better text scaling
                    ),
                  ),
                ),
                Positioned(
                  left: 258,
                  top: 20,
                  child: Text(
                    '08:59',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0A750E),
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                      height: 1.0, // Adjusted from 0 for better text scaling
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 353,
            height: 266,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Activity',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Title:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Update Data',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Content:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Update data on food price increases',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Image:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 233,
                        height: 125,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        unselectedItemColor: Color(0xFF9E9E9E),
        selectedItemColor: Color(0xFFFEDB47),
      ),
    );
  }
}
