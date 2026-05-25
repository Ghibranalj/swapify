import 'package:flutter/material.dart';
import 'package:frontend/admin/alert_page.dart';
import 'package:frontend/theme/admin_colors.dart';
import 'package:frontend/admin/user_management_page.dart';
import 'package:frontend/admin/skill_management_page.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _selectedIndex = 0; // Default awal di index 0 (Home/Users)

  // Ini adalah daftar halaman yang akan dipanggil oleh Navbar
  final List<Widget> _pages = [
    const UserManagementPage(), // Index 0
    const SkillManagementPage(), // Index 1
    const AlertPage(), // Index 2 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _pages[_selectedIndex], 
      
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AdminColors.primaryPurple, width: 3)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          onTap: (index) {
            // Ini yang bikin layarnya ganti saat tombol ditekan
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.architecture), label: 'Skills'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Alerts'),
          ],
        ),
      ),
    );
  }
}