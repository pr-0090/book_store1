import 'package:book_store/features/home/domain/entity/book.dart';

abstract interface class IBookDatasource {
  Future<List<BookEntity>> getAllBooks(String? token);

  Future<void> createBooking(
    String? token,
    String bookId, {
    required int quantity,
    required String buyerName,
    required String shippingAddress,
    required double totalPrice,
  });
}
