import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../ai/tflite_runner.dart';

class VisionScreen extends StatefulWidget {
  const VisionScreen({super.key});
  @override State<VisionScreen> createState() => _VisionScreenState();
}

class _VisionScreenState extends State<VisionScreen> {
  final _picker = ImagePicker();
  File? _image;
  List<Map<String, dynamic>>? _results;
  final _runner = TFLiteRunner();

  @override void initState() { super.initState(); _runner.loadModel(); }

  Future<void> _pick(bool camera) async {
    final x = await (camera ? _picker.pickImage(source: ImageSource.camera) : _picker.pickImage(source: ImageSource.gallery));
    if (x == null) return;
    setState(() => _image = File(x.path));
    
    setState(() => _results = [{'label': 'Stub: Leaf Blight', 'p': 0.72}]); // placeholder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnose')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(child: ElevatedButton.icon(onPressed: () => _pick(true), icon: const Icon(Icons.camera), label: const Text('Camera'))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(onPressed: () => _pick(false), icon: const Icon(Icons.photo), label: const Text('Upload'))),
          ]),
          const SizedBox(height: 16),
          if (_image != null) Expanded(child: Image.file(_image!, fit: BoxFit.contain)),
          if (_results != null) ...[
            const SizedBox(height: 12),
            Text('Top matches: ${_results!.map((e) => "${e['label']} (${(e['p']*100).toStringAsFixed(0)}%)").join(', ')}'),
            const SizedBox(height: 8),
            const Text('Recommendation (example): Apply IPM steps first. If needed, use registered fungicide containing Mancozeb; follow label.'),
          ]
        ]),
      ),
    );
  }
}
