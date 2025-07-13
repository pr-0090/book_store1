import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/home/domain/use_case/get_all_books_usecase.dart';
import 'package:book_store/features/home/presentation/view_model/book_event.dart';
import 'package:book_store/features/home/presentation/view_model/book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    if (failure is ApiFailure) {
      return failure.message;
    }
    return 'Unexpected error';
  }
}
