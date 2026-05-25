import 'package:flutter/material.dart';
import 'package:frontend/theme/admin_colors.dart';
import 'package:frontend/widgets/user_card.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {

  // Fungsi bantuan untuk membuat Tag Skill
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  // Fungsi bantuan untuk membuat kotak pagination (< 1 2 3 >)
  Widget _buildPageBox(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AdminColors.primaryPurple : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? AdminColors.primaryPurple : Colors.black12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : AdminColors.textHeading,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.backgroundLight,
      
    
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Header
              const Text("User Management", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AdminColors.textHeading)),
              const SizedBox(height: 5),
              const Text("Review and manage community members and their skill sets.", style: TextStyle(fontSize: 14, color: AdminColors.textBody)),
              const SizedBox(height: 20),
              
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.black54),
                    hintText: "Search by name or email...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol "Add New User"
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.primaryPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.person_add_outlined, color: Colors.white),
                  label: const Text("Add New User", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Daftar Kartu Pengguna (Bisa di-scroll)
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // 1. Elena Rodriguez
                    UserCard(
                      name: "Elena Rodriguez",
                      email: "elena.rod@gmail.com",
                      status: "Active",
                      tags: [
                        _buildTag("UX Design", AdminColors.primaryPurple),
                        _buildTag("Figma", AdminColors.primaryPurple),
                        _buildTag("Illustration", AdminColors.accentPink),
                      ],
                      leftButton: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.blue, width: 2)),
                        child: const Text("Edit", style: TextStyle(color: Colors.blue)),
                      ),
                      rightButton: TextButton(
                        onPressed: () {},
                        child: Text("Suspend", style: TextStyle(color: Colors.red.shade700)),
                      ),
                    ),

                    // 2. Marcus Chen (Highlighted)
                    UserCard(
                      name: "Marcus Chen",
                      email: "m.chen.dev@gmail.com",
                      status: "Pending",
                      isHighlighted: true, // Border Ungu
                      tags: [
                        _buildTag("React", AdminColors.primaryPurple),
                        _buildTag("Tailwind", AdminColors.primaryPurple),
                        _buildTag("Mentoring", AdminColors.accentPink),
                      ],
                      leftButton: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AdminColors.accentPink, elevation: 0),
                        child: const Text("Approve", style: TextStyle(color: Colors.white)),
                      ),
                      rightButton: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black26)),
                        child: const Text("Details", style: TextStyle(color: AdminColors.textBody)),
                      ),
                    ),

                    // 3. Sarah Jenkins
                    UserCard(
                      name: "Sarah Jenkins",
                      email: "s.jenkins@gmail.com",
                      status: "Active",
                      tags: [
                        _buildTag("Public Speaking", AdminColors.primaryPurple),
                        _buildTag("Writing", AdminColors.primaryPurple),
                      ],
                      leftButton: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: AdminColors.primaryPurple)),
                        child: const Text("Edit", style: TextStyle(color: AdminColors.primaryPurple)),
                      ),
                      rightButton: TextButton(
                        onPressed: () {},
                        child: Text("Suspend", style: TextStyle(color: Colors.red.shade700)),
                      ),
                    ),

                    // 4. David Okafor
                    UserCard(
                      name: "David Okafor",
                      email: "david.okafor@gmail.com",
                      status: "Active",
                      tags: [
                        _buildTag("Data Science", AdminColors.primaryPurple),
                        _buildTag("Python", AdminColors.primaryPurple),
                        _buildTag("SQL", AdminColors.accentPink),
                      ],
                      leftButton: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: AdminColors.primaryPurple)),
                        child: const Text("Edit", style: TextStyle(color: AdminColors.primaryPurple)),
                      ),
                      rightButton: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AdminColors.accentGreen, elevation: 0),
                        child: const Text("Restore", style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 20),
                    
                    // Navigasi Halaman (Pagination)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Showing 4 of 128\nusers",
                          style: TextStyle(fontSize: 12, color: AdminColors.textBody, height: 1.2),
                        ),
                        Row(
                          children: [
                            _buildPageBox("<"),
                            _buildPageBox("1", isSelected: true),
                            _buildPageBox("2"),
                            _buildPageBox("3"),
                            _buildPageBox(">"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40), // Jarak tambahan agar tidak mentok navbar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}