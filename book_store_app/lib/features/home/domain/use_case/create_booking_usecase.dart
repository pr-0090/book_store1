import 'package:book_store/app/shared_pref/token_shared_prefs.dart';
import 'package:book_store/app/use_case/use_case.dart';
import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/home/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';

class CreateBookingParams {
  final String bookId;
  final int quantity;
  final String buyerName;
  final String shippingAddress;
  final double totalPrice;

  CreateBookingParams({
    required this.bookId,
    required this.quantity,
    required this.buyerName,
    required this.shippingAddress,
    required this.totalPrice,
  });
}

class CreateBookingUsecase
    implements UseCaseWithParams<void, CreateBookingParams> {
  final IBookRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  CreateBookingUsecase({
    required IBookRepository repository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _repository = repository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, void>> call(CreateBookingParams params) async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      (token) => _repository.createBooking(
        token,
        params.bookId,
        quantity: params.quantity,
        buyerName: params.buyerName,
        shippingAddress: params.shippingAddress,
        totalPrice: params.totalPrice,
      ),
    );
  }
}
