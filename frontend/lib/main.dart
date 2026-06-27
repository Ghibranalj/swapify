import 'package:flutter/material.dart';
import 'package:frontend/admin/admin_main_page.dart';
import 'package:frontend/checkout/checkout_page.dart';
import 'package:frontend/home/home_page.dart';
import 'package:frontend/login/setUpProfile_page.dart';
import 'package:frontend/login/uploadcertificate_page.dart';
import 'package:frontend/splash.dart';
import 'package:frontend/subscription/subscription_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/admin/skill_management_page.dart';
import 'package:frontend/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final apiService = ApiService();
  await apiService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ApiService().token != null;
    
    return MaterialApp(
      title: 'Swapify',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme()
      ),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}