import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:mob/auth_page.dart';
import 'disease_detection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_designs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  File? _image;
  final DiseaseDetection _diseaseDetection = DiseaseDetection();
  String _prediction = '';
  List<double> _confidences = [];
  final _auth = FirebaseAuth.instance;
  late AnimationController _imageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _diseaseAnimationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _diseaseScaleAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool _isPredicting = false;
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _diseaseDetection.loadModel();
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _imageAnimationController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _imageAnimationController, curve: Curves.easeOut),
    );
    _diseaseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
          parent: _diseaseAnimationController, curve: Curves.easeInOut),
    );
    _diseaseScaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
          parent: _diseaseAnimationController, curve: Curves.easeInOut),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressAnimation =
        Tween<double>(begin: 0, end: 1).animate(_progressController);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _diseaseAnimationController.dispose();
    _progressController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _imageAnimationController.forward(from: 0);
      await _predictImage();
    }
  }

  Future<void> _predictImage() async {
    if (_image == null) return;
    setState(() {
      _isPredicting = true;
      _prediction = '';
      _confidences = [];
    });
    _progressController.forward(from: 0);
    Uint8List imageBytes = await _image!.readAsBytes();
    Map<String, dynamic> result = await _diseaseDetection.predict(imageBytes);
    _progressController.stop();
    setState(() {
      _prediction = result['prediction'];
      _confidences = List<double>.from(result['confidences']);
      _isPredicting = false;
      if (_prediction != "Healthy" && _prediction != "Uncertain") {
        _diseaseAnimationController.forward();
      } else {
        _diseaseAnimationController.stop();
      }
    });
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out successfully')),
      );
    } catch (e) {
      print('Sign-out error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Select Image Source',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.green.shade700),
              title: Text('Camera', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.blue.shade700),
              title: Text('Gallery', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'About This App',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'This app helps you detect diseases in apple leaves using AI. Scan a leaf with your camera or upload an image to get a diagnosis and treatment options.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: GoogleFonts.poppins(color: Colors.green.shade700)),
          ),
        ],
      ),
    );
  }

  String _getConditionDescription(String prediction) {
    switch (prediction) {
      case 'Scab':
        return 'Apple Scab is a fungal disease causing dark, velvety spots on leaves and fruit.';
      case 'Rot':
        return 'Black Rot affects leaves and fruit, leading to dark lesions and decay.';
      case 'Rust':
        return 'Cedar-Apple Rust causes orange-yellow spots, often linked to nearby cedar trees.';
      case 'Healthy':
        return 'The leaf appears healthy with no signs of disease.';
      case 'Uncertain':
        return 'The analysis couldn’t confidently identify a condition. Try a clearer image.';
      default:
        return 'No description available for this condition.';
    }
  }

  Color _getBarColor(int index) {
    switch (index) {
      case 0: // Scab
        return Colors.red.shade600;
      case 1: // Rot
        return Colors.brown.shade600;
      case 2: // Rust
        return Colors.orange.shade600;
      case 3: // Healthy
        return Colors.green.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDiseased = _prediction != "Healthy" &&
        _prediction != "Uncertain" &&
        _prediction.isNotEmpty;

    return buildHomePage(
      context: context,
      isDiseased: isDiseased,
      tabController: _tabController,
      userName: _auth.currentUser?.displayName ?? 'Plant Doctor',
      onInfoPressed: () => _showInfoDialog(context),
      onSignOut: _signOut,
      onNewScan: () => _showImageSourceDialog(context),
      scanTab: buildScanTab(
        image: _image,
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
        isPredicting: _isPredicting,
        onImageSourceDialog: () => _showImageSourceDialog(context),
        buildActionCard: buildActionCard,
        onCameraTap: () => _pickImage(ImageSource.camera),
        onGalleryTap: () => _pickImage(ImageSource.gallery),
        onHistoryTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('History feature coming soon!')),
          );
        },
        onGuideTap: () => _showInfoDialog(context),
      ),
      resultsTab: buildResultsTab(
        isDiseased: isDiseased,
        prediction: _prediction,
        confidences: _confidences,
        context: context,
        getConditionDescription: _getConditionDescription,
        getBarColor: _getBarColor,
      ),
      bottomNavigationBar: buildBottomNavigationBar(
        buildNavItem: buildNavItem,
        onHomeTap: () => setState(() => _selectedIndex = 0),
        onHistoryTap: () => setState(() => _selectedIndex = 1),
        onProfileTap: () => setState(() => _selectedIndex = 2),
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
