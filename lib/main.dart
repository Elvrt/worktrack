import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'home_page_after_clock_in.dart';
import 'clock_in_page.dart';
import 'clock_out_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock In/Out App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),  // Home screen page
        '/clock-in': (context) => ClockInPage(),  // Clock In page
        '/clock-out': (context) => ClockOutPage(),  // Clock Out page
        '/home-after-clock-in': (context) => HomePageAfterClockIn(),  // Home page after clock in
      },
    );
  }
}
