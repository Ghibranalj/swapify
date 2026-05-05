import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import halaman edit profile kamu di sini
import 'edit_profile_page.dart'; 

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7C3AED);
    const Color primaryPink = Color(0xFFF472B6);
    const Color learningGoalColor = Color(0xFF06B6D4);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryPurple, primaryPink],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Profile',
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 24, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05), 
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    const CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Color(0xFFF3E8FF),
                                      child: Icon(Icons.person, size: 50, color: primaryPurple),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1CB5C9), 
                                        shape: BoxShape.circle
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined, 
                                        color: Colors.white, 
                                        size: 18
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Sophie Beck',
                                  style: GoogleFonts.inter(
                                    fontSize: 22, 
                                    fontWeight: FontWeight.w800
                                  ),
                                ),
                                const Text(
                                  'Passionate designer and coder.', 
                                  style: TextStyle(color: Colors.grey)
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Divider(),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStatItem(Icons.star, '4.8', Colors.orange),
                                const SizedBox(width: 40),
                                _buildStatItem('images/swap.png', '12 Swaps'),
                              ],
                            ),
                          ),

                          const Divider(),
                          const SizedBox(height: 20),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('images/skills.png', 'My Skills'),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    _buildTag('Graphic Design', isGradient: true),
                                    _buildTag('React', isGradient: true),
                                    _buildTag('Flutter', isGradient: true),
                                    _buildTag('UI/UX', isGradient: true),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('images/goals.png', 'Learning Goals'),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    _buildTag('Web Development', customColor: learningGoalColor),
                                    _buildTag('Machine Learning', customColor: learningGoalColor),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      _buildActionButton(
                        context, // Tambahkan context untuk navigasi
                        'Edit Profile', 
                        'images/edit.png', 
                        Colors.white, 
                        Colors.black, 
                        isOutlined: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfilePage()),
                          );
                        }
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        context,
                        'Logout', 
                        Icons.logout_outlined, 
                        const Color(0xFFE74C3C), 
                        Colors.white,
                        onTap: () {
                          // logic logout kl nnt mo tmbh logout
                        }
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(dynamic iconData, String value, [Color? iconColor]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (iconData is IconData) 
          Icon(iconData, color: iconColor, size: 22) 
        else 
          Image.asset(iconData, width: 22, height: 22),
        const SizedBox(width: 8),
        Text(
          value, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String imagePath, String title) {
    return Row(
      children: [
        Image.asset(imagePath, width: 22, height: 22),
        const SizedBox(width: 10),
        Text(
          title, 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
      ],
    );
  }

  Widget _buildTag(String label, {bool isGradient = false, Color? customColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isGradient ? null : customColor,
        gradient: isGradient
            ? const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFFF472B6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 13, 
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, 
    String label, 
    dynamic iconSource, 
    Color bgColor, 
    Color textColor, 
    {bool isOutlined = false, VoidCallback? onTap}
  ) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: isOutlined ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: isOutlined ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconSource is IconData) 
              Icon(iconSource, color: textColor, size: 20) 
            else 
              Image.asset(iconSource, color: textColor, width: 20, height: 20),
            const SizedBox(width: 10),
            Text(
              label, 
              style: TextStyle(
                color: textColor, 
                fontWeight: FontWeight.w600, 
                fontSize: 16
              )
            ),
          ],
        ),
      ),
    );
  }
}