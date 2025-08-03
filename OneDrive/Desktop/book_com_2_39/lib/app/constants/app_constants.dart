class AppConstants {
  // static const String baseUrl = 'http://192.168.18.12:8080/api';
  static const String baseUrl = 'http://192.168.18.12:8080/api';

  // App Configuration
  static const String appName = 'Book.com';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRequestOtp = '/auth/request-otp';
  static const String authVerifyOtp = '/auth/verify-otp';
  static const String authResetPassword = '/auth/reset-password';
  static const String authMe = '/auth/me';

  static const String productsFindAll = '/products/findall';
  static const String productsSave = '/products/save';
  static const String productsById = '/products/';

  static const String cartAdd = '/cart/add';
  static const String cartGet = '/cart/';
  static const String cartRemove = '/cart/remove';
  static const String cartClear = '/cart/clear';
  static const String cartUpdate = '/cart/update';

  static const String wishlistAdd = '/wishlist/add';
  static const String wishlistGet = '/wishlist/';
  static const String wishlistRemove = '/wishlist/remove';
  static const String wishlistClear = '/wishlist/clear';

  static const String ordersCreate = '/orders/create';
  static const String ordersUser = '/orders/user/';
  static const String ordersAll = '/orders/';
  static const String ordersUpdate = '/orders/update/';
  static const String ordersDelete = '/orders/delete/';

  static const String addressCreate = '/address/';
  static const String addressGet = '/address/';
  static const String addressDelete = '/address/';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String onboardingKey = 'onboarding_completed';

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration fadeAnimationDuration = Duration(seconds: 2);
  static const Duration loadingAnimationDuration = Duration(seconds: 2);
}
