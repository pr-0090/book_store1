import 'package:book_store/app/constant/api_endpoints.dart';
import 'package:book_store/core/network/app_service.dart';
import 'package:book_store/features/home/data/data_source/book_datasource.dart';
import 'package:book_store/features/home/data/dto/get_all_books_dto.dart';
import 'package:dio/dio.dart';

import 'package:book_store/features/home/data/model/book_api_model.dart';

import 'package:book_store/features/home/domain/entity/book.dart';

class BookRemoteDatasource implements IBookDatasource {
  final ApiService _apiService;

  BookRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<BookEntity>> getAllBooks(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getAllBooks,
        // No headers if unnecessary
      );

      if (response.statusCode == 200) {
        final dto = GetAllBooksDto.fromJson(response.data);
        return BookApiModel.toEntityList(dto.data);
      } else {
        throw Exception("Failed to fetch books: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to fetch books: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred: $e");
    }
  }

  @override
  Future<void> createBooking(
    String? token,
    String bookId, {
    required int quantity,
    required String buyerName,
    required String shippingAddress,
    required double totalPrice,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.createBooking,
        data: {
          "bookId": bookId,
          "quantity": quantity,
          "buyerName": buyerName,
          "shippingAddress": shippingAddress,
          "totalPrice": totalPrice,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception("Failed to create purchase: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Purchase failed: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
