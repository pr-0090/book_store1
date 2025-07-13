import 'package:book_store/features/home/domain/entity/book.dart';

abstract interface class IBookDatasource {
  Future<List<BookEntity>> getAllBooks(String? token);

  Future<BookEntity> getBookById(String? token, String bookId);

  Future<void> addBook(String? token, BookEntity bookEntity);

  Future<void> updateBook(String? token, String bookId, BookEntity bookEntity);

  Future<void> deleteBook(String? token, String bookId);
}
