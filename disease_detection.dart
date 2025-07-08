import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart';

class DiseaseDetection {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/apple_leaf_disease_model.tflite');
      print('🐛 Model loaded successfully');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<Map<String, dynamic>> predict(Uint8List imageBytes) async {
    Image? image = decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    Image resizedImage = copyResize(image, width: 224, height: 224);
    print('Input image size: ${resizedImage.width}x${resizedImage.height}');

    List<List<List<List<double>>>> input = preprocessImage(resizedImage);
    print('Preprocessed input: $input');

    var output = List<double>.filled(4, 0).reshape([1, 4]);
    _interpreter.run(input, output);
    print('Model output: $output');

    return {
      'prediction': interpretOutput(output[0]),
      'confidences': output[0],
    };
  }

  List<List<List<List<double>>>> preprocessImage(Image image) {
    List<List<List<List<double>>>> input = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            Pixel pixel = image.getPixel(x, y);
            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );
    return input;
  }

  String interpretOutput(List<double> output) {
    int predictedClass = output.indexOf(output.reduce((a, b) => a > b ? a : b));
    List<String> diseases = [
      "Apple Scab",
      "Black Rot",
      "Cedar Apple Rust",
      "Healthy",
    ];

    double confidenceThreshold = 0.7;
    double maxConfidence = output[predictedClass];

    if (maxConfidence < confidenceThreshold) {
      return "Uncertain";
    }

    print('Predicted class: $predictedClass (${diseases[predictedClass]})');
    return diseases[predictedClass];
  }
}
