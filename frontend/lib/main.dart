import 'package:flutter/material.dart';
import 'package:frontend/home/home_page.dart';
//import 'screens/splash.dart'; 
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swapify',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme()
      ),
      home: const HomePage(), 
    );
  }
}