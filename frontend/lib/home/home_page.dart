import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/home/dashboard_view.dart';
import 'package:frontend/message/message_page.dart';
import 'package:frontend/notification/notification_page.dart';
import 'package:frontend/profile/profile_page.dart';
import 'package:frontend/request/request_page.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _swapCount = 0;

  @override
  void initState() {
    super.initState();
    _loadDataFromMemory();
  }

  Future<void> _loadDataFromMemory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _swapCount = prefs.getInt('swapCount') ?? 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _loadDataFromMemory(); 
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardView(); 
      case 1:
        return const RequestPage();
      case 2:
        return const MessagePage();
      case 3:
        return const NotificationPage();
      case 4:
        return ProfilePage(swapCount: _swapCount); 
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      body: _buildCurrentPage(), 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey[400],
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("images/home.png")),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("images/request.png")),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("images/messages.png")),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("images/notification.png")),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("images/profile.png")),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}