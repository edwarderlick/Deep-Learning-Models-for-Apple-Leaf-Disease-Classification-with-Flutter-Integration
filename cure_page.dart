import 'package:flutter/material.dart';
import 'cure_page_design.dart';

class CurePage extends StatelessWidget {
  final String disease;

  const CurePage({Key? key, required this.disease}) : super(key: key);

  // Define cures for each disease
  String _getCure(String disease) {
    switch (disease) {
      case 'Apple Scab':
        return '''
**Cure for Apple Scab:**
1. Prune infected branches and leaves.
2. Apply fungicides like sulfur or copper-based sprays.
3. Ensure proper air circulation around the tree.
4. Remove fallen leaves and debris to prevent reinfection.
''';
      case 'Black Rot':
        return '''
**Cure for Black Rot:**
1. Remove and destroy infected fruits and branches.
2. Apply fungicides like captan or myclobutanil.
3. Avoid overhead watering to reduce humidity.
4. Maintain proper spacing between trees for air circulation.
''';
      case 'Cedar Apple Rust':
        return '''
**Cure for Cedar Apple Rust:**
1. Remove nearby cedar trees if possible.
2. Apply fungicides like myclobutanil or triadimefon.
3. Prune infected branches and leaves.
4. Ensure proper drainage to avoid waterlogging.
''';
      case 'Healthy':
        return '''
**Your plant is healthy!**
No cure is needed. Continue regular care and monitoring.
''';
      default:
        return '''
**No cure information available for this disease.**
Please consult an expert for further assistance.
''';
    }
  }

  void _onBackPressed(BuildContext context) {
    Navigator.pop(context); // Go back to the HomePage
  }

  @override
  Widget build(BuildContext context) {
    return CurePageDesign(
      disease: disease,
      cureText: _getCure(disease),
      onBackPressed: () => _onBackPressed(context),
    );
  }
}
