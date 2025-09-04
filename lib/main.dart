// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // OPTIONAL: initialize Supabase if you want backend features.
  // Replace with your values or comment out if not using Supabase yet.
  // await SupabaseService.init(
  //   url: 'https://YOUR-PROJECT.supabase.co',
  //   anonKey: 'YOUR-ANON-KEY',
  // );

  runApp(const FarmPoaApp());
}

class FarmPoaApp extends StatelessWidget {
  const FarmPoaApp({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmPoa',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}
