/// Dependency Injection Setup using Riverpod
/// Simplified - Direct Supabase integration
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/network/supabase_client.dart';
import '../../domain/entities/user_entity.dart';

// ============================================================================
// CORE PROVIDERS
// ============================================================================

/// Supabase client provider
/// Single source of truth for Supabase access
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseClientManager.client;
});

// ============================================================================
// STATE PROVIDERS
// ============================================================================

/// Current user provider
/// Fetches user data from Supabase and converts to UserEntity
final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final user = supabase.auth.currentUser;
  
  if (user == null) return null;
  
  try {
    // Fetch user profile from database
    final response = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .single();
    
    return UserEntity.fromJson(response);
  } catch (e) {
    // User exists in auth but not in database yet
    // This can happen during registration flow
    return null;
  }
});

/// Authentication status provider
/// Real-time stream of auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  
  return supabase.auth.onAuthStateChange.map((state) => state.session?.user);
});

/// Is authenticated provider
/// Simple boolean check if user is logged in
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});