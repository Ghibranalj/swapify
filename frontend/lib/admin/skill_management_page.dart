import 'package:flutter/material.dart';
import 'package:frontend/theme/admin_colors.dart';
import 'package:frontend/widgets/skill_card.dart';

class SkillManagementPage extends StatefulWidget {
  const SkillManagementPage({Key? key}) : super(key: key);

  @override
  State<SkillManagementPage> createState() => _SkillManagementPageState();
}

class _SkillManagementPageState extends State<SkillManagementPage> {
  

  // Fungsi bantuan untuk membuat UI Tag kecil
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8), // Lebih kotak sedikit sesuai gambar
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.w600, 
          color: color
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.backgroundLight,
      
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: AdminColors.primaryPurple,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Header
              const Text(
                "Skill Management",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AdminColors.textHeading),
              ),
              const SizedBox(height: 5),
              const Text(
                "Configure and organise the available talent categories.",
                style: TextStyle(fontSize: 15, color: AdminColors.textBody),
              ),
              const SizedBox(height: 25),
              
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
                    hintText: "Search skills...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              
              // Daftar Kartu (Scrollable)
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(), // Animasi scroll halus
                  children: [
                    // 1. UI/UX DESIGN
                    SkillCard(
                      icon: Icons.palette_outlined,
                      iconColor: AdminColors.primaryPurple,
                      title: "UI/UX Design",
                      description: "Visual interfaces, user experience research, and prototyping mastery.",
                      tags: [
                        _buildTag("Creative", AdminColors.primaryPurple),
                        _buildTag("Design", AdminColors.accentPink),
                      ],
                    ),
                    
                    // 2. WEB DEVELOPMENT
                    SkillCard(
                      icon: Icons.code,
                      iconColor: AdminColors.accentPink,
                      title: "Web Development",
                      description: "Building responsive and high-performance website using modern frameworks.",
                      hasActionNeeded: true,
                      tags: [
                        _buildTag("Tech", AdminColors.primaryPurple),
                        _buildTag("Frontend", AdminColors.primaryBlue),
                      ],
                    ),

                    // 3. PHOTOGRAPHY
                    SkillCard(
                      icon: Icons.camera_alt_outlined,
                      iconColor: AdminColors.primaryPurple,
                      title: "Photography",
                      description: "Capturing moments with professional equipment and advanced editing techniques.",
                      tags: [
                        _buildTag("Design", AdminColors.accentPink),
                      ],
                    ),

                    // 4. DIGITAL MARKETING
                    SkillCard(
                      icon: Icons.vibration,
                      iconColor: AdminColors.primaryPurple,
                      title: "Digital Marketing",
                      description: "SEO, SEM, and social media strategy for brand growth and visibility.",
                      tags: [
                        _buildTag("Business", AdminColors.primaryPurple),
                      ],
                    ),

                    // 5. PROJECT MANAGEMENT
                    SkillCard(
                      icon: Icons.assignment_outlined,
                      iconColor: AdminColors.primaryBlue,
                      title: "Project Management",
                      description: "Leading teams through complex project lifecycle using Scrum, Kanban, and modern productivity tools to ensure delivery excellence.",
                      tags: [
                        _buildTag("Leadership", AdminColors.primaryBlue),
                        _buildTag("Agile", AdminColors.primaryBlue),
                      ],
                    ),
                    const SizedBox(height: 80), // Tambahan space agar tidak tertutup Navbar
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