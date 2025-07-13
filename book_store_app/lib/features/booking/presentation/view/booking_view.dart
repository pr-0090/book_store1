import 'package:flutter/material.dart';

class BookingView extends StatefulWidget {
  const BookingView({super.key});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "My Book Orders",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
