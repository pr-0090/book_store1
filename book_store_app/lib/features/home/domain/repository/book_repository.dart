import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/home/data/data_source/remote_data_source/book_remote_data_source.dart';
import 'package:book_store/features/home/domain/entity/book.dart';
import 'package:dartz/dartz.dart';

class IBookRepository {
  final BookRemoteDatasource _remoteDatasource;

  IBookRepository({required BookRemoteDatasource remoteDatasource})
    : _remoteDatasource = remoteDatasource;

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

  // Implement other methods similarly, e.g., addBook, deleteBook, updateBook
}
