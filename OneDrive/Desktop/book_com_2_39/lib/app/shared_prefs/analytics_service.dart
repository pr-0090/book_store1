import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static const String _keyTotalSessionTime = 'total_session_time';
  static const String _keyBooksViewed = 'books_viewed';
  static const String _keySearchesPerformed = 'searches_performed';
  static const String _keyCartItemsAdded = 'cart_items_added';
  static const String _keyOrdersPlaced = 'orders_placed';
  static const String _keyFavoriteCategories = 'favorite_categories';
  static const String _keyLastBookViewed = 'last_book_viewed';
  static const String _keySessionStartTime = 'session_start_time';

  // Session tracking
  static Future<void> startSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySessionStartTime, DateTime.now().toIso8601String());
  }

  static Future<void> endSession() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeStr = prefs.getString(_keySessionStartTime);
    
    if (startTimeStr != null) {
      final startTime = DateTime.parse(startTimeStr);
      final endTime = DateTime.now();
      final sessionDuration = endTime.difference(startTime).inMinutes;
      
      // Add to total session time
      final currentTotal = prefs.getInt(_keyTotalSessionTime) ?? 0;
      await prefs.setInt(_keyTotalSessionTime, currentTotal + sessionDuration);
      
      // Clear session start time
      await prefs.remove(_keySessionStartTime);
    }
  }

  // Book viewing tracking
  static Future<void> trackBookViewed(String bookId, String bookTitle) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Increment books viewed count
    final currentCount = prefs.getInt(_keyBooksViewed) ?? 0;
    await prefs.setInt(_keyBooksViewed, currentCount + 1);
    
    // Store last viewed book
    await prefs.setString(_keyLastBookViewed, '$bookId:$bookTitle');
  }

  // Search tracking
  static Future<void> trackSearchPerformed(String searchTerm) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_keySearchesPerformed) ?? 0;
    await prefs.setInt(_keySearchesPerformed, currentCount + 1);
  }

  // Cart tracking
  static Future<void> trackCartItemAdded(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_keyCartItemsAdded) ?? 0;
    await prefs.setInt(_keyCartItemsAdded, currentCount + 1);
  }

  // Order tracking
  static Future<void> trackOrderPlaced(double orderAmount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_keyOrdersPlaced) ?? 0;
    await prefs.setInt(_keyOrdersPlaced, currentCount + 1);
  }

  // Category preference tracking
  static Future<void> trackCategoryViewed(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesStr = prefs.getString(_keyFavoriteCategories) ?? '';
    final categories = categoriesStr.isEmpty ? [] : categoriesStr.split(',');
    
    if (!categories.contains(category)) {
      categories.add(category);
      await prefs.setString(_keyFavoriteCategories, categories.join(','));
    }
  }

  // Analytics getters
  static Future<int> getTotalSessionTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalSessionTime) ?? 0;
  }

  static Future<int> getBooksViewed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyBooksViewed) ?? 0;
  }

  static Future<int> getSearchesPerformed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keySearchesPerformed) ?? 0;
  }

  static Future<int> getCartItemsAdded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCartItemsAdded) ?? 0;
  }

  static Future<int> getOrdersPlaced() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyOrdersPlaced) ?? 0;
  }

  static Future<List<String>> getFavoriteCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesStr = prefs.getString(_keyFavoriteCategories) ?? '';
    return categoriesStr.isEmpty ? [] : categoriesStr.split(',');
  }

  static Future<String?> getLastBookViewed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastBookViewed);
  }

  // Get comprehensive analytics
  static Future<Map<String, dynamic>> getAnalytics() async {
    return {
      'totalSessionTime': await getTotalSessionTime(),
      'booksViewed': await getBooksViewed(),
      'searchesPerformed': await getSearchesPerformed(),
      'cartItemsAdded': await getCartItemsAdded(),
      'ordersPlaced': await getOrdersPlaced(),
      'favoriteCategories': await getFavoriteCategories(),
      'lastBookViewed': await getLastBookViewed(),
    };
  }

  // Clear analytics data
  static Future<void> clearAnalytics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTotalSessionTime);
    await prefs.remove(_keyBooksViewed);
    await prefs.remove(_keySearchesPerformed);
    await prefs.remove(_keyCartItemsAdded);
    await prefs.remove(_keyOrdersPlaced);
    await prefs.remove(_keyFavoriteCategories);
    await prefs.remove(_keyLastBookViewed);
    await prefs.remove(_keySessionStartTime);
  }
} 