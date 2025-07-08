import 'package:flutter/material.dart';
import 'dart:math' as math;

class CurePageDesign extends StatefulWidget {
  final String disease;
  final String cureText;
  final VoidCallback onBackPressed;

  const CurePageDesign({
    Key? key,
    required this.disease,
    required this.cureText,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  State<CurePageDesign> createState() => _CurePageDesignState();
}

class _CurePageDesignState extends State<CurePageDesign>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Cure Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: widget.onBackPressed,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF43A047), Color(0xFF1E88E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated plant decorations
              Positioned(
                top: 20,
                right: -30,
                child: AnimatedPlant(controller: _controller),
              ),
              Positioned(
                bottom: -20,
                left: -40,
                child: AnimatedPlant(
                  controller: _controller,
                  reverse: true,
                  scale: 0.8,
                ),
              ),

              // Main content
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Disease illustration
                          Container(
                            height: 180,
                            width: 180,
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: DiseaseIllustration(
                                diseaseName: widget.disease,
                                controller: _controller,
                              ),
                            ),
                          ),

                          // Main card with cure information
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cure for ${widget.disease}',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                  const Divider(
                                    color: Color(0xFFE0F2F1),
                                    thickness: 2,
                                    height: 32,
                                  ),
                                  const Text(
                                    'TREATMENT DETAILS',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF78909C),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.cureText,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 1.6,
                                      color: Color(0xFF37474F),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'IMPORTANT NOTES',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF78909C),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const InfoBulletPoint(
                                    text:
                                        'Always consult with a healthcare professional',
                                    icon: Icons.medical_services_outlined,
                                  ),
                                  const SizedBox(height: 8),
                                  const InfoBulletPoint(
                                    text:
                                        'Follow the prescribed dosage carefully',
                                    icon: Icons.schedule,
                                  ),
                                  const SizedBox(height: 8),
                                  const InfoBulletPoint(
                                    text: 'Report any side effects immediately',
                                    icon: Icons.warning_amber_rounded,
                                  ),
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: widget.onBackPressed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF00897B),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: const Text(
                                        'Back to Home',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
}

// Component for animated plant decoration
class AnimatedPlant extends StatelessWidget {
  final AnimationController controller;
  final bool reverse;
  final double scale;

  const AnimatedPlant({
    Key? key,
    required this.controller,
    this.reverse = false,
    this.scale = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final swayValue = math.sin(controller.value * math.pi * 2) * 0.05;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateZ(reverse ? -swayValue : swayValue)
            ..scale(scale),
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: 0.7,
            child: SizedBox(
              height: 200,
              width: 150,
              child: CustomPaint(
                painter: PlantPainter(),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom painter for plant decoration
class PlantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF81C784)
      ..style = PaintingStyle.fill;

    // Draw stem
    final stemPath = Path()
      ..moveTo(size.width * 0.5, size.height)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.7,
          size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.55, size.height * 0.3,
          size.width * 0.5, size.height * 0.1);

    canvas.drawPath(stemPath, paint);

    // Draw leaves
    final leafPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    // Left leaves
    drawLeaf(canvas, size, 0.5, 0.7, 0.2, 0.6, leafPaint);
    drawLeaf(canvas, size, 0.5, 0.5, 0.15, 0.4, leafPaint);
    drawLeaf(canvas, size, 0.5, 0.3, 0.25, 0.2, leafPaint);

    // Right leaves
    drawLeaf(canvas, size, 0.5, 0.6, 0.8, 0.5, leafPaint, true);
    drawLeaf(canvas, size, 0.5, 0.4, 0.85, 0.3, leafPaint, true);
    drawLeaf(canvas, size, 0.5, 0.2, 0.75, 0.1, leafPaint, true);
  }

  void drawLeaf(Canvas canvas, Size size, double startX, double startY,
      double endX, double endY, Paint paint,
      [bool rightSide = false]) {
    final leafPath = Path()
      ..moveTo(size.width * startX, size.height * startY)
      ..quadraticBezierTo(
          size.width * (rightSide ? 0.7 : 0.3),
          size.height * (startY + endY) * 0.5,
          size.width * endX,
          size.height * endY)
      ..quadraticBezierTo(
          size.width * (rightSide ? 0.6 : 0.4),
          size.height * (startY + endY) * 0.5 + 10,
          size.width * startX,
          size.height * startY);

    canvas.drawPath(leafPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Component for disease illustration
class DiseaseIllustration extends StatelessWidget {
  final String diseaseName;
  final AnimationController controller;

  const DiseaseIllustration({
    Key? key,
    required this.diseaseName,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: DiseasePainter(
            animation: controller.value,
            diseaseName: diseaseName,
          ),
        );
      },
    );
  }
}

// Custom painter for disease illustration
class DiseasePainter extends CustomPainter {
  final double animation;
  final String diseaseName;

  DiseasePainter({required this.animation, required this.diseaseName});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.4;

    // Draw plant cell
    final cellPaint = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, cellPaint);

    // Draw cell membrane
    final membranePaint = Paint()
      ..color = const Color(0xFF81C784)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, membranePaint);

    // Draw nucleus
    final nucleusPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx, center.dy - radius * 0.2),
        radius * 0.25, nucleusPaint);

    // Draw disease elements (animated)
    final diseasePaint = Paint()
      ..color = const Color(0xFFEF5350)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final angle = (i / 5) * 2 * math.pi + animation * math.pi;
      final distance =
          radius * 0.6 * (0.8 + 0.2 * math.sin(animation * math.pi * 2 + i));
      final position = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      canvas.drawCircle(position, radius * 0.12, diseasePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Component for info bullet points
class InfoBulletPoint extends StatelessWidget {
  final String text;
  final IconData icon;

  const InfoBulletPoint({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF00897B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF455A64),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
