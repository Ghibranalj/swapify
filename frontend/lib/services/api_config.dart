import 'package:flutter/foundation.dart';

// API configuration for Swapify Flutter app
class ApiConfig {
  // Using localhost for web/desktop and 10.0.2.2 for Android emulator
  // You can adjust this to your computer's IP address if testing on a physical device.
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const String webBaseUrl = 'http://localhost:3000';
  
  static String get url {
    if (kIsWeb) return webBaseUrl;
    
    // For Desktop (Windows, macOS, Linux) and iOS simulator, use localhost
    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return webBaseUrl;
    }
    
    // Default to Android Emulator loopback
    return baseUrl;
  }
}
