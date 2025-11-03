/// Main App Widget
/// Defines theme, routes, and app structure with profile setup flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/env_config.dart';
import '../core/constants/app_constants.dart';
import '../main.dart';
import 'providers/auth_notifier.dart';
import 'shared/screens/splash_screen.dart';
import 'shared/screens/onboarding_screen.dart';
import 'auth/screens/login_screen.dart';
import 'auth/screens/signup_screen.dart';
import 'auth/screens/email_verification_screen.dart';
import 'auth/screens/health_provider_signup_screen.dart';
import 'mother/screens/mother_home_screen.dart';
import 'nurse/screens/nurse_home_screen.dart';
import 'admin/screens/admin_home_screen.dart';
import 'auth/screens/pending_verification_screen.dart';

class MCHPinkBookApp extends ConsumerWidget {
  const MCHPinkBookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      // Use global navigator key for accessing context from anywhere
      navigatorKey: navigatorKey,

      title: EnvConfig.appName,
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.light,

      // Start with AppNavigator
      home: const AppNavigator(),

      // Named Routes
      routes: {
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.healthcareProviderSignup: (context) =>
            const HealthcareProviderSignupScreen(), // ADD THIS LINE
        AppRoutes.pendingVerification: (context) =>
            const PendingVerificationScreen(),
        AppRoutes.motherHome: (context) => const MotherHomeScreen(),
        AppRoutes.nurseHome: (context) => const NurseHomeScreen(),
        AppRoutes.adminHome: (context) => const AdminHomeScreen(),
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryPink,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPink,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.circular(AppBorderRadius.lg),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryPink,
          side: const BorderSide(color: AppColors.primaryPink, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.button,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryPink,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPink,
        brightness: Brightness.dark,
      ),
    );
  }
}

/// App Navigator - Handles routing based on auth state
class AppNavigator extends ConsumerStatefulWidget {
  const AppNavigator({super.key});

  @override
  ConsumerState<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends ConsumerState<AppNavigator> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _showSplash = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const SplashScreen();
    }

    final authState = ref.watch(authNotifierProvider);

    // Use AnimatedSwitcher for smooth transitions between screens
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: _buildScreenForState(authState),
    );
  }

  Widget _buildScreenForState(AuthState authState) {
    return authState.when(
      initial: () => const SplashScreen(),
      loading: () => const SplashScreen(),
      authenticated: (user) {
        // Go directly to role-specific home screen
        return _getHomeScreenForRole(user.role);
      },
      unauthenticated: () => const LoginScreen(),

      // Merged OTP/phone verification states - both show LoginScreen
      otpSent: (_) => const LoginScreen(),
      phoneVerificationPending: (_) => const LoginScreen(),

      signupInProgress: () => const SignupScreen(),
      emailVerificationPending: () => const EmailVerificationScreen(),

      // Handle pending verification for healthcare providers
      pendingVerification: (email, role, message) {
        return const PendingVerificationScreen();
      },

      error: (message) {
        // Check if it's a deep link error that can be ignored
        if (message.contains('flow_state_not_found') ||
            message.contains('invalid flow state')) {
          print('⚠️ Ignoring deep link error, showing login screen');

          // Clear the error and show login screen
          Future.microtask(() {
            if (mounted) {
              ref.read(authNotifierProvider.notifier).resetToInitial();
            }
          });
          return const LoginScreen();
        }

        return ErrorScreen(message: message);
      },
    );
  }

  Widget _getHomeScreenForRole(UserRole role) {
    switch (role) {
      case UserRole.mother:
        return const MotherHomeScreen();
      case UserRole.nurse:
        return const NurseHomeScreen();
      case UserRole.admin:
        return const AdminHomeScreen();
    }
  }
}

/// Error Screen - Shows errors with recovery options
class ErrorScreen extends ConsumerWidget {
  final String message;

  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 60,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Oops! Something went wrong',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Error Message
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Try Again Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(authNotifierProvider.notifier).resetToInitial();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ),
              const SizedBox(height: 16),

              // Back to Login Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
