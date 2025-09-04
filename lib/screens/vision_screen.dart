// lib/screens/vision_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../ai/tflite_runner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VisionScreen extends StatefulWidget {
  const VisionScreen({super.key});
  @override
  State<VisionScreen> createState() => _VisionScreenState();
}

class _VisionScreenState extends State<VisionScreen> {
  File? _image;
  final _picker = ImagePicker();
  final _runner = TFLiteRunner();
  List<Map<String, dynamic>>? _predictions;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    await _runner.loadModel();
  }

  Future<void> _pickImage(ImageSource src) async {
    final x = await _picker.pickImage(source: src, maxWidth: 1600);
    if (x == null) return;
    setState(() {
      _image = File(x.path);
      _predictions = null;
    });
    await _runPredict();
  }

  Future<void> _runPredict() async {
    if (_image == null) return;
    setState(() => _loading = true);
    final preds = await _runner.predict(_image!);
    setState(() {
      _predictions = preds;
      _loading = false;
    });
  }

  Future<void> _saveToSupabase() async {
    if (_image == null || _predictions == null) return;

    try {
      final fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}';
      final bytes = _image!.readAsBytesSync();
      await Supabase.instance.client.storage.from('uploads').uploadBinary(fileName, bytes);
      final publicUrl = Supabase.instance.client.storage.from('uploads').getPublicUrl(fileName);

      await Supabase.instance.client.from('diagnoses').insert({
        'user_id': Supabase.instance.client.auth.currentUser?.id,
        'type': 'plant',
        'images': [publicUrl],
        'topk': _predictions,
        'recommendation': 'Example recommendation - please verify with local expert',
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to server')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnose (Camera/Upload)')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: ElevatedButton.icon(onPressed: () => _pickImage(ImageSource.camera), icon: const Icon(Icons.camera), label: const Text('Camera'))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(onPressed: () => _pickImage(ImageSource.gallery), icon: const Icon(Icons.photo), label: const Text('Upload'))),
            ]),
            const SizedBox(height: 12),
            if (_image != null) Expanded(child: Image.file(_image!, fit: BoxFit.contain)),
            if (_loading) const Padding(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator()),
            if (_predictions != null) ...[
              const SizedBox(height: 10),
              const Text('Top matches:', style: TextStyle(fontWeight: FontWeight.bold)),
              for (var p in _predictions!) Text("${p['label']} — ${(p['prob'] * 100).toStringAsFixed(1)}%"),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save to server (Supabase)'),
                onPressed: () => _saveToSupabase(),
              ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                icon: const Icon(Icons.person_search),
                label: const Text('Contact expert'),
                onPressed: () async {
                  const url = 'https://wa.me/254713797350'; // replace with logic to find local expert
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
              ),
            ],
            if (_predictions == null && !_loading)
              const Expanded(child: Center(child: Text('No image selected'))),
          ],
        ),
      ),
    );
  }
}
