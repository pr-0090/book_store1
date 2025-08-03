import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../../../app/constants/app_constants.dart';

class InternetChecker {
  static final InternetChecker _instance = InternetChecker._internal();
  factory InternetChecker() => _instance;
  InternetChecker._internal();

  final Dio _dio = Dio();

  /// Check if device has internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('Error checking internet connectivity: $e');
      return false;
    }
  }

  /// Test connection to the backend server
  Future<bool> testBackendConnection() async {
    try {
      // Try to access the API base URL to test connection
      final response = await _dio.get(
        AppConstants.baseUrl,
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      // If we get a 404, it means the server is running but the endpoint doesn't exist
      // This is still a successful connection
      if (e is DioException && e.response?.statusCode == 404) {
        print('Backend connection successful (404 expected for base URL)');
        return true;
      }
      print('Backend connection test failed: $e');
      return false;
    }
  }

  /// Get the current network status
  Future<ConnectivityResult> getNetworkStatus() async {
    return await Connectivity().checkConnectivity();
  }

  /// Listen to network changes
  Stream<ConnectivityResult> get networkStream {
    return Connectivity().onConnectivityChanged;
  }
} 