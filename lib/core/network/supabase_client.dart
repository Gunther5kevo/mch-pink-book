/// Supabase Client Singleton
/// Manages connection to Supabase backend
library;

import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env_config.dart';

class SupabaseClientManager {
  static SupabaseClient? _instance;

  /// Initialize Supabase
  static Future<void> initialize() async {
    EnvConfig.validateOrThrow();
    
   await Supabase.initialize(
  url: EnvConfig.supabaseUrl,
  anonKey: EnvConfig.supabaseAnonKey,
  debug: true, // ← ADD THIS
  authOptions: const FlutterAuthClientOptions(
    authFlowType: AuthFlowType.pkce,
    autoRefreshToken: true,
  ),
  realtimeClientOptions: const RealtimeClientOptions(
    logLevel: RealtimeLogLevel.info,
  ),
);
    
    _instance = Supabase.instance.client;
  }

  /// Get Supabase client instance
  static SupabaseClient get client {
    if (_instance == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  /// Get current user
  static User? get currentUser => client.auth.currentUser;

  /// Get current session
  static Session? get currentSession => client.auth.currentSession;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Get user ID
  static String? get userId => currentUser?.id;

  /// Sign out
  static Future<void> signOut() async {
    await client.auth.signOut();
  }
}

/// Convenience getter for Supabase client
SupabaseClient get supabase => SupabaseClientManager.client;