import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // App Settings & Preferences
  static const String _keyDarkMode = 'dark_mode_enabled';
  static const String _keyNotifications = 'notifications_enabled';
  static const String _keyBiometric = 'biometric_enabled';
  static const String _keyLanguage = 'app_language';
  static const String _keyCurrency = 'app_currency';

  // Onboarding & First Launch
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyFirstLaunch = 'first_launch_date';

  // User Preferences
  static const String _keyDefaultShippingAddress = 'default_shipping_address';
  static const String _keyPreferredPaymentMethod = 'preferred_payment_method';
  static const String _keySearchHistory = 'search_history';
  static const String _keyLastVisitedScreen = 'last_visited_screen';

  // App State & Analytics
  static const String _keyAppLaunchCount = 'app_launch_count';
  static const String _keyLastActiveDate = 'last_active_date';
  static const String _keySessionDuration = 'session_duration';

  // Feature Flags
  static const String _keyNewFeaturesEnabled = 'new_features_enabled';
  static const String _keyBetaFeatures = 'beta_features_enabled';

  // ===== App Settings Methods =====
  
  // Dark Mode
  static Future<bool> setDarkMode(bool enabled) async {
    return await _prefs?.setBool(_keyDarkMode, enabled) ?? false;
  }

  static bool getDarkMode() {
    return _prefs?.getBool(_keyDarkMode) ?? false;
  }

  // Notifications
  static Future<bool> setNotificationsEnabled(bool enabled) async {
    return await _prefs?.setBool(_keyNotifications, enabled) ?? false;
  }

  static bool getNotificationsEnabled() {
    return _prefs?.getBool(_keyNotifications) ?? true;
  }

  // Biometric Authentication
  static Future<bool> setBiometricEnabled(bool enabled) async {
    return await _prefs?.setBool(_keyBiometric, enabled) ?? false;
  }

  static bool getBiometricEnabled() {
    return _prefs?.getBool(_keyBiometric) ?? false;
  }

  // Language
  static Future<bool> setLanguage(String languageCode) async {
    return await _prefs?.setString(_keyLanguage, languageCode) ?? false;
  }

  static String getLanguage() {
    return _prefs?.getString(_keyLanguage) ?? 'en';
  }

  // Currency
  static Future<bool> setCurrency(String currency) async {
    return await _prefs?.setString(_keyCurrency, currency) ?? false;
  }

  static String getCurrency() {
    return _prefs?.getString(_keyCurrency) ?? 'NPR';
  }

  // ===== Onboarding Methods =====
  
  static Future<bool> setOnboardingCompleted(bool completed) async {
    return await _prefs?.setBool(_keyOnboardingCompleted, completed) ?? false;
  }

  static bool isOnboardingCompleted() {
    return _prefs?.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<bool> setFirstLaunchDate(String date) async {
    return await _prefs?.setString(_keyFirstLaunch, date) ?? false;
  }

  static String? getFirstLaunchDate() {
    return _prefs?.getString(_keyFirstLaunch);
  }

  // ===== User Preferences Methods =====
  
  static Future<bool> setDefaultShippingAddress(String address) async {
    return await _prefs?.setString(_keyDefaultShippingAddress, address) ?? false;
  }

  static String? getDefaultShippingAddress() {
    return _prefs?.getString(_keyDefaultShippingAddress);
  }

  static Future<bool> setPreferredPaymentMethod(String method) async {
    return await _prefs?.setString(_keyPreferredPaymentMethod, method) ?? false;
  }

  static String? getPreferredPaymentMethod() {
    return _prefs?.getString(_keyPreferredPaymentMethod);
  }

  // Search History (as JSON string)
  static Future<bool> setSearchHistory(List<String> history) async {
    final historyJson = history.join(',');
    return await _prefs?.setString(_keySearchHistory, historyJson) ?? false;
  }

  static List<String> getSearchHistory() {
    final historyJson = _prefs?.getString(_keySearchHistory);
    if (historyJson == null || historyJson.isEmpty) return [];
    return historyJson.split(',').where((item) => item.isNotEmpty).toList();
  }

  static Future<bool> addToSearchHistory(String query) async {
    final history = getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      // Keep only last 10 searches
      if (history.length > 10) {
        history.removeRange(10, history.length);
      }
      return await setSearchHistory(history);
    }
    return true;
  }

  static Future<bool> clearSearchHistory() async {
    return await _prefs?.remove(_keySearchHistory) ?? false;
  }

  static Future<bool> removeFromSearchHistory(String query) async {
    final history = getSearchHistory();
    history.remove(query);
    return await setSearchHistory(history);
  }

  // Last Visited Screen
  static Future<bool> setLastVisitedScreen(String screenName) async {
    return await _prefs?.setString(_keyLastVisitedScreen, screenName) ?? false;
  }

  static String? getLastVisitedScreen() {
    return _prefs?.getString(_keyLastVisitedScreen);
  }

  // ===== App State & Analytics Methods =====
  
  static Future<bool> incrementAppLaunchCount() async {
    final currentCount = getAppLaunchCount();
    return await _prefs?.setInt(_keyAppLaunchCount, currentCount + 1) ?? false;
  }

  static int getAppLaunchCount() {
    return _prefs?.getInt(_keyAppLaunchCount) ?? 0;
  }

  static Future<bool> setLastActiveDate(String date) async {
    return await _prefs?.setString(_keyLastActiveDate, date) ?? false;
  }

  static String? getLastActiveDate() {
    return _prefs?.getString(_keyLastActiveDate);
  }

  static Future<bool> setSessionDuration(int minutes) async {
    return await _prefs?.setInt(_keySessionDuration, minutes) ?? false;
  }

  static int getSessionDuration() {
    return _prefs?.getInt(_keySessionDuration) ?? 0;
  }

  // ===== Feature Flags Methods =====
  
  static Future<bool> setNewFeaturesEnabled(bool enabled) async {
    return await _prefs?.setBool(_keyNewFeaturesEnabled, enabled) ?? false;
  }

  static bool getNewFeaturesEnabled() {
    return _prefs?.getBool(_keyNewFeaturesEnabled) ?? true;
  }

  static Future<bool> setBetaFeaturesEnabled(bool enabled) async {
    return await _prefs?.setBool(_keyBetaFeatures, enabled) ?? false;
  }

  static bool getBetaFeaturesEnabled() {
    return _prefs?.getBool(_keyBetaFeatures) ?? false;
  }

  // ===== Utility Methods =====
  
  static Future<bool> clearAllData() async {
    return await _prefs?.clear() ?? false;
  }

  static Future<bool> removeKey(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  // Generic methods for custom preferences
  static Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _prefs?.setDouble(key, value) ?? false;
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defaultValue;
  }
} 