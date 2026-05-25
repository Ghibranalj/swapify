import 'package:flutter/material.dart';
import 'package:frontend/theme/admin_colors.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView( // Agar seluruh halaman bisa di-scroll
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text("Recent Alert", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text("Manage new user registrations and platform activity.", style: TextStyle(fontSize: 14, color: AdminColors.textBody)),
              const SizedBox(height: 15),
              
              // Tombol "Mark all as read"
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Mark all as read", style: TextStyle(color: Colors.black87, fontSize: 12)),
              ),
              const SizedBox(height: 20),

              // 1. Alert Card: Budi Santoso
              _buildAlertCard(
                name: "Budi Santoso",
                email: "budi@gmail.com",
                time: "Just now",
                description: "has successfully registered for a new account.",
                actionButtons: Row(
                  children: [
                    _buildSmallButton("View Profile", isOutline: true),
                    const SizedBox(width: 10),
                    _buildSmallButton("Approve"),
                  ],
                ),
              ),

              // 2. Alert Card: Budi Santoso (Skill verification)
              _buildAlertCard(
                name: "Budi Santoso",
                email: "sarah.mil@gmail.com",
                time: "2 hours ago",
                description: "is waiting for manual skill verification.",
                tags: [_buildSkillTag("SKILL : UX DESIGN")],
              ),

              // 3. Alert Card: David Chen
              _buildAlertCard(
                name: "David Chen",
                email: "david.chen.dev@outlook.com",
                time: "5 hours ago",
                description: "joined the developer community.",
              ),

              const SizedBox(height: 20),

              // KARTU GROWTH (UNGU)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AdminColors.primaryPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("GROWTH", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    const Text("+24%", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    const Text("Registrations this week", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 20),
                    // Simulasi Grafik Sederhana (Bisa diganti FL Chart nanti)
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CustomPaint(painter: _SimpleLineChartPainter()),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // KARTU ACTIVE REQUEST
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("ACTIVE REQUEST", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const Text("12", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    // User Avatars Stack
                    Row(
                      children: [
                        _buildOverlappingAvatars(),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                          child: const Text("+9", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Spasi Navbar
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Alert Card
  Widget _buildAlertCard({required String name, required String email, required String time, required String description, Widget? actionButtons, List<Widget>? tags}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(backgroundColor: Color(0xFFF5F3FF), child: Icon(Icons.person_add_alt_1, color: AdminColors.primaryPurple)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("New User Joined: $name", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(time, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                  ],
                ),
                Text("$email $description", style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
                if (tags != null) ...[const SizedBox(height: 10), ...tags],
                if (actionButtons != null) ...[const SizedBox(height: 12), actionButtons],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String text, {bool isOutline = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isOutline ? Colors.white : AdminColors.primaryPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: isOutline ? Border.all(color: AdminColors.primaryPurple) : null,
      ),
      child: Text(text, style: const TextStyle(color: AdminColors.primaryPurple, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSkillTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AdminColors.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: AdminColors.primaryBlue, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildOverlappingAvatars() {
    return SizedBox(
      width: 60,
      height: 30,
      child: Stack(
        children: [
          const CircleAvatar(radius: 12, backgroundColor: Colors.blue),
          Positioned(left: 15, child: CircleAvatar(radius: 12, backgroundColor: Colors.red.shade200)),
          Positioned(left: 30, child: CircleAvatar(radius: 12, backgroundColor: Colors.grey.shade300, child: const Icon(Icons.person, size: 15))),
        ],
      ),
    );
  }
}

// Painter Sederhana untuk Garis Chart
class _SimpleLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white38..strokeWidth = 3..style = PaintingStyle.stroke;
    var path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.8, size.width * 0.4, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.5, size.width, 0);
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
