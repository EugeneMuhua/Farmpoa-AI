// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'vision_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      {'label': 'Diagnose (Camera/Upload)', 'icon': Icons.camera_alt, 'route': const VisionScreen()},
      // add other screens here later: Assistant, Marketplace, Directory
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('FarmPoa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: tiles.map((t) {
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => t['route'] as Widget));
                },
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(t['icon'] as IconData, size: 42),
                    const SizedBox(height: 8),
                    Text(t['label'] as String, textAlign: TextAlign.center),
                  ]),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
