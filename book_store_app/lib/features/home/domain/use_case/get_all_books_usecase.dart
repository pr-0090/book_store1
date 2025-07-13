import 'package:book_store/app/shared_pref/token_shared_prefs.dart';
import 'package:book_store/app/use_case/use_case.dart';
import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/home/domain/entity/book.dart';
import 'package:book_store/features/home/domain/repository/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllBooksUsecase implements UseCaseWithoutParams<List<BookEntity>> {
  final IBookRepository _bookRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  GetAllBooksUsecase({
    required IBookRepository bookRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _bookRepository = bookRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, List<BookEntity>>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _bookRepository.getAllBooks(tokenValue),
    );
  }
}
