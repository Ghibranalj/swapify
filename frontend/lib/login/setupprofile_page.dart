import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/login/uploadcertificate_page.dart';

class SetUpProfilePage extends StatefulWidget {
  const SetUpProfilePage({super.key});

  @override
  State<SetUpProfilePage> createState() => _SetUpProfilePageState();
}

class _SetUpProfilePageState extends State<SetUpProfilePage> {
  XFile? _profileImageFile;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _offerInputController = TextEditingController();
  final TextEditingController _learnInputController = TextEditingController();

  final ScrollController _offerScrollController = ScrollController();
  final ScrollController _learnScrollController = ScrollController();

  final List<String> _offerSkillsKolam = [
    'Design Graphic', 'Doodle', 'Flutter', 'Java', 'JavaScript',
    'Database', 'Python', 'Singing', 'UI/UX Design', 'Golang', 'React Native'
  ];
  final Set<String> _selectedOfferSkills = {};

  final List<String> _learnSkillsKolam = [
    'Design Graphic', 'Doodle', 'Flutter', 'Java', 'JavaScript',
    'Database', 'Python', 'Singing', 'UI/UX Design', 'Golang', 'React Native'
  ];
  final Set<String> _selectedLearnSkills = {};

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _offerInputController.dispose();
    _learnInputController.dispose();
    _offerScrollController.dispose();
    _learnScrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImageFile = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  void _addTypedOfferSkill(String skill) {
    if (skill.trim().isNotEmpty) {
      setState(() {
        if (!_offerSkillsKolam.contains(skill.trim())) {
          _offerSkillsKolam.insert(0, skill.trim());
        }
        _selectedOfferSkills.add(skill.trim());
        _offerInputController.clear();
      });
    }
  }

  void _addTypedLearnSkill(String skill) {
    if (skill.trim().isNotEmpty) {
      setState(() {
        if (!_learnSkillsKolam.contains(skill.trim())) {
          _learnSkillsKolam.insert(0, skill.trim());
        }
        _selectedLearnSkills.add(skill.trim());
        _learnInputController.clear();
      });
    }
  }

  List<String> _getAvailableOfferSkills() {
    return _offerSkillsKolam.where((s) => !_selectedOfferSkills.contains(s)).toList();
  }

  List<String> _getAvailableLearnSkills() {
    return _learnSkillsKolam.where((s) => !_selectedLearnSkills.contains(s)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5D7FF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7C3AED), size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFFF472B6), Color(0xFF06B6D4)],
                        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                        child: const Text(
                          'Set Up Your Profile',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Let's get you started!",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7C3AED),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: _imageBytes != null
                              ? Image.memory(
                                  _imageBytes!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                )
                              : const Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFF5F3FF), width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Color(0xFF06B6D4), size: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildLabel('Name'),
              _buildTextField(controller: _nameController, hintText: 'Your name'),
              const SizedBox(height: 20),
              _buildLabel('Bio'),
              _buildTextField(
                controller: _bioController,
                hintText: 'Tell us about yourself...',
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              _buildSectionHeader('Skills I Can Offer', 'images/skills.png'),
              _buildTextField(
                controller: _offerInputController,
                hintText: 'Type to add skill',
                onSubmitted: _addTypedOfferSkill,
              ),
              const SizedBox(height: 10),
              _buildSkillsBox(
                availableSkills: _getAvailableOfferSkills(),
                scrollController: _offerScrollController,
                onToggle: (skill) {
                  setState(() {
                    _selectedOfferSkills.add(skill);
                  });
                },
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedOfferSkills.map((skill) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedOfferSkills.remove(skill);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            skill,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.close, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _buildSectionHeader('Skills I Want to Learn', 'images/goals.png'),
              _buildTextField(
                controller: _learnInputController,
                hintText: 'Type to add skill',
                onSubmitted: _addTypedLearnSkill,
              ),
              const SizedBox(height: 10),
              _buildSkillsBox(
                availableSkills: _getAvailableLearnSkills(),
                scrollController: _learnScrollController,
                onToggle: (skill) {
                  setState(() {
                    _selectedLearnSkills.add(skill);
                  });
                },
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedLearnSkills.map((skill) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLearnSkills.remove(skill);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF06B6D4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            skill,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.close, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFFF472B6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    
                    await prefs.setInt('swap_count', 0);
                    
                    if (_nameController.text.trim().isNotEmpty) {
                      await prefs.setString('savedName', _nameController.text.trim());
                    }
                    if (_bioController.text.trim().isNotEmpty) {
                      await prefs.setString('savedBio', _bioController.text.trim());
                    }
                    if (_profileImageFile != null) {
                      await prefs.setString('savedImage', _profileImageFile!.path);
                    }
                    
                    await prefs.setStringList('savedSkills', _selectedOfferSkills.toList());
                    await prefs.setStringList('savedGoals', _selectedLearnSkills.toList());

                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadCertificatePage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(width: 8),
          Image.asset(iconPath, width: 20, height: 20, errorBuilder: (context, error, stackTrace) => const Icon(Icons.star, size: 16, color: Colors.purple)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5D7FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7C3AED)),
        ),
      ),
    );
  }

  Widget _buildSkillsBox({
    required List<String> availableSkills,
    required ScrollController scrollController,
    required Function(String) onToggle,
  }) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5D7FF)),
      ),
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.centerLeft,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: RawScrollbar(
          controller: scrollController,
          thumbColor: const Color(0xFF969696),
          thickness: 4,
          radius: const Radius.circular(10),
          thumbVisibility: true,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                alignment: WrapAlignment.start,
                children: availableSkills.map((skill) {
                  return GestureDetector(
                    onTap: () => onToggle(skill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3E3E3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: Color(0xFF404040),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}