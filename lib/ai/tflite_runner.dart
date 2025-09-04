// lib/ai/tflite_runner.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img_pkg;
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteRunner {
  Interpreter? _interpreter;
  List<String> labels = [];
  int inputSize = 224;
  bool isQuantized = false;

  Future<void> loadModel({
    String modelPath = 'assets/models/plant_v1.tflite',
    String labelsPath = 'assets/models/plant_labels.txt',
  }) async {
    try {
      final interpreterOptions = InterpreterOptions()..threads = 4;
      _interpreter = await Interpreter.fromAsset(modelPath, options: interpreterOptions);

      final labelsData = await rootBundle.loadString(labelsPath);
      labels = labelsData.split('\n').where((s) => s.trim().isNotEmpty).toList();

      final inputTensors = _interpreter!.getInputTensors();
      final t = inputTensors[0];
      final shape = t.shape; // e.g., [1,224,224,3]
      if (shape.length >= 3) {
        inputSize = shape[1];
      }
      isQuantized = t.type == TensorType.uint8;
      debugPrint('Model loaded. inputSize=$inputSize quantized=$isQuantized labels=${labels.length}');
    } catch (e) {
      // If model missing or fails to load, we keep interpreter null and code will fallback
      debugPrint('TFLite load failed: $e');
      _interpreter = null;
    }
  }

  Future<List<Map<String, dynamic>>> predict(File imageFile) async {
    if (_interpreter == null) {
      // Fallback stub (useful when you don't have a model yet)
      return [
        {'label': labels.isNotEmpty ? labels[0] : 'Healthy leaf', 'prob': 0.75},
        {'label': labels.length > 1 ? labels[1] : 'Leaf blight', 'prob': 0.15},
        {'label': labels.length > 2 ? labels[2] : 'Rust', 'prob': 0.10},
      ];
    }

    final bytes = await imageFile.readAsBytes();
    final image = img_pkg.decodeImage(bytes)!;
    final resized = img_pkg.copyResize(image, width: inputSize, height: inputSize);

    dynamic input;
    if (isQuantized) {
      input = List.generate(1, (_) => List.generate(inputSize, (_) => List.generate(inputSize, (_) => List.generate(3, (_) => 0))));
      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          final pixel = resized.getPixel(x, y);
          
          input[0][y][x][0] = pixel.r;
          input[0][y][x][1] = pixel.g;
          input[0][y][x][2] = pixel.b;
        }
      }
    } else {
      input = List.generate(1, (_) => List.generate(inputSize, (_) => List.generate(inputSize, (_) => List.generate(3, (_) => 0.0))));
      for (var y = 0; y < inputSize; y++) {
        for (var x = 0; x < inputSize; x++) {
          final pixel = resized.getPixel(x, y);
          
          input[0][y][x][0] = (pixel.r / 127.5) - 1.0;
          input[0][y][x][1] = (pixel.g / 127.5) - 1.0;
          input[0][y][x][2] = (pixel.b / 127.5) - 1.0;
        }
      }
    }

    final output = List.filled(1, List.filled(labels.length, 0.0));
    _interpreter!.run(input, output);

    final probs = (output[0] as List).map((e) => (e as num).toDouble()).toList();
    final predictions = <Map<String, dynamic>>[];
    for (var i = 0; i < labels.length; i++) {
      predictions.add({'label': labels[i], 'prob': probs[i]});
    }
    predictions.sort((a, b) => (b['prob'] as double).compareTo(a['prob'] as double));
    return predictions.take(5).toList();
  }
}
