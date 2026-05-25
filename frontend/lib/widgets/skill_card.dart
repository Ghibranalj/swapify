import 'package:flutter/material.dart';
import 'package:frontend/theme/admin_colors.dart';
import 'package:frontend/widgets/custom_card.dart';

class SkillCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final List<Widget> tags;
  final bool hasActionNeeded;

  const SkillCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.tags,
    this.hasActionNeeded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kotak Ikon
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15), 
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              // Judul & Tag
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.textHeading,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0, 
                      runSpacing: 4.0, 
                      children: tags,
                    ),
                  ],
                ),
              ),
              // Tombol Edit & Hapus
              const Column(
                children: [
                  Icon(Icons.edit, size: 20, color: Colors.black87),
                  SizedBox(height: 16),
                  Icon(Icons.delete_outline, size: 20, color: Colors.black87),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Deskripsi
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: AdminColors.textBody, height: 1.5),
          ),
          // Bagian "Action Needed" (Hanya muncul jika di-set true)
          if (hasActionNeeded) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.black12),
            const SizedBox(height: 8),
            const Text(
              "ACTION NEEDED",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AdminColors.primaryBlue, // Pakai biru sesuai tema
              ),
            ),
          ]
        ],
      ),
    );
  }
}