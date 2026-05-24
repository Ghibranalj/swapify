import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/message/chat_page.dart'; 

class RequestItem {
  final String name;
  final String date;
  final String skill1;
  final String skill2;
  final String message;
  String tabType;

  RequestItem({
    required this.name,
    required this.date,
    required this.skill1,
    required this.skill2,
    required this.message,
    required this.tabType,
  });
}

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int _selectedTab = 0;

  final List<RequestItem> _requests = [
    RequestItem(
      name: "Maya Rodriguez",
      date: "03/03/2026",
      skill1: "Spanish",
      skill2: "UI/UX Design",
      message: "Hey! I'd love to learn UI/UX from you. I can teach you Spanish in exchange! 😊",
      tabType: "pending",
    ),
    RequestItem(
      name: "Alex Chen",
      date: "03/01/2026",
      skill1: "React",
      skill2: "Italian Cooking",
      message: "I'd love to learn cooking from you!",
      tabType: "active",
    ),
    RequestItem(
      name: "Sarah Jenkins",
      date: "25/02/2026",
      skill1: "UI/UX Design",
      skill2: "Photography",
      message: "Let's learn from each other! 📸",
      tabType: "done",
    ),
  ];

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 160,
          left: 20,
          right: 20,
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFFFF4), 
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD1F7E2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF008A33), size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Request accepted!",
                      style: GoogleFonts.inter(
                        color: const Color(0xFF008A33),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "You now can coordinate with the user to swap skills.",
                      style: GoogleFonts.inter(
                        color: const Color(0xFF008A33),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showRatingDialog(BuildContext context, String name) {
    int selectedRating = 0; 
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Rate Your Experience",
                      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "How was your swap with $name?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedRating = index + 1;
                            });
                          },
                          child: Icon(
                            index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: 45,
                            color: index < selectedRating ? const Color(0xFFFFB800) : const Color.fromARGB(255, 179, 179, 179),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Share your experience (optional)...",
                        hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFF472B6)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                        ),
                        child: Text(
                          "Submit Rating",
                          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Skip for now",
                        style: GoogleFonts.inter(
                          color: Colors.black, 
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int pendingCount = _requests.where((r) => r.tabType == "pending").length;
    int activeCount = _requests.where((r) => r.tabType == "active").length;
    int doneCount = _requests.where((r) => r.tabType == "done").length;

    List<RequestItem> filteredRequests = [];
    if (_selectedTab == 0) {
      filteredRequests = _requests.where((r) => r.tabType == "pending").toList();
    } else if (_selectedTab == 1) {
      filteredRequests = _requests.where((r) => r.tabType == "active").toList();
    } else {
      filteredRequests = _requests.where((r) => r.tabType == "done").toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Request',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your skill swaps',
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildTabItem(0, "Pending", pendingCount, const Color(0xFF7C3AED), 'images/icon-pending.png'),
                    _buildTabItem(1, "Active", activeCount, const Color(0xFFF472B6), 'images/icon-active.png'),
                    _buildTabItem(2, "Done", doneCount, const Color(0xFF06B6D4), 'images/icon-done.png'),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              ...filteredRequests.map((request) => _buildRequestCard(request)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label, int count, Color activeColor, String iconPath) {
    bool isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 18, color: isActive ? Colors.white : Colors.black87),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13, 
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? Colors.white : Colors.black87
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE54D42),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 11, 
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(RequestItem request) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(Icons.person, color: Colors.white, size: 35),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.name, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(request.date, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                  ],
                ),
              ),
              if (request.tabType == "active")
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          name: request.name,
                          image: 'images/user2.png', 
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B5CF6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 20),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFFF8F7FF), borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSkillChip(request.skill1, const Color(0xFF7C3AED)),
                        _buildSkillChip(request.skill2, const Color(0xFF06B6D4)),
                      ],
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFF472B6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Image.asset('images/icon-swap.png', width: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(request.message, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          if (request.tabType == "done")
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFF472B6)],
                ),
              ),
              child: ElevatedButton(
                onPressed: () => _showRatingDialog(context, request.name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                ),
                child: Text(
                  "Rate This Swap", 
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ),
            )
          else if (request.tabType == "active")
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    request.tabType = "done";
                    _selectedTab = 2;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                ),
                child: Text(
                  "Mark as Complete", 
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFF472B6)],
                      ),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showSuccessSnackBar(context);
                        setState(() {
                          request.tabType = "active";
                          _selectedTab = 1;
                        });
                      },
                      icon: const Icon(Icons.check, size: 20),
                      label: const Text("Accept"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _requests.remove(request);
                        });
                      },
                      icon: const Icon(Icons.close, size: 20),
                      label: const Text("Decline"),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5F3FF),
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}