import 'dart:io';
import 'dart:ui' as ui; // Added this import for ImageFilter

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'cure_page.dart';

// Main build method for HomePage
Widget buildHomePage({
  required BuildContext context,
  required bool isDiseased,
  required TabController tabController,
  required String userName,
  required VoidCallback onInfoPressed,
  required VoidCallback onSignOut,
  required VoidCallback onNewScan,
  required Widget scanTab,
  required Widget resultsTab,
  required Widget bottomNavigationBar,
}) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter:
              ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Added 'ui.' prefix
          child: Container(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ),
      title: Text(
        'Leaf Disease Detection',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: onInfoPressed,
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: onSignOut,
        ),
      ],
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade700,
            Colors.green.shade500,
            Colors.teal.shade400,
            Colors.blue.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Welcome section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.eco,
                      color: Colors.green.shade700,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tab bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  labelColor: Colors.green.shade700,
                  unselectedLabelColor: Colors.white,
                  tabs: const [
                    // Made this const since all children are const
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt),
                          SizedBox(width: 8),
                          Text('Scan'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.analytics),
                          SizedBox(width: 8),
                          Text('Results'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  scanTab,
                  resultsTab,
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: onNewScan,
      backgroundColor: Colors.white,
      foregroundColor: Colors.green.shade700,
      elevation: 4,
      icon: const Icon(Icons.add_a_photo),
      label: Text(
        'New Scan',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
    ),
    bottomNavigationBar: bottomNavigationBar,
  );
}

// ... rest of your code remains the same ...
// Scan Tab UI
Widget buildScanTab({
  required File? image,
  required Animation<double> fadeAnimation,
  required Animation<double> scaleAnimation,
  required bool isPredicting,
  required VoidCallback onImageSourceDialog,
  required Widget Function({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) buildActionCard,
  required VoidCallback onCameraTap,
  required VoidCallback onGalleryTap,
  required VoidCallback onHistoryTap,
  required VoidCallback onGuideTap,
}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scan Leaf',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Take or upload a photo of an apple leaf to detect diseases',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: image == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/leaf_animation.json',
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No image selected',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: onImageSourceDialog,
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Add Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      FadeTransition(
                        opacity: fadeAnimation,
                        child: ScaleTransition(
                          scale: scaleAnimation,
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (isPredicting)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Lottie.asset(
                                  'assets/scanning_animation.json',
                                  height: 120,
                                  width: 120,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Analyzing leaf...',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.7),
                          child: IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.green.shade700,
                            ),
                            onPressed: onImageSourceDialog,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: buildActionCard(
                icon: Icons.camera_alt,
                title: 'Camera',
                subtitle: 'Take a photo',
                color: Colors.green.shade600,
                onTap: onCameraTap,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: buildActionCard(
                icon: Icons.photo_library,
                title: 'Gallery',
                subtitle: 'Choose from gallery',
                color: Colors.blue.shade600,
                onTap: onGalleryTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: buildActionCard(
                icon: Icons.history,
                title: 'History',
                subtitle: 'View past scans',
                color: Colors.orange.shade600,
                onTap: onHistoryTap,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: buildActionCard(
                icon: Icons.help_outline,
                title: 'Guide',
                subtitle: 'How to use',
                color: Colors.purple.shade600,
                onTap: onGuideTap,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Results Tab UI
Widget buildResultsTab({
  required bool isDiseased,
  required String prediction,
  required List<double> confidences,
  required BuildContext context,
  required String Function(String) getConditionDescription,
  required Color Function(int) getBarColor,
}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Results',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          prediction.isEmpty
              ? 'No analysis results yet. Scan a leaf to get started.'
              : 'Detailed analysis of your leaf scan',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 20),
        if (prediction.isEmpty)
          Center(
            child: Column(
              children: [
                Lottie.asset(
                  'assets/empty_results.json',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  'No Results Yet',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Scan a leaf to see analysis results here',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDiseased
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isDiseased
                                  ? Icons.warning_amber_rounded
                                  : Icons.check_circle_outline,
                              color: isDiseased
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Diagnosis',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  prediction,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isDiseased
                                        ? Colors.red.shade700
                                        : Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Condition Description',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        getConditionDescription(prediction),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (isDiseased)
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CurePage(disease: prediction),
                              ),
                            );
                          },
                          icon: const Icon(Icons.healing),
                          label: Text(
                            'Treatment Options',
                            style: GoogleFonts.poppins(),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (confidences.isNotEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confidence Levels',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Probability of each condition',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 250,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 100,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (_) =>
                                      Colors.blueGrey.shade800,
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    List<String> labels = [
                                      "Scab",
                                      "Rot",
                                      "Rust",
                                      "Healthy"
                                    ];
                                    return BarTooltipItem(
                                      '${labels[group.x.toInt()]}\n${rod.toY.toStringAsFixed(1)}%',
                                      GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      List<String> labels = [
                                        "Scab",
                                        "Rot",
                                        "Rust",
                                        "Healthy"
                                      ];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          labels[value.toInt()],
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                    reservedSize: 30,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}%',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                    reservedSize: 40,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                horizontalInterval: 20,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.shade200,
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: confidences
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => BarChartGroupData(
                                      x: e.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e.value * 100,
                                          color: getBarColor(e.key),
                                          width: 22,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(6),
                                            topRight: Radius.circular(6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
      ],
    ),
  );
}

// Action Card UI
Widget buildActionCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ),
  );
}

// Bottom Navigation Bar UI
Widget buildBottomNavigationBar({
  required Widget Function({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) buildNavItem,
  required VoidCallback onHomeTap,
  required VoidCallback onHistoryTap,
  required VoidCallback onProfileTap,
  required int selectedIndex,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ],
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isSelected: selectedIndex == 0,
              onTap: onHomeTap,
            ),
            buildNavItem(
              icon: Icons.history,
              label: 'History',
              isSelected: selectedIndex == 1,
              onTap: onHistoryTap,
            ),
            const SizedBox(width: 50), // Space for FAB
            buildNavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              isSelected: selectedIndex == 2,
              onTap: onProfileTap,
            ),
          ],
        ),
      ),
    ),
  );
}

// Navigation Item UI
Widget buildNavItem({
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.green.shade700 : Colors.grey.shade600,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.green.shade700 : Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}
