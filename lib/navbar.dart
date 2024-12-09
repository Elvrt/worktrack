import 'package:flutter/material.dart';
import 'package:worktrack/Report/reportmonthly.dart';
import 'package:worktrack/homepage/home_screen.dart';
import 'package:worktrack/profil/infoprofile.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  BottomNavBar({required this.currentIndex}); // Terima index saat ini

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildGradientIcon(Icons.assessment, 0),
          label: 'Report',
        ),
        BottomNavigationBarItem(
          icon: _buildGradientIcon(Icons.home, 1),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildGradientIcon(Icons.person, 2),
          label: 'Profile',
        ),
      ],
      backgroundColor: Colors.white,
      unselectedItemColor: const Color(0xFF9E9E9E),
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ReportPage()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InfoProfile()),
            );
            break;
        }
      },
    );
  }

  Widget _buildGradientIcon(IconData icon, int index) {
    if (index == currentIndex) {
      // If the icon is selected, apply the gradient effect
      return ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Color(0xFFFEDB47), Color(0xFFF57C00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Icon(icon, color: Colors.white),
      );
      
    } else {
      // For unselected items, show the default icon color
      return Icon(icon);
    }
  }
}