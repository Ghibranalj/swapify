import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  static const Color bgColor = Color(0xFF1A0A35);
  static const Color featureStart = Color(0xFF7C3AED);
  static const Color featureEnd = Color(0xFF06B6D4);
  static const Color outlineEnd = Color(0xFF06B9D4);
  static const Color headerStart = Color(0xFFA172F2);
  static const Color headerEnd = Color(0xFF55D9EF);
  static const Color subtextColor = Color(0xFFBAB5C2);
  static const Color discountColor = Color(0xFF00C853);
  static const Color buttonStart = Color(0xFF7C3AED);
  static const Color buttonEnd = Color(0xFF06B9D4);

  Widget _buildGradientCircleIcon(
    String iconPath, {
    Color start = featureStart,
    Color end = featureEnd,
    double circleSize = 60,
    double iconSize = 30,
    bool tintWhite = true,
  }) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [start, end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: tintWhite
            ? Image.asset(iconPath, width: iconSize, color: Colors.white)
            : Image.asset(iconPath, width: iconSize),
      ),
    );
  }

  Widget _buildFeatureCard({required String title, required String description, required Widget icon}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [featureStart, outlineEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: subtextColor,
                      ),
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

  Widget _buildSubscriptionPackageCard({
    required String type,
    required String price,
    required List<String> perks,
    required String buttonText,
    bool isYearly = false,
    String? discount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [featureStart, outlineEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(18),
            gradient: isYearly
                ? const LinearGradient(
                    colors: [
                      Color(0x40F472B6),
                      bgColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          price,
                          style: GoogleFonts.inter(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          type == "Monthly" ? "/mo" : "/yr",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: subtextColor,
                          ),
                        ),
                      ],
                    ),
                    if (discount != null)
                      Text(
                        discount,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: discountColor,
                        ),
                      ),
                    const SizedBox(height: 20),
                    Column(
                      children: perks.map((perk) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: featureEnd, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  perk,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [buttonStart, buttonEnd],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          buttonText,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isYearly)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [featureStart, outlineEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      "BEST VALUE",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Color(0xFF231441),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [featureStart, outlineEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 25,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Column(
                        children: [
                          _buildGradientCircleIcon(
                            'images/icon-unlock.png',
                            circleSize: 90,
                            iconSize: 45,
                            tintWhite: false, 
                          ),
                          const SizedBox(height: 30),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [headerStart, headerEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: Text(
                              "Unlock More Features\nwith Premium!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Accelerate your learning journey with unlimited access, priority matching, and exclusive community perks.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: subtextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildFeatureCard(
                  title: "Unlimited Skill Swaps",
                  description: "Connect and trade skills with more people.",
                  icon: _buildGradientCircleIcon('images/icon-infinity.png', end: const Color(0xFF06B6D4)),
                ),
                _buildFeatureCard(
                  title: "Priority Matching",
                  description: "Jump to the top of the list for high-demand skills.",
                  icon: _buildGradientCircleIcon('images/icon-boost.png', end: const Color(0xFF06B6D4)),
                ),
                _buildFeatureCard(
                  title: "Edit Profile",
                  description: "Add more skills, skills to learn and certificate as much as you want.",
                  icon: _buildGradientCircleIcon('images/icon-pencil.png', end: const Color(0xFF06B6D4)),
                ),
                const SizedBox(height: 25),
                _buildSubscriptionPackageCard(
                  type: "Monthly",
                  price: "Rp175.000",
                  perks: ["All Premium Features", "Cancel anytime"],
                  buttonText: "Select Monthly",
                ),
                _buildSubscriptionPackageCard(
                  type: "Yearly",
                  price: "Rp1.550.000",
                  discount: "Save 26%",
                  perks: ["All Premium Features", "2 Months Free"],
                  buttonText: "Select Yearly",
                  isYearly: true,
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [buttonStart, buttonEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x807C3AED),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Subscribe Now",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}