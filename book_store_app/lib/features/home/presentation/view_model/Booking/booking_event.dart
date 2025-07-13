// booking_event.dart
import 'package:equatable/equatable.dart';

class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class SubmitBooking extends BookingEvent {
  final String bookId;
  final int quantity;
  final String buyerName;
  final String shippingAddress;
  final double totalPrice;

  SubmitBooking({
    required this.bookId,
    required this.quantity,
    required this.buyerName,
    required this.shippingAddress,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [
    bookId,
    quantity,
    buyerName,
    shippingAddress,
    totalPrice,
  ];
}
