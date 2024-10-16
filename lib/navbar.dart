import 'package:flutter/material.dart';
import 'package:worktrack/Report/reportmonthly.dart';
import 'package:worktrack/home_screen.dart';
import 'package:worktrack/profil/infoprofile.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  BottomNavBar({required this.currentIndex}); // Terima index saat ini

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Tentukan item yang aktif
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
      onTap: (int index) {
        // Handle tab change
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => reportmonthly()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>HomeScreen()), //belummm
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>InfoProfile()),
            );
            break;
        }
      },
    );
  }
}