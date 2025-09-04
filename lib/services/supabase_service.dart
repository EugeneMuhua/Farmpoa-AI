// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init({required String url, required String anonKey}) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      // For dev use only; for production configure safe callback URLs
      //authCallbackUrlHostname: 'login-callback',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
