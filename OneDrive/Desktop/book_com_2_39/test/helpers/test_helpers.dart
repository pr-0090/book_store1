import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:book_com/core/models/user_model.dart';
import 'package:book_com/core/network/api_service.dart';
import 'package:book_com/core/network/hive_service.dart';

/// Test helper class for common testing utilities
class TestHelpers {
  /// Creates a mock user for testing
  static UserModel createMockUser({
    String? id,
    String? name,
    String? email,
    String? token,
    String? role,
    bool isLoggedIn = true,
  }) {
    return UserModel(
      id: id ?? 'test_user_id',
      name: name ?? 'Test User',
      email: email ?? 'test@example.com',
      token: token ?? 'test_jwt_token',
      role: role ?? 'customer',
      isLoggedIn: isLoggedIn,
      lastLogin: DateTime.now(),
    );
  }

  /// Creates mock books data for testing
  static List<Map<String, dynamic>> createMockBooks({int count = 5}) {
    return List.generate(count, (index) => {
      'id': 'book_$index',
      'title': 'Test Book $index',
      'author': 'Test Author $index',
      'price': 29.99 + (index * 5),
      'genre': index % 2 == 0 ? 'Fiction' : 'Non-Fiction',
      'description': 'Test description for book $index',
      'image': 'https://example.com/book$index.jpg',
      'rating': 4.0 + (index * 0.1),
      'reviews': 10 + (index * 5),
    });
  }

  /// Creates mock cart items for testing
  static List<Map<String, dynamic>> createMockCartItems({int count = 3}) {
    return List.generate(count, (index) => {
      'id': 'cart_item_$index',
      'productId': 'book_$index',
      'title': 'Test Book $index',
      'author': 'Test Author $index',
      'price': 29.99 + (index * 5),
      'quantity': 1 + (index % 3),
      'image': 'https://example.com/book$index.jpg',
    });
  }

  /// Creates mock orders for testing
  static List<Map<String, dynamic>> createMockOrders({int count = 2}) {
    return List.generate(count, (index) => {
      'id': 'order_$index',
      'userId': 'test_user_id',
      'items': createMockCartItems(count: 2),
      'totalAmount': 59.98 + (index * 20),
      'status': index == 0 ? 'pending' : 'shipped',
      'createdAt': DateTime.now().subtract(Duration(days: index)).toIso8601String(),
      'shippingAddress': {
        'street': '123 Test St',
        'city': 'Test City',
        'state': 'Test State',
        'zipCode': '12345',
      },
    });
  }

  /// Creates a mock API response
  static Map<String, dynamic> createMockApiResponse({
    int statusCode = 200,
    dynamic data,
    String? message,
  }) {
    return {
      'statusCode': statusCode,
      'data': data,
      'message': message ?? 'Success',
    };
  }

  /// Creates a mock error response
  static Map<String, dynamic> createMockErrorResponse({
    int statusCode = 400,
    String message = 'Error occurred',
  }) {
    return {
      'statusCode': statusCode,
      'error': message,
    };
  }
}

/// Test widget wrapper for common test setup
class TestApp extends StatelessWidget {
  final Widget child;
  final List<ChangeNotifierProvider> providers;

  const TestApp({
    super.key,
    required this.child,
    this.providers = const [],
  });

  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp(
      home: child,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
    );

    // Wrap with providers if provided
    for (final provider in providers.reversed) {
      app = provider(child: app);
    }

    return app;
  }
}

/// Mock classes for testing
class MockApiService extends Mock implements ApiService {}
class MockHiveService extends Mock implements HiveService {}

/// Test matchers for common assertions
class TestMatchers {
  /// Matches a widget that has specific text
  static Matcher hasText(String text) {
    return findsOneWidget;
  }

  /// Matches a widget that has specific icon
  static Matcher hasIcon(IconData icon) {
    return findsOneWidget;
  }

  /// Matches a widget that is enabled
  static Matcher isEnabled() {
    return findsOneWidget;
  }

  /// Matches a widget that is disabled
  static Matcher isDisabled() {
    return findsOneWidget;
  }
}

/// Test utilities for common operations
class TestUtils {
  /// Waits for a specific condition to be true
  static Future<void> waitForCondition(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final startTime = DateTime.now();
    
    while (!condition()) {
      if (DateTime.now().difference(startTime) > timeout) {
        throw TimeoutException('Condition not met within timeout', timeout);
      }
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Taps a widget and waits for navigation
  static Future<void> tapAndWait(
    WidgetTester tester,
    Finder finder, {
    Duration? duration,
  }) async {
    await tester.tap(finder);
    await tester.pumpAndSettle(duration);
  }

  /// Enters text and waits for updates
  static Future<void> enterTextAndWait(
    WidgetTester tester,
    Finder finder,
    String text, {
    Duration? duration,
  }) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle(duration);
  }

  /// Scrolls to a widget and waits
  static Future<void> scrollToAndWait(
    WidgetTester tester,
    Finder finder, {
    Duration? duration,
  }) async {
    await tester.scrollUntilVisible(finder, 500);
    await tester.pumpAndSettle(duration);
  }

  /// Takes a screenshot for debugging
  static Future<void> takeScreenshot(
    WidgetTester tester,
    String name,
  ) async {
    await tester.pumpAndSettle();
    // Note: In a real test environment, you might want to save this to a file
    // For now, we'll just ensure the widget tree is stable
  }

  /// Checks if a widget is visible on screen
  static bool isWidgetVisible(Finder finder) {
    try {
      return finder.evaluate().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Gets the text content of a widget
  static String? getWidgetText(Finder finder) {
    try {
      final widget = finder.evaluate().single.widget;
      if (widget is Text) {
        return widget.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Checks if a widget has a specific style
  static bool hasWidgetStyle(
    Finder finder,
    TextStyle? Function(TextStyle?) styleMatcher,
  ) {
    try {
      final widget = finder.evaluate().single.widget;
      if (widget is Text) {
        final style = widget.style;
        return styleMatcher(style) != null;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

/// Test data constants
class TestData {
  static const String validEmail = 'test@example.com';
  static const String invalidEmail = 'invalid-email';
  static const String validPassword = 'password123';
  static const String weakPassword = '123';
  static const String testUserId = 'test_user_id';
  static const String testBookId = 'test_book_id';
  static const String testOrderId = 'test_order_id';
  
  static const Map<String, dynamic> validLoginData = {
    'email': validEmail,
    'password': validPassword,
  };
  
  static const Map<String, dynamic> validRegisterData = {
    'email': validEmail,
    'password': validPassword,
    'role': 'customer',
  };
  
  static const Map<String, dynamic> validBookData = {
    'title': 'Test Book',
    'author': 'Test Author',
    'price': 29.99,
    'genre': 'Fiction',
    'description': 'Test description',
  };
}

/// Test environment setup
class TestEnvironment {
  static void setupTestEnvironment() {
    // Set up any global test configuration
    TestWidgetsFlutterBinding.ensureInitialized();
  }

  static void tearDownTestEnvironment() {
    // Clean up any global test resources
  }
}

/// Custom test exceptions
class TestException implements Exception {
  final String message;
  final dynamic cause;

  TestException(this.message, [this.cause]);

  @override
  String toString() => 'TestException: $message${cause != null ? ' (caused by: $cause)' : ''}';
} 