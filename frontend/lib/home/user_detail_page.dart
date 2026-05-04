import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'request_swap_page.dart';

class UserDetailPage extends StatelessWidget {
  final String name;
  final String imageAsset;

  const UserDetailPage({
    super.key,
    required this.name,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFD966B2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Expanded(
                child: Container(color: const Color(0xFFF6F7FF)),
              ),
            ],
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(imageAsset),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          name,
                          style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Design enthusiast and coding newbie. Let\'s swap skills!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatIcon(Icons.star, '4.8', Colors.orange),
                            _buildStatImage('images/swap.png', '18 Swaps'),
                          ],
                        ),
                        const SizedBox(height: 25),

                        _buildSectionHeader('images/skills.png', 'My Skills'),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildGradientChip('Spanish'),
                              _buildGradientChip('Guitar'),
                              _buildGradientChip('Singing'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        _buildSectionHeader('images/goals.png', 'Learning Goals'),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildCyanChip('UI/UX Design'),
                              _buildCyanChip('Photography'),
                              _buildCyanChip('Video Editing'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestSwapPage(
                                  name: name,
                                  imageAsset: imageAsset,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8A3CFE), Color(0xFFFE6BB7)],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Request Skill Swap',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Image.asset('images/sparkle.png', width: 20, height: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black.withOpacity(0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About Skill Swaps',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              const SizedBox(height: 12),
                              _buildBulletPoint('Connect and schedule a time to meet (online or in-person)'),
                              _buildBulletPoint('Exchange skills in a friendly, collaborative way'),
                              _buildBulletPoint('Rate each other after completing the swap'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildStatImage(String assetPath, String text) {
    return Row(
      children: [
        Image.asset(assetPath, width: 24, height: 24),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildSectionHeader(String assetPath, String title) {
    return Row(
      children: [
        Image.asset(assetPath, width: 22, height: 22),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }

  Widget _buildGradientChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF8A3CFE), Color(0xFFF2709C)],
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCyanChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF00B4D8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}