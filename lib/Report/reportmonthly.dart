import 'package:flutter/material.dart';

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
        title: const Text('REPORT'),
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0), // Padding untuk memposisikan text ke pojok kanan
            child: Center(
              child: Text(
                '08:00', // Text di pojok kanan
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
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
            child: const Text(
              'February 2024',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
             Container(
              color: Color(0x56FFD83A), // Background color for the row
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('Date', style: TextStyle(fontSize: 16)),
                  Text('Clock In', style: TextStyle(fontSize: 16)),
                  Text('Clock Out', style: TextStyle(fontSize: 16)),
                  Text('Activity', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 15),
          // Add more content here for rows, etc.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('11', style: TextStyle(fontSize: 16)),
                Text('08:59', style: TextStyle(fontSize: 16)),
                Text('17:02', style: TextStyle(fontSize: 16)),
                Text('Update Data', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          
            const SizedBox(height: 15),

           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('10', style: TextStyle(fontSize: 16)),
                Text('08:54', style: TextStyle(fontSize: 16)),
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
