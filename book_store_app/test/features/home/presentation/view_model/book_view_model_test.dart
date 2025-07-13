import 'package:bloc_test/bloc_test.dart';
import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/home/domain/entity/book.dart';
import 'package:book_store/features/home/domain/use_case/get_all_books_usecase.dart';
import 'package:book_store/features/home/presentation/view_model/book_event.dart';
import 'package:book_store/features/home/presentation/view_model/book_state.dart';
import 'package:book_store/features/home/presentation/view_model/book_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllBooksUsecase extends Mock implements GetAllBooksUsecase {}

void main() {
  late MockGetAllBooksUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockGetAllBooksUsecase();
  });

  group('BookBloc Tests', () {
    blocTest<BookBloc, BookState>(
      'emits [BookLoading, BookLoaded] when FetchBooksEvent succeeds',
      build: () {
        when(
          () => mockUsecase(),
        ).thenAnswer((_) async => const Right(<BookEntity>[]));
        return BookBloc(getAllBooksUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(FetchBooksEvent()),
      expect: () => [BookLoading(), const BookLoaded([])],
    );

    blocTest<BookBloc, BookState>(
      'emits [BookLoading, BookError] when FetchBooksEvent fails',
      build: () {
        when(() => mockUsecase()).thenAnswer(
          (_) async => Left(ApiFailure(message: 'API request failed')),
        );
        return BookBloc(getAllBooksUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(FetchBooksEvent()),
      expect: () => [BookLoading(), const BookError('API request failed')],
      verify: (_) => verify(() => mockUsecase()).called(1),
    );
  });
}
