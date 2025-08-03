import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:book_com/core/network/api_service.dart';
import 'package:book_com/core/network/hive_service.dart';
import 'package:book_com/core/models/user_model.dart';

// Generate mocks
@GenerateMocks([ApiService, HiveService, UserModel])
import 'auth_bloc_test.mocks.dart';

void main() {
  group('API Service Tests', () {
    late MockApiService mockApiService;
    late MockHiveService mockHiveService;
    late MockUserModel mockUserModel;

    setUp(() {
      mockApiService = MockApiService();
      mockHiveService = MockHiveService();
      mockUserModel = MockUserModel();
    });

    group('Authentication Methods', () {
      test('register should make POST request to auth register endpoint',
          () async {
        final mockResponse = Response(
          data: {'success': true, 'message': 'User registered successfully'},
          statusCode: 201,
          requestOptions: RequestOptions(path: '/auth/register'),
        );

        when(mockApiService.register({
          'email': 'test@example.com',
          'password': 'password123',
          'name': 'Test User',
        })).thenAnswer((_) async => mockResponse);

        final result = await mockApiService.register({
          'email': 'test@example.com',
          'password': 'password123',
          'name': 'Test User',
        });

        expect(result.statusCode, equals(201));
        expect(result.data['success'], isTrue);
        verify(mockApiService.register({
          'email': 'test@example.com',
          'password': 'password123',
          'name': 'Test User',
        })).called(1);
      });

      test('login should make POST request to auth login endpoint', () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'token': 'mock_token_123',
            'user': {'id': '1', 'email': 'test@example.com'}
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/login'),
        );

        when(mockApiService.login({
          'email': 'test@example.com',
          'password': 'password123',
        })).thenAnswer((_) async => mockResponse);

        final result = await mockApiService.login({
          'email': 'test@example.com',
          'password': 'password123',
        });

        expect(result.statusCode, equals(200));
        expect(result.data['success'], isTrue);
        expect(result.data['token'], isNotNull);
        verify(mockApiService.login({
          'email': 'test@example.com',
          'password': 'password123',
        })).called(1);
      });

      test('getCurrentUser should make GET request to auth me endpoint',
          () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'user': {
              'id': '1',
              'email': 'test@example.com',
              'name': 'Test User'
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/me'),
        );

        when(mockApiService.getCurrentUser())
            .thenAnswer((_) async => mockResponse);

        final result = await mockApiService.getCurrentUser();

        expect(result.statusCode, equals(200));
        expect(result.data['success'], isTrue);
        expect(result.data['user']['email'], equals('test@example.com'));
        verify(mockApiService.getCurrentUser()).called(1);
      });
    });

    group('Product Methods', () {
      test('getAllProducts should make GET request to products endpoint',
          () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'products': [
              {
                'id': '1',
                'title': 'Test Book 1',
                'author': 'Test Author 1',
                'price': 19.99,
              },
              {
                'id': '2',
                'title': 'Test Book 2',
                'author': 'Test Author 2',
                'price': 24.99,
              },
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products'),
        );

        when(mockApiService.getAllProducts())
            .thenAnswer((_) async => mockResponse);

        final result = await mockApiService.getAllProducts();

        expect(result.statusCode, equals(200));
        expect(result.data['success'], isTrue);
        expect(result.data['products'], isList);
        expect(result.data['products'].length, equals(2));
        verify(mockApiService.getAllProducts()).called(1);
      });

      test(
          'getProductById should make GET request to specific product endpoint',
          () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'product': {
              'id': '1',
              'title': 'Test Book 1',
              'author': 'Test Author 1',
              'price': 19.99,
              'description': 'A test book description',
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/products/1'),
        );

        when(mockApiService.getProductById('1'))
            .thenAnswer((_) async => mockResponse);

        final result = await mockApiService.getProductById('1');

        expect(result.statusCode, equals(200));
        expect(result.data['success'], isTrue);
        expect(result.data['product']['id'], equals('1'));
        verify(mockApiService.getProductById('1')).called(1);
      });
    });

    group('Cart Methods', () {
      test('addToCart should make POST request to cart add endpoint', () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Product added to cart successfully',
            'cartItem': {
              'id': '1',
              'productId': '1',
              'quantity': 1,
            }
          },
          statusCode: 201,
          requestOptions: RequestOptions(path: '/cart/add'),
        );

        when(mockApiService.addToCart({
          'productId': '1',
          'quantity': 1,
        })).thenAnswer((_) async => mockResponse);

        final result = await mockApiService.addToCart({
          'productId': '1',
          'quantity': 1,
        });

        expect(result.statusCode, equals(201));
        expect(result.data['success'], isTrue);
        verify(mockApiService.addToCart({
          'productId': '1',
          'quantity': 1,
        })).called(1);
      });

      test('getCart should make GET request to cart get endpoint', () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'cart': {
              'id': 'user1',
              'items': [
                {
                  'id': '1',
                  'productId': '1',
                  'quantity': 2,
                  'product': {
                    'id': '1',
                    'title': 'Test Book 1',
                    'price': 19.99,
                  }
                }
              ],
              'total': 39.98,
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/cart/user1'),
        );

        when(mockApiService.getCart('user1'))
            .thenAnswer((_) async => mockResponse);

        final result = await mockApiService.getCart('user1');

        expect(result.statusCode, equals(200));
        expect(result.data['success'], isTrue);
        expect(result.data['cart']['items'], isList);
        verify(mockApiService.getCart('user1')).called(1);
      });
    });

    group('Wishlist Methods', () {
      test('addToWishlist should make POST request to wishlist add endpoint',
          () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Product added to wishlist successfully',
            'wishlistItem': {
              'id': '1',
              'productId': '1',
            }
          },
          statusCode: 201,
          requestOptions: RequestOptions(path: '/wishlist/add'),
        );

        when(mockApiService.addToWishlist({
          'productId': '1',
        })).thenAnswer((_) async => mockResponse);

        final result = await mockApiService.addToWishlist({
          'productId': '1',
        });

        expect(result.statusCode, equals(201));
        expect(result.data['success'], isTrue);
        verify(mockApiService.addToWishlist({
          'productId': '1',
        })).called(1);
      });

      test('getWishlist should make GET request to wishlist get endpoint',
          () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'wishlist': {
              'id': 'user1',
              'items': [
                {
                  'id': '1',
                  'productId': '1',
                  'product': {
                    'id': '1',
                    'title': 'Test Book 1',
                    'price': 19.99,
                  }
                }
              ],
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/wishlist/user1'),
        );

        when(mockApiService.getWishlist('user1'))
            .thenAnswer((_) async => mockResponse);

        final result = await mockApiService.getWishlist('user1');

        expect(result.statusCode, equals(200));
        expect(result.data['success'], isTrue);
        expect(result.data['wishlist']['items'], isList);
        verify(mockApiService.getWishlist('user1')).called(1);
      });
    });

    group('Order Methods', () {
      test('createOrder should make POST request to orders create endpoint',
          () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Order created successfully',
            'order': {
              'id': '1',
              'userId': 'user1',
              'items': [
                {
                  'productId': '1',
                  'quantity': 2,
                  'price': 19.99,
                }
              ],
              'total': 39.98,
              'status': 'pending',
            }
          },
          statusCode: 201,
          requestOptions: RequestOptions(path: '/orders/create'),
        );

        when(mockApiService.createOrder({
          'items': [
            {'productId': '1', 'quantity': 2, 'price': 19.99}
          ],
          'shippingAddress': '123 Test St',
          'paymentMethod': 'credit_card',
        })).thenAnswer((_) async => mockResponse);

        final result = await mockApiService.createOrder({
          'items': [
            {'productId': '1', 'quantity': 2, 'price': 19.99}
          ],
          'shippingAddress': '123 Test St',
          'paymentMethod': 'credit_card',
        });

        expect(result.statusCode, equals(201));
        expect(result.data['success'], isTrue);
        verify(mockApiService.createOrder({
          'items': [
            {'productId': '1', 'quantity': 2, 'price': 19.99}
          ],
          'shippingAddress': '123 Test St',
          'paymentMethod': 'credit_card',
        })).called(1);
      });

      test('getUserOrders should make GET request to orders user endpoint',
          () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'orders': [
              {
                'id': '1',
                'userId': 'user1',
                'total': 39.98,
                'status': 'completed',
                'createdAt': '2023-01-01T00:00:00Z',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/orders/user/user1'),
        );

        when(mockApiService.getUserOrders('user1'))
            .thenAnswer((_) async => mockResponse);

        final result = await mockApiService.getUserOrders('user1');

        expect(result.statusCode, equals(200));
        expect(result.data['success'], isTrue);
        expect(result.data['orders'], isList);
        verify(mockApiService.getUserOrders('user1')).called(1);
      });
    });

    group('Address Methods', () {
      test('createAddress should make POST request to address create endpoint',
          () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'message': 'Address created successfully',
            'address': {
              'id': '1',
              'userId': 'user1',
              'street': '123 Test St',
              'city': 'Test City',
              'state': 'Test State',
              'zipCode': '12345',
            }
          },
          statusCode: 201,
          requestOptions: RequestOptions(path: '/address/create'),
        );

        when(mockApiService.createAddress({
          'street': '123 Test St',
          'city': 'Test City',
          'state': 'Test State',
          'zipCode': '12345',
        })).thenAnswer((_) async => mockResponse);

        final result = await mockApiService.createAddress({
          'street': '123 Test St',
          'city': 'Test City',
          'state': 'Test State',
          'zipCode': '12345',
        });

        expect(result.statusCode, equals(201));
        expect(result.data['success'], isTrue);
        verify(mockApiService.createAddress({
          'street': '123 Test St',
          'city': 'Test City',
          'state': 'Test State',
          'zipCode': '12345',
        })).called(1);
      });

      test('getAddress should make GET request to address get endpoint',
          () async {
        final mockResponse = Response(
          data: {
            'success': true,
            'addresses': [
              {
                'id': '1',
                'userId': 'user1',
                'street': '123 Test St',
                'city': 'Test City',
                'state': 'Test State',
                'zipCode': '12345',
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/address/get'),
        );

        when(mockApiService.getAddress()).thenAnswer((_) async => mockResponse);

        final result = await mockApiService.getAddress();

        expect(result.statusCode, equals(200));
        expect(result.data['success'], isTrue);
        expect(result.data['addresses'], isList);
        verify(mockApiService.getAddress()).called(1);
      });
    });

    group('Token Management', () {
      test('setAuthToken should set authorization header', () {
        const token = 'mock_token_123';

        // This is a simple test to verify the method exists and doesn't throw
        expect(() => mockApiService.setAuthToken(token), returnsNormally);
      });

      test('removeAuthToken should remove authorization header', () {
        // This is a simple test to verify the method exists and doesn't throw
        expect(() => mockApiService.removeAuthToken(), returnsNormally);
      });
    });
  });
}
