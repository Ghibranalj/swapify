import 'package:flutter/material.dart';
import 'package:frontend/theme/admin_colors.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String status; // 'Active' atau 'Pending'
  final List<Widget> tags;
  final Widget leftButton;
  final Widget rightButton;
  final bool isHighlighted; // Untuk border ungu khusus (Marcus Chen)

  const UserCard({
    Key? key,
    required this.name,
    required this.email,
    required this.status,
    required this.tags,
    required this.leftButton,
    required this.rightButton,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menentukan warna status
    final bool isActive = status == 'Active';
    final Color statusBgColor = isActive ? AdminColors.accentGreen.withOpacity(0.2) : AdminColors.accentPink.withOpacity(0.2);
    final Color statusTextColor = isActive ? Colors.green.shade700 : AdminColors.accentPink;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        // Tambahkan border ungu jika isHighlighted true
        border: isHighlighted ? Border.all(color: AdminColors.primaryPurple, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 24,
                child: const Icon(Icons.person_outline, color: Colors.black54, size: 28),
              ),
              const SizedBox(width: 12),
              // Nama & Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AdminColors.textHeading),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 12, color: AdminColors.textBody),
                    ),
                  ],
                ),
              ),
              // Status Tag (Active / Pending)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusTextColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Skill Tags
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: tags,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 16),
          // Baris Tombol Aksi
          Row(
            children: [
              Expanded(child: leftButton),
              const SizedBox(width: 12),
              Expanded(child: rightButton),
            ],
          )
        ],
      ),
    );
  }
}