import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionServices {
  // Private constructor for singleton pattern
  ConnectionServices._instance();

  // Singleton instance
  static final ConnectionServices instance = ConnectionServices._instance();

  // Connectivity instance
  final Connectivity _connectivity = Connectivity();

  // Stream for connectivity changes
  Stream<List<ConnectivityResult>> get connectivityStream => _connectivity.onConnectivityChanged;

  // Method to check if the device is online
  Future<bool> isDeviceOnline() async {
    final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    return !(result.contains(ConnectivityResult.none));
  }
}
