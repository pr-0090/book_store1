import 'package:book_store/app/constant/api_endpoints.dart';
import 'package:book_store/core/network/app_service.dart';
import 'package:book_store/features/home/data/data_source/book_datasource.dart';
import 'package:book_store/features/home/data/dto/get_all_books_dto.dart';
import 'package:book_store/features/home/data/model/book_api_model.dart';
import 'package:book_store/features/home/domain/entity/book.dart';
import 'package:dio/dio.dart';

class BookRemoteDatasource implements IBookDatasource {
  final ApiService _apiService;
  BookRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<BookEntity>> getAllBooks(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getAllBooks,
        // Remove the header since it's unnecessary
      );

      if (response.statusCode == 200) {
        GetAllBooksDto dto = GetAllBooksDto.fromJson(response.data);
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
  Future<BookEntity> getBookById(String? token, String bookId) async {
    try {
      final response = await _apiService.dio.get(
        "${ApiEndpoints.getAllBooks}$bookId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final bookApiModel = BookApiModel.fromJson(response.data);
        return bookApiModel.toEntity();
      } else {
        throw Exception(
          "Failed to fetch book details: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to fetch book details: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred: $e");
    }
  }

  @override
  Future<void> addBook(String? token, BookEntity bookEntity) async {
    try {
      final bookApiModel = BookApiModel.fromEntity(bookEntity);

      final response = await _apiService.dio.post(
        ApiEndpoints.getAllBooks,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: bookApiModel.toJson(),
      );

      if (response.statusCode == 201) {
        return Future.value();
      } else {
        throw Exception("Failed to add book: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to add book: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred while adding book: $e");
    }
  }

  @override
  Future<void> updateBook(
    String? token,
    String bookId,
    BookEntity bookEntity,
  ) async {
    try {
      final bookApiModel = BookApiModel.fromEntity(bookEntity);

      final response = await _apiService.dio.put(
        "${ApiEndpoints.getAllBooks}$bookId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: bookApiModel.toJson(),
      );

      if (response.statusCode == 200) {
        return Future.value();
      } else {
        throw Exception("Failed to update book: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to update book: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred while updating book: $e");
    }
  }

  @override
  Future<void> deleteBook(String? token, String bookId) async {
    try {
      final response = await _apiService.dio.delete(
        "${ApiEndpoints.getAllBooks}$bookId",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return Future.value();
      } else {
        throw Exception("Failed to delete book: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to delete book: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error occurred while deleting book: $e");
    }
  }
}
