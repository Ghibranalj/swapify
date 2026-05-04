import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_detail_page.dart'; 

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover Skills',
            style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w900, color: const Color(0xFF2D2E4E)),
          ),
          Text(
            'Find your perfect skill swap partner',
            style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.grey[400]),
                hintText: 'Search for skills or people...',
                border: InputBorder.none,
                hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterTag('All', true),
                _buildFilterTag('Design', false),
                _buildFilterTag('Coding', false),
                _buildFilterTag('Language', false),
                _buildFilterTag('Music', false),
                _buildFilterTag('Art', false),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _buildUserCard(
            context,
            name: 'Maya Rodriguez',
            rating: '4.8',
            swaps: '18',
            imageAsset: 'images/user1.png',
            skills: ['Spanish', 'Guitar'],
            moreSkills: '+1',
          ),
          _buildUserCard(
            context,
            name: 'Jordan Kim',
            rating: '4.7',
            swaps: '14',
            imageAsset: 'images/user2.png',
            skills: ['Web Development', 'Python'],
            moreSkills: '+1',
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFilterTag(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF7C3AED) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF7C3AED) : Colors.grey[200]!),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isSelected ? Colors.white : Colors.grey[800],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildUserCard(
    BuildContext context, {
    required String name,
    required String rating,
    required String swaps,
    required String imageAsset,
    required List<String> skills,
    required String moreSkills,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(name: name, imageAsset: imageAsset),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 35, backgroundColor: Colors.grey[200], backgroundImage: AssetImage(imageAsset)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF2D2E4E)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(rating, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.grey[800])),
                      Text(' · $swaps swaps', style: GoogleFonts.inter(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ...skills.map((skill) => _buildSkillTag(skill)).toList(),
                      _buildMoreSkillsTag(moreSkills),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillTag(String skill) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xFFF0EEFF), borderRadius: BorderRadius.circular(10)),
      child: Text(skill, style: GoogleFonts.inter(color: const Color(0xFF6C63FF), fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildMoreSkillsTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }
}