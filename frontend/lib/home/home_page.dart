import 'package:flutter/material.dart';
import 'package:frontend/home/dashboard_view.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardView(), 
    const Center(child: Text('Request Page')),
    const Center(child: Text('Messages Page')),
    const Center(child: Text('Notification Page')),
    const Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF), 
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
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
            label: 'Notif',
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