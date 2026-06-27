import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/api_config.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String image;
  final String swapRequestId;

  const ChatPage({
    super.key,
    required this.name,
    required this.image,
    this.swapRequestId = '',
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessageModel> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    if (widget.swapRequestId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final msgs = await ApiService().getMessages(widget.swapRequestId);
      final myId = ApiService().currentUser?['id'];
      setState(() {
        _messages = msgs.map((m) {
          return ChatMessageModel(
            id: m['id'] ?? '',
            text: m['content'] ?? '',
            isSender: m['senderId'] == myId,
          );
        }).toList();
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.swapRequestId.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(ChatMessageModel(id: 'temp', text: text, isSender: true));
      _isSending = true;
    });
    _scrollToBottom();

    try {
      await ApiService().sendMessage(widget.swapRequestId, text);
      _isSending = false;
    } catch (e) {
      setState(() => _isSending = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: ${e.toString()}')),
        );
      }
    }
  }

  ImageProvider _getAvatarImage() {
    final img = widget.image;
    if (img.startsWith('http')) return NetworkImage(img);
    if (img.isNotEmpty) {
      try {
        return AssetImage(img);
      } catch (_) {}
    }
    return const AssetImage('images/user1.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      body: Column(
        children: [
          // App Bar
          Container(
            padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: _getAvatarImage(),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ECC71),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Active Now', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(hoverColor: Colors.transparent, splashColor: Colors.transparent),
                  child: PopupMenuButton<String>(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                      child: const Icon(Icons.more_vert, color: Colors.white),
                    ),
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    offset: const Offset(0, 55),
                    constraints: const BoxConstraints(maxWidth: 180),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'refresh',
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Refresh', style: GoogleFonts.inter(color: Colors.black87, fontSize: 14)),
                            const Icon(Icons.refresh, color: Colors.black87, size: 20),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (val) {
                      if (val == 'refresh') _loadMessages();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
                : _messages.isEmpty
                    ? Center(
                        child: Text(
                          widget.swapRequestId.isEmpty
                              ? 'Chat unavailable. No swap request ID.'
                              : 'No messages yet. Say hi!',
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          if (msg.isSender) {
                            return _buildSenderChat(msg.text);
                          } else {
                            return _buildReceiverChat(msg.text);
                          }
                        },
                      ),
          ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey.shade300, shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.grey, size: 30),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFFEC4899)]),
                      shape: BoxShape.circle,
                    ),
                    child: _isSending
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildAttachmentItem(String title, IconData icon) {
    return PopupMenuItem(
      value: title.toLowerCase(),
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
          Icon(icon, color: Colors.black, size: 26),
        ],
      ),
    );
  }

  Widget _buildReceiverChat(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundImage: _getAvatarImage()),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(message, style: GoogleFonts.inter(color: Colors.black87, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildSenderChat(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 40),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Text(message, style: GoogleFonts.inter(color: Colors.white, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 18,
            backgroundImage: ApiService().currentUser?['profileImageUrl'] != null
                ? NetworkImage('${ApiConfig.url}${ApiService().currentUser!['profileImageUrl']}') as ImageProvider
                : const AssetImage('images/user1.png'),
          ),
        ],
      ),
    );
  }
}