import 'package:book_store/features/home/domain/entity/book.dart';
import 'package:book_store/features/home/presentation/view_model/Booking/booking_event.dart';
import 'package:book_store/features/home/presentation/view_model/Booking/booking_state.dart';
import 'package:book_store/features/home/presentation/view_model/Booking/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingScreen extends StatefulWidget {
  final BookEntity book;

  const BookingScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  final _buyerNameController = TextEditingController();
  final _shippingAddressController = TextEditingController();

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      final quantity = int.tryParse(_quantityController.text) ?? 1;
      final totalPrice = widget.book.price * quantity;

      context.read<BookingBloc>().add(
        SubmitBooking(
          bookId: widget.book.id!,
          quantity: quantity,
          buyerName: _buyerNameController.text,
          shippingAddress: _shippingAddressController.text,
          totalPrice: totalPrice,
        ),
      );
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _buyerNameController.dispose();
    _shippingAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Book'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking completed successfully')),
            );
            Navigator.pop(context);
          } else if (state is BookingFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is BookingSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      'http://192.168.157.46:5000/uploads/${book.coverImage}',
                      height: 140,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${book.genre} - ${book.author}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _specTile(
                        FontAwesomeIcons.book,
                        '${book.pageCount} pages',
                      ),
                      _specTile(
                        FontAwesomeIcons.weightHanging,
                        '${book.weightGrams} g',
                      ),
                      _specTile(
                        FontAwesomeIcons.tag,
                        'Npr ${book.price.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  _buildTextField(
                    controller: _quantityController,
                    label: 'Quantity',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final numVal = int.tryParse(value ?? '');
                      if (numVal == null || numVal < 1) {
                        return 'Enter valid quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _buyerNameController,
                    label: 'Buyer Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _shippingAddressController,
                    label: 'Shipping Address',
                    icon: Icons.location_on,
                  ),

                  const SizedBox(height: 20),

                  if (_quantityController.text.isNotEmpty)
                    _buildTotalPriceCard(book),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Confirm Booking'),
                      onPressed: _submitBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalPriceCard(BookEntity book) {
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final totalPrice = book.price * quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Price', style: TextStyle(fontSize: 16)),
          Text(
            'Npr ${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator:
          validator ??
          (value) =>
              value == null || value.isEmpty ? '$label is required' : null,
    );
  }

  Widget _specTile(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
