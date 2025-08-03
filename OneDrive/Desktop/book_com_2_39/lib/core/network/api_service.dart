import 'package:dio/dio.dart';
import '../../app/constants/app_constants.dart';
import 'hive_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Automatically add auth token if available
          final token = HiveService.getUserToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );
  }

  // Authentication methods
  Future<Response> register(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.authRegister, data: data);
  }

  Future<Response> login(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.authLogin, data: data);
  }

  Future<Response> requestOtp(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.authRequestOtp, data: data);
  }

  Future<Response> verifyOtp(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.authVerifyOtp, data: data);
  }

  Future<Response> resetPassword(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.authResetPassword, data: data);
  }

  Future<Response> getCurrentUser() async {
    return await _dio.get(AppConstants.authMe);
  }

  // Product methods
  Future<Response> getAllProducts() async {
    return await _dio.get(AppConstants.productsFindAll);
  }

  Future<Response> getProductById(String id) async {
    return await _dio.get('${AppConstants.productsById}$id');
  }

  Future<Response> createProduct(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.productsSave, data: data);
  }

  Future<Response> updateProduct(String id, Map<String, dynamic> data) async {
    return await _dio.put('${AppConstants.productsById}$id', data: data);
  }

  Future<Response> deleteProduct(String id) async {
    return await _dio.delete('${AppConstants.productsById}$id');
  }

  // Cart methods
  Future<Response> addToCart(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.cartAdd, data: data);
  }

  Future<Response> getCart(String userId) async {
    return await _dio.get('${AppConstants.cartGet}$userId');
  }

  Future<Response> removeFromCart(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.cartRemove, data: data);
  }

  Future<Response> clearCart(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.cartClear, data: data);
  }

  Future<Response> updateCartItem(Map<String, dynamic> data) async {
    return await _dio.patch(AppConstants.cartUpdate, data: data);
  }

  // Wishlist methods
  Future<Response> addToWishlist(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.wishlistAdd, data: data);
  }

  Future<Response> getWishlist(String userId) async {
    return await _dio.get('${AppConstants.wishlistGet}$userId');
  }

  Future<Response> removeFromWishlist(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.wishlistRemove, data: data);
  }

  Future<Response> clearWishlist(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.wishlistClear, data: data);
  }

  // Order methods
  Future<Response> createOrder(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.ordersCreate, data: data);
  }

  Future<Response> getUserOrders(String userId) async {
    return await _dio.get('${AppConstants.ordersUser}$userId');
  }

  Future<Response> getAllOrders() async {
    return await _dio.get(AppConstants.ordersAll);
  }

  Future<Response> updateOrderStatus(String id, Map<String, dynamic> data) async {
    return await _dio.put('${AppConstants.ordersUpdate}$id', data: data);
  }

  Future<Response> deleteOrder(String id) async {
    return await _dio.delete('${AppConstants.ordersDelete}$id');
  }

  // Address methods
  Future<Response> createAddress(Map<String, dynamic> data) async {
    return await _dio.post(AppConstants.addressCreate, data: data);
  }

  Future<Response> getAddress() async {
    return await _dio.get(AppConstants.addressGet);
  }

  Future<Response> deleteAddress() async {
    return await _dio.delete(AppConstants.addressDelete);
  }

  // Helper method to add authorization header
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Helper method to remove authorization header
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
} 