import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/home/domain/use_case/get_all_books_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetAllBooksUsecase getAllBooksUsecase;

  BookBloc({required this.getAllBooksUsecase}) : super(BookInitial()) {
    on<FetchBooksEvent>((event, emit) async {
      emit(BookLoading());
      final failureOrBooks = await getAllBooksUsecase();

      failureOrBooks.fold(
        (failure) => emit(BookError(_mapFailureToMessage(failure))),
        (books) => emit(BookLoaded(books)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    // Customize error messages based on failure type if needed
    return failure.toString();
  }
}
