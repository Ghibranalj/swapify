import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

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
                child: ListView(
                  children: [
                    _buildNotificationCard(
                      icon: Icons.notifications_none_outlined,
                      iconColor: const Color(0xFFF39C12),
                      iconBgColor: const Color(0xFFFDEBD0),
                      title: 'Maya Rodriguez sent you a swap request',
                      time: '2 hours ago',
                      hasBorder: true,
                      isUnread: true,
                    ),
                    const SizedBox(height: 15),
                    _buildNotificationCard(
                      icon: Icons.notifications_none_outlined,
                      iconColor: const Color(0xFF3498DB),
                      iconBgColor: const Color(0xFFD6EAF8),
                      title: 'Jordan Kim accepted your swap request',
                      time: '1 day ago',
                      hasBorder: true,
                      isUnread: false,
                    ),
                    const SizedBox(height: 15),
                    _buildNotificationCard(
                      icon: Icons.check_circle_outline,
                      iconColor: const Color(0xFF2ECC71),
                      iconBgColor: const Color(0xFFD5F5E3),
                      title: 'Maya Rodriguez sent you a swap request',
                      time: '3 days ago',
                      hasBorder: false,
                      isUnread: false,
                    ),
                  ],
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