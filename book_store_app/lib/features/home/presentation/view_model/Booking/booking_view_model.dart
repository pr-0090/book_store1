import 'package:book_store/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_store/core/error/failure.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUsecase createBookingUsecase;

  BookingBloc({required this.createBookingUsecase}) : super(BookingInitial()) {
    on<SubmitBooking>((event, emit) async {
      emit(BookingSubmitting());

      final result = await createBookingUsecase.call(
        CreateBookingParams(
          bookId: event.bookId,
          quantity: event.quantity,
          buyerName: event.buyerName,
          shippingAddress: event.shippingAddress,
          totalPrice: event.totalPrice,
        ),
      );

      result.fold(
        (failure) => emit(BookingFailure(_mapFailureToMessage(failure))),
        (_) => emit(BookingSuccess()),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message ?? 'An unexpected error occurred';
  }
}
