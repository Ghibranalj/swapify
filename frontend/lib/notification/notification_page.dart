import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_model.dart';
import 'package:frontend/services/api_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchNotifications();
  }

  String _getRelativeTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      if (isoString.contains('ago') || isoString.contains('now')) {
        return isoString;
      }
      final parsedDate = DateTime.parse(isoString);
      final diff = DateTime.now().difference(parsedDate);
      if (diff.inDays >= 7) {
        return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
      } else if (diff.inDays >= 1) {
        return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
      } else if (diff.inHours >= 1) {
        return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
      } else if (diff.inMinutes >= 1) {
        return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (_) {
      return isoString;
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final data = await ApiService().getNotifications();
      return data.map<NotificationModel>((n) {
        final type = n['type'] as String? ?? 'info';
        IconData icon;
        Color iconColor;
        Color iconBgColor;

        if (type.contains('accepted') || type.contains('complete')) {
          icon = Icons.check_circle_outline;
          iconColor = const Color(0xFF2ECC71);
          iconBgColor = const Color(0xFFD5F5E3);
        } else if (type.contains('declined') || type.contains('cancel')) {
          icon = Icons.cancel_outlined;
          iconColor = const Color(0xFFE74C3C);
          iconBgColor = const Color(0xFFFDEDEC);
        } else if (type.contains('message')) {
          icon = Icons.chat_bubble_outline;
          iconColor = const Color(0xFF3498DB);
          iconBgColor = const Color(0xFFD6EAF8);
        } else {
          icon = Icons.notifications_none_outlined;
          iconColor = const Color(0xFFF39C12);
          iconBgColor = const Color(0xFFFDEBD0);
        }

        final createdAt = n['createdAt']?.toString() ?? '';
        final timeLabel = _getRelativeTime(createdAt);
        final isUnread = !(n['isRead'] as bool? ?? false);

        return NotificationModel(
          icon: icon,
          iconColor: iconColor,
          iconBgColor: iconBgColor,
          title: n['message'] ?? n['title'] ?? 'New notification',
          time: timeLabel,
          hasBorder: isUnread,
          isUnread: isUnread,
        );
      }).toList();
    } catch (_) {
      // fallback to empty
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Notifications',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Stay updated with your swaps',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: FutureBuilder<List<NotificationModel>>(
                  future: _notificationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)));
                    } 
                    else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } 
                    else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No notifications yet.'));
                    }
                    final notifications = snapshot.data!;

                    return ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final data = notifications[index];
                        return _buildNotificationCard(
                          icon: data.icon,
                          iconColor: data.iconColor,
                          iconBgColor: data.iconBgColor,
                          title: data.title,
                          time: data.time,
                          hasBorder: data.hasBorder,
                          isUnread: data.isUnread,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String time,
    required bool hasBorder,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: hasBorder 
            ? Border.all(color: const Color(0xFF7C3AED), width: 1.5) 
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isUnread)
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: CircleAvatar(
                radius: 4,
                backgroundColor: Color(0xFF7C3AED),
              ),
            ),
        ],
      ),
    );
  }
}