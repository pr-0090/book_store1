import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class HiveService {
  static const String _userBoxName = 'user_box';
  static const String _userKey = 'current_user';
  static const String _paymentMethodKey = 'selected_payment_method';
  
  static Box<UserModel>? _userBox;
  static Box<String>? _settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    Hive.registerAdapter(UserModelAdapter());
    
    // Open boxes
    _userBox = await Hive.openBox<UserModel>(_userBoxName);
    _settingsBox = await Hive.openBox<String>('settings_box');
  }

  // Save user data after successful login
  static Future<void> saveUser(UserModel user) async {
    await _userBox?.put(_userKey, user);
  }

  // Get current logged in user
  static UserModel? getCurrentUser() {
    return _userBox?.get(_userKey);
  }

  // Check if user is logged in
  static bool isUserLoggedIn() {
    final user = getCurrentUser();
    return user != null && user.isLoggedIn && user.token != null;
  }

  // Get user token for API calls
  static String? getUserToken() {
    final user = getCurrentUser();
    return user?.token;
  }

  // Get user ID for API calls
  static String? getUserId() {
    final user = getCurrentUser();
    return user?.id;
  }

  // Clear user data on logout
  static Future<void> clearUser() async {
    await _userBox?.delete(_userKey);
  }

  // Update user data
  static Future<void> updateUser(UserModel user) async {
    await _userBox?.put(_userKey, user);
  }

  // Payment method methods
  static Future<void> saveSelectedPaymentMethod(String methodId) async {
    await _settingsBox?.put(_paymentMethodKey, methodId);
  }

  static String? getSelectedPaymentMethod() {
    return _settingsBox?.get(_paymentMethodKey);
  }

  // Close boxes
  static Future<void> close() async {
    await _userBox?.close();
    await _settingsBox?.close();
  }
} 