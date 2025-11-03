import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/providers/auth_notifier.dart';
import 'core/config/env_config.dart';
import 'core/database/local_database.dart';
import 'core/network/supabase_client.dart';
import 'presentation/app.dart';

// Global navigator key for accessing context outside widget tree
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  print('APP STARTUP BEGIN');
  
  // Ensure Flutter bindings are initialized
  print('Initializing Flutter bindings...');
  WidgetsFlutterBinding.ensureInitialized();
  print('Flutter bindings initialized');

  // Set preferred orientations (portrait only for mobile)
  print('Setting screen orientation...');
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  print('Screen orientation set');

  // Validate environment configuration
  print('Validating environment config...');
  try {
    EnvConfig.validateOrThrow();
    print('Environment config validated');
  } catch (e) {
    print('Environment config validation failed: $e');
    runApp(ConfigurationErrorApp(error: e.toString()));
    return;
  }

  // Initialize services with timeout protection
  print('Starting service initialization...');
  try {
    await _initializeServices().timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        print('Service initialization TIMEOUT after 30 seconds');
        throw TimeoutException('Service initialization took too long');
      },
    );
    print('All services initialized');
  } catch (e, stackTrace) {
    print('Service initialization FAILED: $e');
    print('Stack trace: $stackTrace');
    runApp(ConfigurationErrorApp(error: 'Service initialization failed: $e'));
    return;
  }

  // Run app with error handling
  print('Starting app...');
  if (EnvConfig.sentryDsn.isNotEmpty) {
    print('Running with Sentry monitoring');
    await _runWithSentry();
  } else {
    print('Running without Sentry');
    _runApp();
  }
  
  print('APP STARTUP COMPLETE');
}

/// Initialize all required services
Future<void> _initializeServices() async {
  print('  _initializeServices() START');
  
  try {
    // Initialize local database (Hive)
    print('  [1/2] Initializing Hive database...');
    await LocalDatabase.initialize().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        print('  Hive initialization TIMEOUT');
        throw TimeoutException('Hive initialization timeout');
      },
    );
    print('  [1/2] Hive database initialized');

    // Initialize Supabase
    print('  [2/2] Initializing Supabase...');
    await SupabaseClientManager.initialize().timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        print('  Supabase initialization TIMEOUT');
        throw TimeoutException('Supabase initialization timeout');
      },
    );
    print('  [2/2] Supabase initialized');

    print('  _initializeServices() COMPLETE');
  } catch (e, stackTrace) {
    print('  _initializeServices() FAILED: $e');
    print('  Stack: $stackTrace');
    rethrow;
  }
}

/// Run app with Sentry error tracking
Future<void> _runWithSentry() async {
  print('  Initializing Sentry...');
  try {
    await SentryFlutter.init(
      (options) {
        options.dsn = EnvConfig.sentryDsn;
        options.environment = EnvConfig.isConfigured ? 'production' : 'development';
        options.tracesSampleRate = 0.1;

        options.beforeSend = (SentryEvent event, Hint hint) {
          return event;
        };
      },
      appRunner: _runApp,
    );
    print('  Sentry initialized');
  } catch (e) {
    print('  Sentry initialization failed: $e');
    // Continue without Sentry
    _runApp();
  }
}

/// Run the app
void _runApp() {
  print('  Running app widget...');
  runApp(
    ProviderScope(
      child: MCHPinkBookAppWithDeepLinks(),
    ),
  );
  print('  App widget launched');
}

/// App wrapper with deep link handling
class MCHPinkBookAppWithDeepLinks extends ConsumerStatefulWidget {
  const MCHPinkBookAppWithDeepLinks({super.key});

  @override
  ConsumerState<MCHPinkBookAppWithDeepLinks> createState() => _MCHPinkBookAppWithDeepLinksState();
}

class _MCHPinkBookAppWithDeepLinksState extends ConsumerState<MCHPinkBookAppWithDeepLinks> {
  late AppLinks _appLinks;
  StreamSubscription? _linkSubscription;
  bool _isProcessingLink = false;
  
  final Set<String> _processedUserIds = {};

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        print('Initial deep link: $initialUri');
        await Future.delayed(const Duration(milliseconds: 500));
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      print('Error getting initial URI: $e');
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        print('Deep link received: $uri');
        _handleDeepLink(uri);
      },
      onError: (err) {
        print('Deep link error: $err');
      },
    );
  }

  void _handleDeepLink(Uri uri) async {
    if (_isProcessingLink) {
      print('Already processing a deep link, ignoring this one');
      return;
    }

    _isProcessingLink = true;

    try {
      print('Processing deep link: ${uri.toString()}');
      print('   Scheme: ${uri.scheme}');
      print('   Host: ${uri.host}');
      print('   Path: ${uri.path}');
      print('   Query: ${uri.query}');
      print('   Fragment: ${uri.fragment}');

      if (uri.scheme == 'com.mch.pinkbook' && uri.host == 'auth') {
        print('Processing Supabase auth link...');
        
        final Map<String, String> params = {};
        if (uri.fragment.isNotEmpty) {
          final fragmentParams = Uri.splitQueryString(uri.fragment);
          params.addAll(fragmentParams);
          print('   Fragment params: ${fragmentParams.keys.join(", ")}');
        }
        if (uri.queryParameters.isNotEmpty) {
          params.addAll(uri.queryParameters);
          print('   Query params: ${uri.queryParameters.keys.join(", ")}');
        }

        final hasAccessToken = params.containsKey('access_token');
        final hasRefreshToken = params.containsKey('refresh_token');
        final hasTokenHash = params.containsKey('token_hash');
        final hasType = params.containsKey('type');

        print('   Has access_token: $hasAccessToken');
        print('   Has refresh_token: $hasRefreshToken');
        print('   Has token_hash: $hasTokenHash');
        print('   Has type: $hasType');

        if (hasAccessToken && hasRefreshToken) {
          print('Using direct token flow');
          try {
            final response = await SupabaseClientManager.client.auth.recoverSession(
              '{"access_token":"${params['access_token']}","refresh_token":"${params['refresh_token']}"}',
            );
            if (response.session != null) {
              final userId = response.session!.user.id;
              if (_processedUserIds.contains(userId)) return;
              _processedUserIds.add(userId);
              print('Session established from tokens');
              await Future.delayed(const Duration(milliseconds: 500));
              await ref.read(authNotifierProvider.notifier).refreshUser();
              _showSuccessMessage('Email verified successfully! Welcome!');
            } else {
              print('recoverSession succeeded but no session returned');
              _showErrorMessage('Could not establish session');
            }
          } catch (e) {
            print('recoverSession failed: $e');
            if (_shouldIgnoreError(e)) return;
            _showErrorMessage('Failed to establish session: ${e.toString()}');
          }
        } else if (hasTokenHash && hasType) {
          print('Using token hash flow');
          try {
            final response = await SupabaseClientManager.client.auth.verifyOTP(
              type: OtpType.values.firstWhere(
                (e) => e.name == params['type'],
                orElse: () => OtpType.email,
              ),
              tokenHash: params['token_hash']!,
            );
            if (response.session != null) {
              final userId = response.session!.user.id;
              if (_processedUserIds.contains(userId)) return;
              _processedUserIds.add(userId);
              print('Session established from OTP verification');
              await Future.delayed(const Duration(milliseconds: 500));
              await ref.read(authNotifierProvider.notifier).refreshUser();
              _showSuccessMessage('Email verified successfully! Welcome!');
            } else {
              print('OTP verification succeeded but no session');
              _showErrorMessage('Verification succeeded but no session created');
            }
          } catch (e) {
            print('OTP verification failed: $e');
            if (_shouldIgnoreError(e)) return;
            _showErrorMessage('Verification failed: ${e.toString()}');
          }
        } else {
          print('No recognized token format, trying getSessionFromUrl');
          try {
            final response = await SupabaseClientManager.client.auth.getSessionFromUrl(uri);
            final userId = response.session.user.id;
            if (_processedUserIds.contains(userId)) return;
            _processedUserIds.add(userId);
            print('Session established from URL parser');
            await Future.delayed(const Duration(milliseconds: 500));
            await ref.read(authNotifierProvider.notifier).refreshUser();
            _showSuccessMessage('Email verified successfully! Welcome!');
          } catch (e) {
            print('getSessionFromUrl failed: $e');
            if (_shouldIgnoreError(e)) return;
            if (e.toString().contains('flow_state_not_found')) {
              print('Link expired or already used - this is expected behavior');
            } else {
              _showErrorMessage('Error processing link: ${e.toString()}');
            }
          }
        }
      } else if (uri.host == 'login-callback' || uri.host == 'callback') {
        print('Processing alternative auth callback...');
        try {
          final response = await SupabaseClientManager.client.auth.getSessionFromUrl(uri);
          final userId = response.session.user.id;
          if (_processedUserIds.contains(userId)) return;
          _processedUserIds.add(userId);
          print('Session established from callback');
          await Future.delayed(const Duration(milliseconds: 500));
          await ref.read(authNotifierProvider.notifier).refreshUser();
          _showSuccessMessage('Authentication successful!');
        } catch (e) {
          print('Callback processing failed: $e');
          if (_shouldIgnoreError(e)) return;
          if (e.toString().contains('flow_state_not_found')) {
            print('Callback link expired - this is expected');
          } else {
            _showErrorMessage('Authentication error: ${e.toString()}');
          }
        }
      } else {
        print('Unrecognized deep link format');
        print('   Expected scheme: com.mch.pinkbook, got: ${uri.scheme}');
        print('   Expected host: auth, callback, or login-callback, got: ${uri.host}');
      }
    } catch (e, stackTrace) {
      print('Error handling deep link: $e');
      print('Stack trace: $stackTrace');
      if (!_shouldIgnoreError(e)) {
        _showErrorMessage('Error processing link: ${e.toString()}');
      }
    } finally {
      _isProcessingLink = false;
    }
  }

  bool _shouldIgnoreError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('flow_state_not_found') ||
           errorStr.contains('invalid flow state') ||
           errorStr.contains('no valid flow state');
  }

  void _showSuccessMessage(String message) {
    final context = navigatorKey.currentContext;
    if (context != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green, duration: const Duration(seconds: 3)),
      );
    } else {
      print('Cannot show success message: no context available');
    }
  }

  void _showErrorMessage(String message) {
    final context = navigatorKey.currentContext;
    if (context != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red, duration: const Duration(seconds: 5)),
      );
    } else {
      print('Cannot show error message: no context available');
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _processedUserIds.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MCHPinkBookApp();
  }
}

/// Configuration Error Screen
class ConfigurationErrorApp extends StatelessWidget {
  final String error;

  const ConfigurationErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 24),
                const Text('Configuration Error', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(error, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                const Text(
                  'Please check the console logs for details.\n\n'
                  'Required environment variables:\n'
                  '• SUPABASE_URL\n'
                  '• SUPABASE_ANON_KEY',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => 'TimeoutException: $message';
}