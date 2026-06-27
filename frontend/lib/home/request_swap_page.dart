import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/home/user_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/api_config.dart';

class RequestSwapPage extends StatefulWidget {
  final UserModel targetUser;

  const RequestSwapPage({super.key, required this.targetUser});

  @override
  State<RequestSwapPage> createState() => _RequestSwapPageState();
}

class _RequestSwapPageState extends State<RequestSwapPage> {
  String selectedOffer = "";
  String selectedWant = "";
  List<String> mySkills = [];
  List<dynamic> allSkills = [];
  bool _isLoading = true;
  bool _isNavigated = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final apiService = ApiService();
      
      // Load my profile to get my skills
      final profile = await apiService.getMyProfile();
      final userSkills = profile['skills'] as List<dynamic>? ?? [];
      
      // Load all skills from DB to resolve names to UUIDs
      final dbSkills = await apiService.getAllSkills();

      setState(() {
        mySkills = userSkills.map((s) => s['name'] as String).toList();
        allSkills = dbSkills;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load skills: ${e.toString()}')),
        );
      }
    }
  }

  void _showTopSnackBar() {
    setState(() {
      _isNavigated = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 130,
          left: 20,
          right: 20,
        ),
        backgroundColor: const Color(0xFFEDFDF3),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0XFF008A2E),
              size: 35,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Swap request sent!',
                    style: GoogleFonts.inter(
                      color: const Color(0XFF008A2E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your request to swap has been sent! Don\'t forget to check your messages from them.',
                    style: GoogleFonts.inter(
                      color: const Color(0XFF008A2E),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                if (!_isNavigated) {
                  _isNavigated = true;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: Text(
                'Done',
                style: GoogleFonts.inter(
                  color: const Color(0XFF008A2E),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4), 
      ),
    );

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && !_isNavigated) {
        _isNavigated = true;
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  Future<void> _submitRequest() async {
    if (selectedOffer.isEmpty || selectedWant.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both skills to continue.')),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
      ),
    );

    try {
      final apiService = ApiService();
      
      // Resolve skill names to UUIDs
      final requesterSkill = allSkills.firstWhere(
        (s) => (s['name'] as String).toLowerCase() == selectedOffer.toLowerCase(),
        orElse: () => null,
      );
      final providerSkill = allSkills.firstWhere(
        (s) => (s['name'] as String).toLowerCase() == selectedWant.toLowerCase(),
        orElse: () => null,
      );

      if (requesterSkill == null || providerSkill == null) {
        throw Exception('Invalid skill selected');
      }

      await apiService.createSwapRequest(
        providerId: widget.targetUser.id,
        requesterSkillId: requesterSkill['id'],
        providerSkillId: providerSkill['id'],
        message: _messageController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context); // Dismiss loading
        _showTopSnackBar();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send swap request: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFD1C4E9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7C3AED), size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request Skill Swap',
                    style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF7C3AED), width: 2),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: widget.targetUser.imageAsset.startsWith('http')
                              ? NetworkImage(widget.targetUser.imageAsset)
                              : widget.targetUser.imageAsset.startsWith('/uploads')
                                  ? NetworkImage('${ApiConfig.url}${widget.targetUser.imageAsset}')
                                  : AssetImage(widget.targetUser.imageAsset) as ImageProvider,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.targetUser.name, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('Ready to swap skills!', style: GoogleFonts.inter(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  _buildSelectionCard(
                    "Your Skill to Offer",
                    mySkills,
                    selectedOffer,
                    (val) => setState(() => selectedOffer = val),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildSelectionCard(
                    "Skill You Want from ${widget.targetUser.name}",
                    widget.targetUser.skills,
                    selectedWant,
                    (val) => setState(() => selectedWant = val),
                  ),
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Message (Optional)', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _messageController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Introduce yourself...',
                            hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Color(0xFFD1C4E9)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _submitRequest,
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFEC4899)]),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            'Send Request',
                            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
    );
  }

  Widget _buildSelectionCard(String title, List<String> options, String selectedVal, Function(String) onSelect) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          options.isEmpty
              ? Text('No skills listed.', style: GoogleFonts.inter(color: Colors.grey, fontSize: 13))
              : Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: options.map((skill) {
                    bool isSelected = selectedVal == skill;
                    return GestureDetector(
                      onTap: () => onSelect(skill),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFE0E0E0).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: GoogleFonts.inter(
                            color: isSelected ? Colors.white : Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}