import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialBio;
  final File? initialImage;
  final String? initialImageUrl;
  final List<String> initialSkills;
  final List<String> initialGoals;
  final List<dynamic> initialCertificates;
  final bool isPremium;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialBio,
    this.initialImage,
    this.initialImageUrl,
    required this.initialSkills,
    required this.initialGoals,
    required this.initialCertificates,
    required this.isPremium,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  File? _profileImage;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  late List<String> mySkills;
  late List<String> learningGoals;
  late List<dynamic> certificates;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _bioController = TextEditingController(text: widget.initialBio);
    _profileImage = widget.initialImage;
    _imageUrl = widget.initialImageUrl;
    mySkills = widget.initialSkills;
    learningGoals = widget.initialGoals;
    certificates = widget.initialCertificates;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _skillController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _imageUrl = null;
      });
    }
  }

  Future<void> _pickCertificate() async {
    if (!widget.isPremium) return;

    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        certificates.add(File(pickedFile.path));
      });
    }
  }

  void _addSkill(String value) {
    if (value.trim().isNotEmpty && !mySkills.contains(value.trim())) {
      setState(() {
        mySkills.add(value.trim());
      });
      _skillController.clear();
    }
  }

  void _addGoal(String value) {
    if (value.trim().isNotEmpty && !learningGoals.contains(value.trim())) {
      setState(() {
        learningGoals.add(value.trim());
      });
      _goalController.clear();
    }
  }

  void _saveChanges() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, {
      'name': _nameController.text,
      'bio': _bioController.text,
      'profileImage': _profileImage,
      'skills': mySkills,
      'goals': learningGoals,
      'certificates': certificates,
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> topGradientColors = [
      const Color(0xFF06B6D4),
      const Color(0xFF2D8DDC),
      const Color(0xFF7C3AED),
      const Color(0xFFD363C5),
      const Color(0xFFF472B6),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: topGradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            'Edit Profile',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xFFB494FF),
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_imageUrl != null && _imageUrl!.isNotEmpty
                                ? NetworkImage(_imageUrl!) as ImageProvider
                                : null),
                        child: (_profileImage == null && (_imageUrl == null || _imageUrl!.isEmpty))
                            ? const Icon(Icons.person,
                                size: 70, color: Colors.white)
                            : null,
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: _pickProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22D3EE),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Name'),
                          _buildTextField('Your name', controller: _nameController),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Bio'),
                          _buildTextField('Tell us about yourself...',
                              maxLines: 4, controller: _bioController),
                          const SizedBox(height: 25),

                          _buildSectionTitle('My Skills'),
                          _buildPremiumOverlay(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputField(
                                  hint: 'Add Skills..',
                                  controller: _skillController,
                                  onSubmit: _addSkill,
                                ),
                                if (mySkills.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: mySkills.map((skill) {
                                        return _buildBubble(
                                          text: skill,
                                          isGradient: true,
                                          onDelete: () {
                                            setState(() {
                                              mySkills.remove(skill);
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          _buildSectionTitle('Learning Goals'),
                          _buildPremiumOverlay(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputField(
                                  hint: 'Add Goals..',
                                  controller: _goalController,
                                  onSubmit: _addGoal,
                                ),
                                if (learningGoals.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: learningGoals.map((goal) {
                                        return _buildBubble(
                                          text: goal,
                                          isGradient: false,
                                          color: const Color(0xFF06B6D4),
                                          onDelete: () {
                                            setState(() {
                                              learningGoals.remove(goal);
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          _buildSectionTitle('Certificate'),
                          _buildPremiumOverlay(
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: _pickCertificate,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: const Color(0xFFE5D7FF), width: 1.5),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.cloud_upload_outlined,
                                            color: Color(0xFF7C3AED), size: 32),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Drop your files here or Browse',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF7C3AED),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Max file size up to 50MB',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF7C3AED),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                ...certificates.map((cert) {
                                  String certName = cert is File
                                      ? cert.path.split('/').last
                                      : cert.toString().split('/').last;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color(0xFFE5D7FF), width: 1.5),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 45,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F4F6),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.description,
                                                color: Color(0xFF9CA3AF)),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                certName,
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: const Color(0xFF1F2937),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                cert is File ? 'Local Upload' : 'Default Asset',
                                                style: GoogleFonts.inter(
                                                  color: const Color(0xFF7C3AED),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (!widget.isPremium) return;
                                            setState(() {
                                              certificates.remove(cert);
                                            });
                                          },
                                          icon: const Icon(Icons.delete_outline,
                                              color: Color(0xFF7C3AED)),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: topGradientColors),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              child: Text(
                                'Save Changes',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey[400],
        showUnselectedLabels: true,
        selectedLabelStyle:
            GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
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
            icon: Badge(
              label: Text('2'),
              backgroundColor: Color(0xFFF472B6),
              child: ImageIcon(AssetImage("images/messages.png")),
            ),
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

  Widget _buildPremiumOverlay(Widget child) {
    if (widget.isPremium) return child;
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: child,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const ImageIcon(
                AssetImage('images/icon-lock.png'),
                color: Color(0xFF7C3AED),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF06B6D4)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: Text(
                  'Unlock Now',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint,
      {int maxLines = 1, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.inter(color: const Color(0xFF9CA3AF), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5D7FF), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7B3AF5), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    required Function(String) onSubmit,
  }) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmit,
      textInputAction: TextInputAction.done,
      style: GoogleFonts.inter(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.inter(color: const Color(0xFF9CA3AF), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5D7FF), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7B3AF5), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildBubble({
    required String text,
    required bool isGradient,
    Color? color,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isGradient ? null : color,
        gradient: isGradient
            ? const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFFF472B6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}