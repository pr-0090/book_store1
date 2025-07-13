import 'package:book_store/features/home/data/data_source/book_datasource.dart';
import 'package:book_store/features/home/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:book_store/core/error/failure.dart';

import 'package:book_store/features/home/domain/entity/book.dart';

class BookRemoteRepository implements IBookRepository {
  final IBookDatasource _remoteDatasource;

  BookRemoteRepository({required IBookDatasource remoteDatasource})
    : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<BookEntity>>> getAllBooks(String? token) async {
    try {
      final books = await _remoteDatasource.getAllBooks(token);
      return Right(books);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to fetch books: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> createBooking(
    String? token,
    String bookId, {
    required int quantity,
    required String buyerName,
    required String shippingAddress,
    required double totalPrice,
  }) async {
    try {
      await _remoteDatasource.createBooking(
        token,
        bookId,
        quantity: quantity,
        buyerName: buyerName,
        shippingAddress: shippingAddress,
        totalPrice: totalPrice,
      );
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to create purchase: ${e.toString()}"),
      );
    }
  }
}
