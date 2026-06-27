import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_model.dart';
import 'chat_page.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/api_config.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late Future<List<ChatThreadModel>> _chatThreadsFuture;

  @override
  void initState() {
    super.initState();
    _chatThreadsFuture = fetchChatThreads();
  }

  Future<List<ChatThreadModel>> fetchChatThreads() async {
    final rawThreads = await ApiService().getThreads();
    final myId = ApiService().currentUser?['id'];
    return rawThreads.map((t) {
      final swapRequest = t['swapRequest'] as Map<String, dynamic>? ?? t;
      final swapId = swapRequest['id'] ?? t['swapRequestId'] ?? '';
      final isRequester = (swapRequest['requesterId'] ?? swapRequest['requester']?['id']) == myId;
      final other = isRequester
          ? (swapRequest['provider'] ?? {})
          : (swapRequest['requester'] ?? {});
      final otherName = other['name'] ?? t['name'] ?? 'Unknown';
      final imageUrl = (other['profileImageUrl'] ?? t['image'] ?? '') as String;
      final lastMsg = (t['lastMessage'] is Map)
          ? (t['lastMessage']['content'] ?? 'No messages yet')
          : (t['lastMessage'] ?? t['content'] ?? 'No messages yet');
      final updatedAt = t['updatedAt']?.toString() ?? '';
      final timeLabel = updatedAt.isNotEmpty ? updatedAt.substring(0, 10) : '';
      final unread = (t['unreadCount'] ?? 0).toString();
      return ChatThreadModel(
        id: swapId,
        name: otherName,
        lastMessage: lastMsg,
        time: timeLabel,
        image: imageUrl.isNotEmpty ? '${ApiConfig.url}$imageUrl' : '',
        unreadCount: unread,
        isOnline: false,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Messages',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        color: Colors.white.withOpacity(0.9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        offset: const Offset(0, 50),
                        constraints: const BoxConstraints(maxWidth: 220),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'read',
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Read All',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF7C3AED),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(Icons.mark_as_unread_outlined, color: Color(0xFF7C3AED), size: 18),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(height: 1),
                          PopupMenuItem(
                            value: 'delete',
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delete all conversation',
                                  style: GoogleFonts.inter(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search, color: Colors.white),
                      hintText: 'Search for skills or people...',
                      hintStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ChatThreadModel>>(
              future: _chatThreadsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final threads = snapshot.data!;

                return ListView.separated(
                  padding: const EdgeInsets.all(25),
                  itemCount: threads.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final chat = threads[index];
                    return _buildChatTile(
                      context,
                      thread: chat,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(
    BuildContext context, {
    required ChatThreadModel thread,
  }) {
    final image = thread.image;
    final isNetworkImage = image.startsWith('http');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              name: thread.name,
              image: image,
              swapRequestId: thread.id,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: isNetworkImage
                      ? NetworkImage(image) as ImageProvider
                      : (image.isNotEmpty
                          ? AssetImage(image) as ImageProvider
                          : const AssetImage('images/user1.png')),
                ),
                if (thread.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
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
                  Text(thread.name, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(thread.lastMessage, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(thread.time, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Color(0xFFEC4899), shape: BoxShape.circle),
                  child: Text(thread.unreadCount, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}