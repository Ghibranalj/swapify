import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user_detail_page.dart';
import 'user_model.dart';

class DashboardView extends StatefulWidget {
  final bool isPremium;

  const DashboardView({
    super.key,
    this.isPremium = false, // Sesuai request, default-nya false
  });

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    // Logika Filtering Backend-Friendly
    final filteredUsers = _selectedCategory == 'All'
        ? dummyUsers
        : dummyUsers.where((user) => user.categories.contains(_selectedCategory)).toList();

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
          
          // Filter Horizontal Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Design', 'Coding', 'Language', 'Music', 'Art'].map((category) {
                return _buildFilterTag(category, _selectedCategory == category);
              }).toList(),
            ),
          ),
          const SizedBox(height: 25),
          
          // Kondisi Premium Banner
          if (!widget.isPremium) ...[
            _buildPremiumBanner(),
            const SizedBox(height: 25),
          ],
          
          // List Card User Dinamis Berdasarkan Filter
          if (filteredUsers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'No partners found in this category.',
                  style: GoogleFonts.inter(color: Colors.grey),
                ),
              ),
            )
          else
            ...filteredUsers.map((user) => _buildUserCard(context, user: user)).toList(),
            
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFF472B6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0A35),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFF472B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset('images/Icon-infinity.png', width: 22, color: Colors.black, errorBuilder: (c, e, s) => const Icon(Icons.all_inclusive, color: Colors.white)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFA672FF), Color(0xFFFF87C6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: Text(
                      'Unlock More Features \nwith Premium!',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Get more people to swap with!',
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFF472B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.east, color: Colors.black, size: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTag(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, {required UserModel user}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(user: user), 
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
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey[200],
              backgroundImage: AssetImage(user.imageAsset),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF2D2E4E)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(user.rating, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.grey[800])),
                      Text(' · ${user.swaps} swaps', style: GoogleFonts.inter(color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Batasi maksimal display 2 tag di card utama, sisanya jadi "+X"
                      ...user.skills.take(2).map((skill) => _buildSkillTag(skill)).toList(),
                      if (user.skills.length > 2)
                        _buildMoreSkillsTag('+${user.skills.length - 2}'),
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