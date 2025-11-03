/// Clean Authentication State Notifier
/// Fixed email verification and profile loading flow
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/network/supabase_client.dart';
import '../../core/config/env_config.dart';
import '../../../core/constants/app_constants.dart';
part 'auth_notifier.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated(UserEntity user) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.otpSent(String phoneNumber) = OtpSent;
  const factory AuthState.signupInProgress() = SignupInProgress;
  const factory AuthState.emailVerificationPending() = EmailVerificationPending;
  const factory AuthState.phoneVerificationPending(String phone) = PhoneVerificationPending;
  
  // NEW: Add this state for healthcare providers waiting for manual verification
  const factory AuthState.pendingVerification({
    required String email,
    required UserRole role,
    required String message,
  }) = PendingVerification;
  
  const factory AuthState.error(String message) = Error;
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Storage for pending signup data (waiting for email verification)
class _PendingSignupData {
  final String fullName;
  final String email;
  final String? phoneE164;
  final UserRole role;
  final String? licenseNumber;
  final String? facilityName;
  final bool isActive;

  _PendingSignupData({
    required this.fullName,
    required this.email,
    this.phoneE164,
    required this.role,
    this.licenseNumber,
    this.facilityName,
    this.isActive = true,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseClient _supabase = supabase;
  _PendingSignupData? _pendingSignupData;
  bool _isProcessingSignup = false;
  String? _lastProcessedUserId;

  AuthNotifier() : super(const AuthState.initial()) {
    _initialize();
  }

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  Future<void> _initialize() async {
    _supabase.auth.onAuthStateChange.listen((data) {
      print('🔔 Auth state change: ${data.event}');
      
      if (data.event == AuthChangeEvent.signedIn ||
          data.event == AuthChangeEvent.tokenRefreshed) {
        _handleAuthStateChange();
      } else if (data.event == AuthChangeEvent.signedOut) {
        _pendingSignupData = null;
        _isProcessingSignup = false;
        _lastProcessedUserId = null;
        state = const AuthState.unauthenticated();
      }
    }, onError: (error) {
      print('❌ Auth stream error: $error');
      if (error is AuthException) {
        if (error.message.contains('flow_state_not_found') ||
            error.message.contains('invalid flow state')) {
          print('⚠️ Invalid deep link, ignoring...');
          // After email verification, try to complete any pending signup
          if (_pendingSignupData != null) {
            print('🔄 Found pending signup data, attempting to complete...');
            Future.microtask(() => _completePendingSignup());
          }
          return;
        }
      }
      state = AuthState.error(error.toString());
    });

    await _checkAuthStatus();
  }

  Future<void> _handleAuthStateChange() async {
    if (_isProcessingSignup) {
      print('⚠️ Already processing signup, skipping auth state change...');
      return;
    }

    final currentUserId = _supabase.auth.currentUser?.id;
    final user = _supabase.auth.currentUser;
    
    print('🔍 Handling auth state change for user: $currentUserId');
    print('   Email verified: ${user?.emailConfirmedAt != null}');
    print('   Has pending data: ${_pendingSignupData != null}');
    print('   Last processed: $_lastProcessedUserId');
    
    // Check if we have pending signup data (after email verification)
    if (_pendingSignupData != null) {
      // If email is verified, complete the signup
      if (user?.emailConfirmedAt != null) {
        // Check if we already completed this signup
        final profileExists = await _checkProfileExists(currentUserId);
        
        if (profileExists) {
          print('✅ Profile already created, loading it...');
          _pendingSignupData = null;
          _lastProcessedUserId = currentUserId;
          await _loadUserProfile();
        } else {
          print('✅ Email verified, completing signup...');
          await _completePendingSignup();
        }
        return;
      }
      
      print('⚠️ Email not yet verified, waiting...');
      return;
    }
    
    // No pending signup data - just load the profile
    await _loadUserProfile();
  }

  Future<bool> _checkProfileExists(String? userId) async {
    if (userId == null) return false;
    
    try {
      final response = await _supabase
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      print('❌ Error checking profile existence: $e');
      return false;
    }
  }

  Future<void> _checkAuthStatus() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) {
        state = const AuthState.unauthenticated();
        return;
      }

      final user = _supabase.auth.currentUser;
      if (user?.email != null &&
          user?.emailConfirmedAt == null &&
          user?.phone == null) {
        state = const AuthState.emailVerificationPending();
        return;
      }

      await _loadUserProfile();
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        print('❌ No current user, setting unauthenticated');
        state = const AuthState.unauthenticated();
        return;
      }

      print('📖 Loading profile for user: $userId');

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              print('⏱️ Profile loading timed out after 10 seconds');
              throw TimeoutException('Profile loading timed out');
            },
          );

      print('📦 Response received: ${response != null ? "Data found" : "No data"}');

      if (response == null) {
        print('⚠️ No profile found in database');
        final authUser = _supabase.auth.currentUser!;

        if (authUser.email != null && authUser.emailConfirmedAt == null) {
          print('📧 Email not verified, showing verification screen');
          state = const AuthState.emailVerificationPending();
          return;
        }

        // Check if we have pending signup data that should be completed
        if (_pendingSignupData != null && authUser.emailConfirmedAt != null) {
          print('🔄 Found pending signup with verified email, completing now...');
          await _completePendingSignup();
          return;
        }

        print('➡️ Redirecting to signup to complete profile');
        state = const AuthState.signupInProgress();
        return;
      }

      try {
        print('🔄 Parsing user entity...');
        
        final user = UserEntity.fromJson(response);
        print('✅ Profile loaded successfully for: ${user.fullName} (${user.role.name})');
        state = AuthState.authenticated(user);
      } catch (parseError, stackTrace) {
        print('❌ Error parsing user entity: $parseError');
        print('📋 Response data: $response');
        print('📚 Stack trace: $stackTrace');
        state = AuthState.error('Failed to parse user profile: ${parseError.toString()}');
      }
    } on TimeoutException catch (e) {
      print('❌ Timeout error: $e');
      state = const AuthState.error('Loading profile timed out. Please check your connection and try again.');
    } on PostgrestException catch (e) {
      print('❌ Postgrest error: ${e.message}');
      print('   Code: ${e.code}');
      print('   Details: ${e.details}');
      state = AuthState.error('Database error: ${e.message}');
    } catch (e, stackTrace) {
      print('❌ Error loading profile: $e');
      print('📚 Stack trace: $stackTrace');
      state = AuthState.error('Failed to load profile: ${e.toString()}');
    }
  }

  // ============================================================================
  // EMAIL/PASSWORD AUTHENTICATION
  // ============================================================================

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
    String? phoneE164,
    String? licenseNumber,
    String? facilityName,
  }) async {
    if (_isProcessingSignup) {
      print('⚠️ Signup already in progress');
      return;
    }

    _isProcessingSignup = true;
    try {
      state = const AuthState.loading();

      if ((phoneE164 == null || phoneE164.isEmpty) && email.isEmpty) {
        throw Exception('Either phone number or email is required');
      }

      print('📧 Starting email signup for: $email (role: ${role.name})');

      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: null,
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create account');
      }

      final userId = authResponse.user!.id;
      print('✅ Auth user created: $userId');
      _lastProcessedUserId = userId;

      // Determine if this is a healthcare provider
      final isProvider = role != UserRole.mother;

      if (authResponse.session != null) {
        // Email verification is disabled - create profile immediately
        print('✅ Session exists, email verification disabled');
        
        await Future.delayed(const Duration(milliseconds: 500));

        final currentUserId = _supabase.auth.currentUser?.id;
        if (currentUserId == null || currentUserId != userId) {
          throw Exception('Auth session not properly established');
        }

        await _createUserProfile(
          userId: userId,
          fullName: fullName,
          email: email,
          phoneE164: phoneE164,
          role: role,
          licenseNumber: licenseNumber,
          facilityName: facilityName,
          isActive: !isProvider, // Providers inactive until verified
        );

        // For providers, show pending verification state
        if (isProvider) {
          print('🏥 Healthcare provider signup - setting pending verification state');
          state = AuthState.pendingVerification(
            email: email,
            role: role,
            message: 'Application submitted! We will verify your license within 24-48 hours.',
          );
        } else {
          // For mothers, load profile normally
          await _loadUserProfile();
        }
      } else {
        // Email verification is required
        print('📧 Email verification required, storing signup data');
        
        _pendingSignupData = _PendingSignupData(
          fullName: fullName,
          email: email,
          phoneE164: phoneE164,
          role: role,
          licenseNumber: licenseNumber,
          facilityName: facilityName,
          isActive: !isProvider, // Providers inactive until verified
        );

        state = const AuthState.emailVerificationPending();
      }
    } on AuthException catch (e) {
      print('❌ Auth exception: ${e.message}');
      _pendingSignupData = null;
      _lastProcessedUserId = null;
      state = AuthState.error(e.message);
    } on PostgrestException catch (e) {
      print('❌ Postgres exception: ${e.message}');
      _pendingSignupData = null;
      _lastProcessedUserId = null;
      state = AuthState.error(e.message);
    } catch (e) {
      print('❌ Signup failed: $e');
      _pendingSignupData = null;
      _lastProcessedUserId = null;
      state = AuthState.error('Signup failed: ${e.toString()}');
    } finally {
      _isProcessingSignup = false;
    }
  }

  // SINGLE DEFINITION - Keep this one
  Future<void> _completePendingSignup() async {
    if (_pendingSignupData == null) {
      print('⚠️ No pending signup data to complete');
      return;
    }
    
    if (_isProcessingSignup) {
      print('⚠️ Already processing signup');
      return;
    }

    _isProcessingSignup = true;
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        print('❌ No current user, cannot complete signup');
        _pendingSignupData = null;
        state = const AuthState.unauthenticated();
        return;
      }

      print('📝 Completing pending signup for user: $userId');
      
      // Check if profile already exists (in case we're retrying)
      final profileExists = await _checkProfileExists(userId);
      
      if (profileExists) {
        print('✅ Profile already exists, loading it...');
        final data = _pendingSignupData!;
        _pendingSignupData = null;
        _lastProcessedUserId = userId;
        
        // Check if it's a provider - if so, show pending verification
        if (data.role != UserRole.mother) {
          state = AuthState.pendingVerification(
            email: data.email,
            role: data.role,
            message: 'Application submitted! We will verify your license within 24-48 hours.',
          );
        } else {
          await _loadUserProfile();
        }
        return;
      }

      _lastProcessedUserId = userId;

      final data = _pendingSignupData!;
      final isProvider = data.role != UserRole.mother;
      
      await _createUserProfile(
        userId: userId,
        fullName: data.fullName,
        email: data.email,
        phoneE164: data.phoneE164,
        role: data.role,
        licenseNumber: data.licenseNumber,
        facilityName: data.facilityName,
        isActive: !isProvider, // Providers inactive until verified
      );

      print('✅ Profile created successfully');
      _pendingSignupData = null;
      
      // For providers, show pending verification state
      if (isProvider) {
        print('🏥 Healthcare provider - setting pending verification state');
        state = AuthState.pendingVerification(
          email: data.email,
          role: data.role,
          message: 'Application submitted! We will verify your license within 24-48 hours.',
        );
      } else {
        // For mothers, load profile normally
        await _loadUserProfile();
      }
    } catch (e) {
      print('❌ Error completing pending signup: $e');
      state = AuthState.error('Failed to complete signup: ${e.toString()}');
      _lastProcessedUserId = null;
    } finally {
      _isProcessingSignup = false;
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      state = const AuthState.loading();

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user?.emailConfirmedAt == null) {
        state = const AuthState.emailVerificationPending();
        return;
      }

      await _loadUserProfile();
    } on AuthException catch (e) {
      if (e.message.contains('Email not confirmed')) {
        state = const AuthState.emailVerificationPending();
      } else if (e.message.contains('Invalid login credentials')) {
        state = const AuthState.error('Invalid email or password');
      } else {
        state = AuthState.error(e.message);
      }
    } catch (e) {
      state = AuthState.error('Sign in failed: ${e.toString()}');
    }
  }

  // ============================================================================
  // PHONE OTP AUTHENTICATION (LOGIN)
  // ============================================================================

  Future<void> requestOtp(String phoneNumber) async {
    try {
      state = const AuthState.loading();

      final validatedPhone = _formatPhone(phoneNumber);
      if (validatedPhone == null) {
        throw Exception('Invalid phone number');
      }

      if (_isDevMode(validatedPhone)) {
        state = AuthState.otpSent(validatedPhone);
        return;
      }

      await _supabase.auth.signInWithOtp(
        phone: validatedPhone,
        shouldCreateUser: false,
      );

      state = AuthState.otpSent(validatedPhone);
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Failed to send OTP: ${e.toString()}');
    }
  }

  Future<void> verifyOtpAndSignIn(String phoneNumber, String otp) async {
    try {
      state = const AuthState.loading();

      if (!_isValidOtp(otp)) {
        throw Exception('Invalid OTP format');
      }

      if (_isDevMode(phoneNumber) && _isDevOtp(otp)) {
        await _devModeLogin(phoneNumber);
        return;
      }

      final response = await _supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );

      if (response.session == null) {
        throw Exception('Invalid OTP');
      }
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
      _delayedReturnToOtpSent(phoneNumber);
    } catch (e) {
      state = AuthState.error(e.toString());
      _delayedReturnToOtpSent(phoneNumber);
    }
  }

  // ============================================================================
  // PHONE OTP SIGNUP (MOTHER)
  // ============================================================================

  Future<void> sendPhoneOtp({required String phoneE164}) async {
    try {
      state = const AuthState.loading();

      final validatedPhone = _formatPhone(phoneE164);
      if (validatedPhone == null) {
        throw Exception('Invalid phone number');
      }

      await _checkPhoneNotExists(validatedPhone);

      if (_isDevMode(validatedPhone)) {
        state = AuthState.otpSent(validatedPhone);
        return;
      }

      await _supabase.auth.signInWithOtp(
        phone: validatedPhone,
        shouldCreateUser: true,
      );

      state = AuthState.otpSent(validatedPhone);
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } on PostgrestException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyPhoneOtpAndSignUp({
    required String phoneE164,
    required String otp,
    required String fullName,
    required UserRole role,
  }) async {
    if (_isProcessingSignup) {
      print('⚠️ Signup already in progress');
      return;
    }

    _isProcessingSignup = true;
    try {
      state = const AuthState.loading();

      if (!_isValidOtp(otp)) {
        throw Exception('Invalid OTP format');
      }

      final validatedPhone = _formatPhone(phoneE164);
      if (validatedPhone == null) {
        throw Exception('Invalid phone number');
      }

      final authResponse = await _supabase.auth.verifyOTP(
        phone: validatedPhone,
        token: otp,
        type: OtpType.sms,
      );

      if (authResponse.user == null) {
        throw Exception('OTP verification failed');
      }

      _lastProcessedUserId = authResponse.user!.id;

      await _createUserProfile(
        userId: authResponse.user!.id,
        fullName: fullName,
        phoneE164: validatedPhone,
        role: role,
      );

      await _loadUserProfile();
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
      _lastProcessedUserId = null;
    } on PostgrestException catch (e) {
      state = AuthState.error(e.message);
      _lastProcessedUserId = null;
    } catch (e) {
      state = AuthState.error(e.toString());
      _lastProcessedUserId = null;
    } finally {
      _isProcessingSignup = false;
    }
  }

  // ============================================================================
  // PHONE OTP SIGNUP (HEALTHCARE PROVIDER)
  // ============================================================================

  Future<void> verifyPhoneOtpAndSignUpProvider({
    required String phoneE164,
    required String otp,
    required String fullName,
    required UserRole role,
    required String licenseNumber,
    String? facilityName,
  }) async {
    if (_isProcessingSignup) {
      print('⚠️ Signup already in progress');
      return;
    }

    _isProcessingSignup = true;
    try {
      state = const AuthState.loading();

      if (!_isValidOtp(otp)) {
        throw Exception('Invalid OTP format');
      }

      if (licenseNumber.trim().isEmpty) {
        throw Exception('License number is required');
      }

      final validatedPhone = _formatPhone(phoneE164);
      if (validatedPhone == null) {
        throw Exception('Invalid phone number');
      }

      final authResponse = await _supabase.auth.verifyOTP(
        phone: validatedPhone,
        token: otp,
        type: OtpType.sms,
      );

      if (authResponse.user == null) {
        throw Exception('OTP verification failed');
      }

      _lastProcessedUserId = authResponse.user!.id;

      await _createUserProfile(
        userId: authResponse.user!.id,
        fullName: fullName,
        phoneE164: validatedPhone,
        role: role,
        licenseNumber: licenseNumber,
        facilityName: facilityName,
        isActive: false,
      );

      await _loadUserProfile();
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
      _lastProcessedUserId = null;
    } on PostgrestException catch (e) {
      state = AuthState.error(e.message);
      _lastProcessedUserId = null;
    } catch (e) {
      state = AuthState.error(e.toString());
      _lastProcessedUserId = null;
    } finally {
      _isProcessingSignup = false;
    }
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  // Replace the _createUserProfile method in your auth_notifier.dart with this:

Future<void> _createUserProfile({
  required String userId,
  required String fullName,
  required UserRole role,
  String? email,
  String? phoneE164,
  String? licenseNumber,
  String? facilityName,
  bool isActive = true,
}) async {
  try {
    if ((phoneE164 == null || phoneE164.isEmpty) &&
        (email == null || email.isEmpty)) {
      throw Exception('Either phone number or email is required');
    }

    final currentUserId = _supabase.auth.currentUser?.id;
    print('📝 Creating profile for userId: $userId');
    print('   Current auth.uid(): $currentUserId');
    print('   Email: $email');
    print('   Phone: $phoneE164');
    print('   Role: ${role.name}');
    print('   License: $licenseNumber');
    print('   IsActive: $isActive');

    if (currentUserId != userId) {
      throw Exception(
          'User ID mismatch: auth.uid() = $currentUserId, but trying to create profile for $userId');
    }

    // Check if profile already exists
    final existing = await _supabase
        .from('users')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    if (existing != null) {
      print('✅ Profile already exists for user $userId, skipping creation');
      return;
    }

    final metadata = <String, dynamic>{};
    if (!isActive) {
      metadata['verification_status'] = 'pending';
    }

    // Build the insert data
    final insertData = {
      'id': userId,
      'full_name': fullName,
      'role': role.name,
      'language_pref': 'en',
      'consent_given': true,
      'consent_date': DateTime.now().toIso8601String(),
      'is_active': isActive,
      'metadata': metadata,
    };

    // Add optional fields only if they have values
    if (email != null && email.isNotEmpty) {
      insertData['email'] = email;
    }
    if (phoneE164 != null && phoneE164.isNotEmpty) {
      insertData['phone_e164'] = phoneE164;
    }
    if (licenseNumber != null && licenseNumber.isNotEmpty) {
      insertData['license_number'] = licenseNumber;
    }
    if (facilityName != null && facilityName.isNotEmpty) {
      insertData['facility_name'] = facilityName;
    }

    print('📤 Inserting profile data: $insertData');

    // Insert the profile
    final insertResponse = await _supabase
        .from('users')
        .insert(insertData)
        .select()
        .single();

    print('✅ Profile created successfully!');
    print('📥 Created profile data: $insertResponse');

  } on PostgrestException catch (e) {
    print('=== PostgrestException ===');
    print('Message: ${e.message}');
    print('Details: ${e.details}');
    print('Hint: ${e.hint}');
    print('Code: ${e.code}');

    if (e.code == '23505') {
      print('✅ Profile already exists (duplicate key), continuing...');
      return;
    }

    if (e.message.contains('row-level security') ||
        e.message.contains('policy') ||
        e.code == '42501') {
      throw Exception(
        'Permission denied: Unable to create profile. '
        'Please check RLS policies on users table. '
        'Current user: ${_supabase.auth.currentUser?.id}'
      );
    }

    // Re-throw with more context
    throw Exception('Database error creating profile: ${e.message} (Code: ${e.code})');
  } catch (e, stackTrace) {
    print('❌ Unexpected error creating profile: $e');
    print('📚 Stack trace: $stackTrace');
    rethrow;
  }
}

  Future<void> _checkPhoneNotExists(String phone) async {
    final existing = await _supabase
        .from('users')
        .select('id')
        .eq('phone_e164', phone)
        .maybeSingle();

    if (existing != null) {
      throw Exception('Phone number already registered');
    }
  }

  Future<void> _devModeLogin(String phoneNumber) async {
    final userResponse = await _supabase
        .from('users')
        .select()
        .eq('phone_e164', phoneNumber)
        .maybeSingle();

    if (userResponse != null) {
      final user = UserEntity.fromJson(userResponse);
      state = AuthState.authenticated(user);
    } else {
      throw Exception('User not found');
    }
  }

  String? _formatPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');

    String? normalized;
    if (cleaned.startsWith('254') && cleaned.length == 12) {
      normalized = cleaned.substring(3);
    } else if (cleaned.startsWith('0') && cleaned.length == 10) {
      normalized = cleaned.substring(1);
    } else if (cleaned.length == 9) {
      normalized = cleaned;
    }

    if (normalized != null &&
        (normalized.startsWith('7') || normalized.startsWith('1')) &&
        normalized.length == 9) {
      return '+254$normalized';
    }

    return null;
  }

  bool _isValidOtp(String otp) {
    return otp.length == 6 && RegExp(r'^\d+$').hasMatch(otp);
  }

  bool _isDevMode(String phone) {
    return EnvConfig.isDevelopment &&
        EnvConfig.devTestPhoneNumbers.contains(phone);
  }

  bool _isDevOtp(String otp) {
    return EnvConfig.devAcceptedOtps.contains(otp);
  }

  void _delayedReturnToOtpSent(String phoneNumber) {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        state = AuthState.otpSent(phoneNumber);
      }
    });
  }

  // ============================================================================
  // PUBLIC UTILITY METHODS
  // ============================================================================

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('No authenticated user');

      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabase.from('users').update(updates).eq('id', userId);
      await _loadUserProfile();
    } on PostgrestException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('Update failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      state = const AuthState.loading();
      _pendingSignupData = null;
      _isProcessingSignup = false;
      _lastProcessedUserId = null;
      await _supabase.auth.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  void resetToInitial() {
    _pendingSignupData = null;
    _isProcessingSignup = false;
    _lastProcessedUserId = null;
    state = const AuthState.unauthenticated();
  }

  Future<void> refreshUser() async {
    await _loadUserProfile();
  }

  Future<void> resendVerificationEmail() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user?.email == null) {
        throw Exception('No email found');
      }

      await _supabase.auth.resend(
        type: OtpType.signup,
        email: user!.email!,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to resend verification email');
    }
  }

  Future<void> checkEmailVerification() async {
    if (_isProcessingSignup) {
      print('⚠️ Already processing signup verification');
      return;
    }

    try {
      state = const AuthState.loading();

      final response = await _supabase.auth.refreshSession();

      if (response.user?.emailConfirmedAt != null) {
        print('✅ Email verified!');
        if (_pendingSignupData != null) {
          await _completePendingSignup();
        } else {
          await _loadUserProfile();
        }
      } else {
        print('⚠️ Email still not verified');
        state = const AuthState.emailVerificationPending();
      }
    } catch (e) {
      print('❌ Error checking verification: $e');
      state = AuthState.error('Failed to check verification status');
    }
  }
}