import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final int swapCount;
  const ProfilePage({super.key, required this.swapCount});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PageController _pageController = PageController();
  final ScrollController _skillsScrollController = ScrollController();
  int _currentCertificateIndex = 0;
  bool isPremium = true;
  bool isLoading = true;

  late String userName;
  late String userBio;
  File? userProfileImage;
  String? userProfileImageString; 
  late List<String> userSkills;
  late List<String> userGoals;
  late List<dynamic> userCertificates;
  
  int swapCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }
  
  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.swapCount != widget.swapCount) {
      _syncSwapCount(widget.swapCount);
    }
  }

  Future<void> _syncSwapCount(int newCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('swapCount', newCount);
    setState(() {
      swapCount = newCount;
    });
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      String? savedName = prefs.getString('savedName');
      userName = (savedName != null && savedName.isNotEmpty) ? savedName : 'Sophie Beck';

      String? savedBio = prefs.getString('savedBio');
      userBio = (savedBio != null && savedBio.isNotEmpty) ? savedBio : 'Passionate designer and coder. Love to learn new things! 🎨';

      String? imagePath = prefs.getString('savedImage');
      userProfileImageString = imagePath;
      if (imagePath != null && imagePath.isNotEmpty) {
        try {
          userProfileImage = File(imagePath);
        } catch (_) {
        }
      } else {
        userProfileImage = null;
      }

      userSkills = prefs.getStringList('savedSkills') ?? [];
      userGoals = prefs.getStringList('savedGoals') ?? [];
      
      userCertificates = prefs.getStringList('savedCertificates') ?? [];
      
      int savedSwap = prefs.getInt('swapCount') ?? 0;
      swapCount = widget.swapCount > savedSwap ? widget.swapCount : savedSwap;
      prefs.setInt('swapCount', swapCount); 
      
      isLoading = false;
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedName', userName);
    await prefs.setString('savedBio', userBio);
    await prefs.setString('savedImage', userProfileImageString ?? '');
    await prefs.setStringList('savedSkills', userSkills);
    await prefs.setStringList('savedGoals', userGoals);
    
    List<String> certPaths = userCertificates.map((cert) {
      if (cert is File) return cert.path;
      return cert.toString();
    }).toList();
    await prefs.setStringList('savedCertificates', certPaths);
  }

  Future<void> refreshData() async {
    await _loadProfileData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _skillsScrollController.dispose();
    super.dispose();
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          initialName: userName,
          initialBio: userBio,
          initialImage: userProfileImage,
          initialSkills: List.from(userSkills),
          initialGoals: List.from(userGoals),
          initialCertificates: List.from(userCertificates),
          isPremium: isPremium,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        userName = result['name'];
        userBio = result['bio'];
        
        if (result['profileImage'] is File) {
          userProfileImage = result['profileImage'];
          userProfileImageString = userProfileImage?.path;
        } else if (result['profileImage'] is String) {
          userProfileImageString = result['profileImage'];
          try {
            userProfileImage = userProfileImageString != null ? File(userProfileImageString!) : null;
          } catch (_) {}
        } else {
          userProfileImage = null;
          userProfileImageString = null;
        }

        userSkills = List<String>.from(result['skills']);
        userGoals = List<String>.from(result['goals']);
        userCertificates = List<dynamic>.from(result['certificates']);
      });

      await _saveProfileData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile successfully updated!',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF7B3AF5),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7C3AED);
    const Color learningGoalColor = Color(0xFF06B6D4);

    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F7FF),
        body: Center(
          child: CircularProgressIndicator(color: primaryPurple),
        ),
      );
    }

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
                colors: [
                  Color(0xFF06B6D4),
                  Color(0xFF2D8DDC),
                  Color(0xFF7C3AED),
                  Color(0xFFD363C5),
                  Color(0xFFF472B6),
                ],
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
                      Text(
                        'My Profile',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
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
                  child: RefreshIndicator(
                    onRefresh: refreshData,
                    color: const Color(0xFF7C3AED),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
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
                            child: Column(
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomCenter,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor: const Color(0xFFF3E8FF),
                                              backgroundImage: userProfileImageString != null && userProfileImageString!.isNotEmpty
                                                  ? NetworkImage(userProfileImageString!)
                                                  : null,
                                              child: (userProfileImageString == null || userProfileImageString!.isEmpty)
                                                  ? const Icon(Icons.person, size: 50, color: primaryPurple)
                                                  : null,
                                            ),
                                          ),
                                          if (isPremium)
                                            Positioned(
                                              bottom: -12,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(color: Colors.white, width: 3),
                                                ),
                                                child: Text(
                                                  'Premium',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 25),
                                      Text(
                                        userName,
                                        style: GoogleFonts.inter(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        userBio,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.grey),
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
                                      _buildStatItem('images/swap.png', '$swapCount Swaps'),
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
                                      if (userSkills.isNotEmpty)
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: userSkills
                                              .map((skill) => _buildTag(skill, isGradient: true))
                                              .toList(),
                                        )
                                      else
                                        const Text("No skills added yet", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                      const SizedBox(height: 25),
                                    ],
                                  ),
                                ),
                                
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle('images/goals.png', 'Learning Goals'),
                                      const SizedBox(height: 12),
                                      if (userGoals.isNotEmpty)
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: userGoals
                                              .map((goal) => _buildTag(goal, customColor: learningGoalColor))
                                              .toList(),
                                        )
                                      else
                                        const Text("No goals added yet", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                      const SizedBox(height: 25),
                                    ],
                                  ),
                                ),
                                
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle('images/icon-certificate.png', 'Certificates'),
                                      const SizedBox(height: 12),
                                      if (userCertificates.isNotEmpty) ...[
                                        SizedBox(
                                          height: 250,
                                          child: PageView.builder(
                                            controller: _pageController,
                                            itemCount: userCertificates.length,
                                            onPageChanged: (index) {
                                              setState(() {
                                                _currentCertificateIndex = index;
                                              });
                                            },
                                            itemBuilder: (context, index) {
                                              final cert = userCertificates[index];
                                              return Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.03),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 3),
                                                    )
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: Builder(
                                                    builder: (context) {
                                                      String certPath = cert.toString();

                                                      if (certPath.startsWith('images/')) {
                                                        return Image.asset(certPath, fit: BoxFit.cover);
                                                      }

                                                      if (certPath.startsWith('base64,')) {
                                                        return Image.memory(base64Decode(certPath.substring(7)), fit: BoxFit.cover);
                                                      }

                                                      if (kIsWeb) {
                                                        if (certPath.startsWith('http') || certPath.startsWith('blob:')) {
                                                          return Image.network(certPath, fit: BoxFit.cover);
                                                        } else {
                                                          return Container(
                                                            color: const Color(0xFFF1F5F9),
                                                            padding: const EdgeInsets.all(12),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                const Icon(Icons.workspace_premium_outlined, color: Color(0xFF7C3AED), size: 40),
                                                                const SizedBox(height: 8),
                                                                Text(
                                                                  certPath,
                                                                  textAlign: TextAlign.center,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      }

                                                      return cert is File
                                                          ? Image.file(cert, fit: BoxFit.cover)
                                                          : Image.file(File(certPath), fit: BoxFit.cover);
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(
                                            userCertificates.length,
                                            (index) => AnimatedContainer(
                                              duration: const Duration(milliseconds: 300),
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              height: 8,
                                              width: _currentCertificateIndex == index ? 20 : 8,
                                              decoration: BoxDecoration(
                                                color: _currentCertificateIndex == index
                                                    ? primaryPurple
                                                    : Colors.grey.shade300,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        const Text("No certificates uploaded", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              children: [
                                _buildActionButton(
                                  context,
                                  'Edit Profile',
                                  'images/edit.png',
                                  Colors.white,
                                  Colors.black,
                                  isOutlined: true,
                                  onTap: _navigateToEditProfile,
                                ),
                                const SizedBox(height: 12),
                                _buildActionButton(
                                  context,
                                  'Logout',
                                  Icons.logout_outlined,
                                  const Color(0xFFE74C3C),
                                  Colors.white,
                                  onTap: () {},
                                ),
                                if (!isPremium) ...[
                                  const SizedBox(height: 20),
                                  _buildPremiumBanner(),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String imagePath, String title) {
    return Row(
      children: [
        Image.asset(imagePath, width: 22, height: 22, errorBuilder: (context, error, stackTrace) => const Icon(Icons.star, size: 22, color: Colors.purple)),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    dynamic iconSource,
    Color bgColor,
    Color textColor, {
    bool isOutlined = false,
    VoidCallback? onTap,
  }) {
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
                fontSize: 16,
              ),
            ),
          ],
        ),
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
                child: Image.asset('images/Icon-infinity.png',
                    width: 22, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFF472B6)],
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
              child: const Icon(Icons.east, color: Color.fromARGB(255, 0, 0, 0), size: 12),
            ),
          ],
        ),
      ),
    );
  }
}