import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              Image.asset(
                'images/logo1.png',
                height: 100,
              ),

              const SizedBox(height: 10),

              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFFF472B6),
                    Color(0xFF06B6D4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: Text(
                  'Welcome to\nSwapify',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Connect with students and swap skills 🚀',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter( 
                  color: Colors.grey, 
                  fontSize: 16
                ),
              ),

              const Spacer(),

              Image.asset(
                'images/img1.png',
                height: 300,
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/google.png',
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Login with Google',
                      style: GoogleFonts.inter( 
                        fontSize: 16, 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'By continuing, you agree to our Terms & Privacy Policy',
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}