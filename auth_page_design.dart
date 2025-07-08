import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_animations/simple_animations.dart';

class AuthPageDesign extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final VoidCallback onGoogleSignIn;

  const AuthPageDesign({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSignIn,
    required this.onSignUp,
    required this.onGoogleSignIn,
  }) : super(key: key);

  @override
  State<AuthPageDesign> createState() => _AuthPageDesignState();
}

class _AuthPageDesignState extends State<AuthPageDesign>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _AnimatedBackground(),

          // Blurred overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and welcome text
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // App logo
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.school_rounded,
                                  size: 60,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Animated welcome text
                            AnimatedTextKit(
                              animatedTexts: [
                                FadeAnimatedText(
                                  'WELCOME TO EDU',
                                  textStyle: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                    letterSpacing: 1.5,
                                  ),
                                  duration: const Duration(seconds: 3),
                                ),
                              ],
                              isRepeatingAnimation: false,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your Learning Journey Begins Here',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Login card
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _buildLoginCard(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      shadowColor: Colors.blue.shade200,
      child: Container(
        padding: const EdgeInsets.all(28.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Login text with animation
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.blue.shade300, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Email field with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: _isEmailFocused ? Colors.white : Colors.grey.shade100,
                boxShadow: _isEmailFocused
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: TextField(
                controller: widget.emailController,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: _isEmailFocused
                        ? Colors.blue.shade700
                        : Colors.grey.shade600,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: _isEmailFocused
                        ? Colors.blue.shade700
                        : Colors.grey.shade600,
                  ),
                  filled: true,
                  fillColor:
                      _isEmailFocused ? Colors.white : Colors.grey.shade100,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (_) => HapticFeedback.lightImpact(),
              ),
            ),

            const SizedBox(height: 20),

            // Password field with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: _isPasswordFocused ? Colors.white : Colors.grey.shade100,
                boxShadow: _isPasswordFocused
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: TextField(
                controller: widget.passwordController,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: _isPasswordFocused
                        ? Colors.blue.shade700
                        : Colors.grey.shade600,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: Colors.blue.shade300, width: 2),
                  ),
                  prefixIcon: Icon(
                    Icons.lock_rounded,
                    color: _isPasswordFocused
                        ? Colors.blue.shade700
                        : Colors.grey.shade600,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: _isPasswordFocused
                          ? Colors.blue.shade700
                          : Colors.grey.shade600,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                      HapticFeedback.lightImpact();
                    },
                  ),
                  filled: true,
                  fillColor:
                      _isPasswordFocused ? Colors.white : Colors.grey.shade100,
                ),
                obscureText: _obscurePassword,
                onChanged: (_) => HapticFeedback.lightImpact(),
              ),
            ),

            const SizedBox(height: 10),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Implement forgot password functionality
                  HapticFeedback.lightImpact();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Login button or loading indicator
            if (widget.isLoading) _buildLoadingIndicator() else _buildButtons(),

            const SizedBox(height: 24),

            // Sign up text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an Account? ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onSignUp();
                    HapticFeedback.lightImpact();
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        // Login button with animation
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 1.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    widget.onSignIn();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Or sign in with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey.shade400,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR SIGN IN WITH',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey.shade400,
                thickness: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Google sign in button
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              widget.onGoogleSignIn();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: FaIcon(
              FontAwesomeIcons.google,
              color: Colors.red.shade600,
              size: 20,
            ),
            label: const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Animated background with particles
class _AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade500,
            Colors.lightBlue.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: PlasmaRenderer(
        type: PlasmaType.infinity,
        particles: 10,
        color: Colors.white.withOpacity(0.1),
        blur: 0.5,
        size: 1.0,
        speed: 1.5,
        offset: 0,
        blendMode: BlendMode.screen,
        particleType: ParticleType.atlas,
        variation1: 0.3,
        variation2: 0.5,
        variation3: 0.2,
        rotation: 0.0,
      ),
    );
  }
}

// Custom plasma renderer for animated background
class PlasmaRenderer extends StatefulWidget {
  final PlasmaType type;
  final int particles;
  final Color color;
  final double blur;
  final double size;
  final double speed;
  final double offset;
  final BlendMode blendMode;
  final ParticleType particleType;
  final double variation1;
  final double variation2;
  final double variation3;
  final double rotation;

  const PlasmaRenderer({
    Key? key,
    required this.type,
    required this.particles,
    required this.color,
    required this.blur,
    required this.size,
    required this.speed,
    required this.offset,
    required this.blendMode,
    required this.particleType,
    required this.variation1,
    required this.variation2,
    required this.variation3,
    required this.rotation,
  }) : super(key: key);

  @override
  _PlasmaRendererState createState() => _PlasmaRendererState();
}

class _PlasmaRendererState extends State<PlasmaRenderer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _PlasmaPainter(
            _controller.value,
            widget.particles,
            widget.color,
            widget.blur,
            widget.size,
            widget.variation1,
            widget.variation2,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _PlasmaPainter extends CustomPainter {
  final double progress;
  final int particles;
  final Color color;
  final double blur;
  final double size;
  final double variation1;
  final double variation2;

  _PlasmaPainter(
    this.progress,
    this.particles,
    this.color,
    this.blur,
    this.size,
    this.variation1,
    this.variation2,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur * 10);

    for (int i = 0; i < particles; i++) {
      final x = size.width *
          (0.2 + 0.6 * ((i / particles) + variation1 * progress) % 1);
      final y = size.height *
          (0.2 + 0.6 * ((i / particles) + variation2 * (1 - progress)) % 1);
      final radius = size.width *
          0.05 *
          this.size *
          (0.5 + 0.5 * sin(progress * 2 * 3.14159));

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_PlasmaPainter oldDelegate) => true;
}

enum PlasmaType { infinity, bubbles, circle }

enum ParticleType { circle, square, atlas }
