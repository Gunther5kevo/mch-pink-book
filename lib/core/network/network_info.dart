/// Network Information Service
/// Checks internet connectivity status
library;

import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface for network connectivity checking
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

/// Implementation using connectivity_plus package
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return _isConnectedResult(result);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map(_isConnectedResult);
  }

  bool _isConnectedResult(List<ConnectivityResult> results) {
    // Check if any of the results indicate a connection
    // Returns false only if all results are 'none' or list is empty
    if (results.isEmpty) return false;
    return !results.every((result) => result == ConnectivityResult.none);
  }
}