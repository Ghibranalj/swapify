import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/message/chat_page.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int _selectedTab = 0;
  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService().getSwapRequests();
      setState(() {
        _requests = data.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load requests: ${e.toString()}')),
        );
      }
    }
  }

  String _statusForTab(int tab) {
    switch (tab) {
      case 0:
        return 'pending';
      case 1:
        return 'active';
      case 2:
        return 'done';
      default:
        return 'pending';
    }
  }

  void _showSuccessSnackBar(BuildContext context, String msg) {
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
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF008A33), size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  msg,
                  style: GoogleFonts.inter(color: const Color(0xFF008A33), fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showRatingDialog(BuildContext context, Map<String, dynamic> request) {
    int selectedRating = 0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final otherName = _getOtherName(request);
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
                    Text("Rate Your Experience", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("How was your swap with $otherName?", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () => setDialogState(() => selectedRating = index + 1),
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
                      controller: commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Share your experience (optional)...",
                        hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[300]!)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF8B5CF6))),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFF472B6)]),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (selectedRating > 0) {
                            try {
                              await ApiService().rateSwapRequest(
                                request['id'],
                                rating: selectedRating,
                                comment: commentController.text.trim(),
                              );
                            } catch (_) {}
                          }
                          if (context.mounted) Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
                        child: Text("Submit Rating", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Skip for now", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
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

  String _getOtherName(Map<String, dynamic> request) {
    final myId = ApiService().currentUser?['id'];
    final requesterId = request['requesterId'] ?? request['requester']?['id'];
    if (requesterId == myId) {
      return request['provider']?['name'] ?? 'Unknown';
    }
    return request['requester']?['name'] ?? 'Unknown';
  }

  String _getOtherSwapRequestId(Map<String, dynamic> request) {
    return request['id'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final statusLabel = _statusForTab(_selectedTab);
    final filteredRequests = _requests.where((r) => (r['status'] ?? r['tabType']) == statusLabel).toList();
    final pendingCount = _requests.where((r) => (r['status'] ?? r['tabType']) == 'pending').length;
    final activeCount = _requests.where((r) => (r['status'] ?? r['tabType']) == 'active').length;
    final doneCount = _requests.where((r) => (r['status'] ?? r['tabType']) == 'done').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
            : RefreshIndicator(
                onRefresh: _loadRequests,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Request', style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black)),
                      const SizedBox(height: 4),
                      Text('Manage your skill swaps', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600])),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
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
                      if (filteredRequests.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text('No ${statusLabel} requests.', style: GoogleFonts.inter(color: Colors.grey)),
                          ),
                        )
                      else
                        ...filteredRequests.map((request) => _buildRequestCard(request)).toList(),
                    ],
                  ),
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
          decoration: BoxDecoration(color: isActive ? activeColor : Colors.transparent, borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, width: 18, color: isActive ? Colors.white : Colors.black87, errorBuilder: (c, e, s) => Icon(Icons.circle, size: 18, color: isActive ? Colors.white : Colors.black87)),
              const SizedBox(width: 4),
              Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? Colors.white : Colors.black87)),
              const SizedBox(width: 4),
              Container(
                width: 22, height: 22, alignment: Alignment.center,
                decoration: const BoxDecoration(color: Color(0xFFE54D42), shape: BoxShape.circle),
                child: Text(count.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, height: 1.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    final myId = ApiService().currentUser?['id'];
    final isRequester = (request['requesterId'] ?? request['requester']?['id']) == myId;
    final otherName = isRequester ? (request['provider']?['name'] ?? 'Unknown') : (request['requester']?['name'] ?? 'Unknown');
    final mySkill = isRequester ? (request['requesterSkill']?['name'] ?? request['requesterSkillId'] ?? 'My Skill') : (request['providerSkill']?['name'] ?? request['providerSkillId'] ?? 'My Skill');
    final theirSkill = isRequester ? (request['providerSkill']?['name'] ?? request['providerSkillId'] ?? 'Their Skill') : (request['requesterSkill']?['name'] ?? request['requesterSkillId'] ?? 'Their Skill');
    final dateStr = request['createdAt'] != null ? request['createdAt'].toString().substring(0, 10) : '';
    final messageText = request['message'] ?? 'Skill swap request';
    final status = (request['status'] ?? request['tabType'] ?? '') as String;
    final swapId = request['id'] as String;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 28, backgroundColor: Color(0xFFE0E0E0), child: Icon(Icons.person, color: Colors.white, size: 35)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(otherName, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(dateStr, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500])),
                  ],
                ),
              ),
              if (status == 'active')
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(name: otherName, image: 'images/user2.png', swapRequestId: swapId)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFF8B5CF6), shape: BoxShape.circle),
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
                        _buildSkillChip(mySkill, const Color(0xFF7C3AED)),
                        _buildSkillChip(theirSkill, const Color(0xFF06B6D4)),
                      ],
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFF472B6)], begin: Alignment.centerLeft, end: Alignment.centerRight).createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Image.asset('images/icon-swap.png', width: 24, errorBuilder: (c, e, s) => const Icon(Icons.swap_horiz, size: 24)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(messageText, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 15),
          if (status == 'done')
            Container(
              width: double.infinity, height: 55,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFFF472B6)])),
              child: ElevatedButton(
                onPressed: () => _showRatingDialog(context, request),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
                child: Text("Rate This Swap", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          else if (status == 'active')
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await ApiService().completeSwapRequest(swapId);
                    _showSuccessSnackBar(context, 'Swap marked as complete!');
                    await _loadRequests();
                    setState(() => _selectedTab = 2);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF06B6D4), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35))),
                child: Text("Mark as Complete", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          else if (status == 'pending')
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFF472B6)])),
                    child: ElevatedButton.icon(
                      onPressed: !isRequester ? () async {
                        try {
                          await ApiService().acceptSwapRequest(swapId);
                          _showSuccessSnackBar(context, 'Request accepted!');
                          await _loadRequests();
                          setState(() => _selectedTab = 1);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                        }
                      } : null,
                      icon: const Icon(Icons.check, size: 20),
                      label: const Text("Accept"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)), textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          if (isRequester) {
                            await ApiService().cancelSwapRequest(swapId);
                          } else {
                            await ApiService().declineSwapRequest(swapId);
                          }
                          await _loadRequests();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                        }
                      },
                      icon: const Icon(Icons.close, size: 20),
                      label: Text(isRequester ? "Cancel" : "Decline"),
                      style: OutlinedButton.styleFrom(backgroundColor: const Color(0xFFF5F3FF), foregroundColor: Colors.black, side: BorderSide(color: Colors.grey[300]!, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)), textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
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