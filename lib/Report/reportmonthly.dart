import 'package:flutter/material.dart';
import 'package:worktrack/Report/reportdetail.dart';

void main() {
  runApp(const reportmonthly());
}

class reportmonthly extends StatelessWidget {
  const reportmonthly({super.key});

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
              fontFamily: 'Urbanist'),
        ),
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
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
                    'February 2024',
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
          Container(
            color: Color(0x56FFD83A), // Background color for the row
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                    )),
                Text('Clock In',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                    )),
                Text('Clock Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                    )),
                Text('Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                    )),
              ],
            ),
          ),

          const SizedBox(height: 30),
          // Add more content here for rows, etc.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportDetail()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('11', style: TextStyle(fontSize: 16)),
                  Text(
                    '08:59',
                    style: TextStyle(
                      color: Color(0xFF09740E),
                      fontSize: 16,
                    ),
                  ),
                  Text('17:02', style: TextStyle(fontSize: 16)),
                  Text('Update Data', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('10', style: TextStyle(fontSize: 16)),
                Text('09:21',
                    style: TextStyle(
                      color: Color(0xFF9A1212),
                      fontSize: 16,
                    )),
                Text('17:02', style: TextStyle(fontSize: 16)),
                Text('Update Data', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
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
