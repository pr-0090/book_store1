import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';
import '../widgets/address_form.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/order_summary.dart';
import '../view/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  
  String _selectedPaymentMethod = 'Credit Card';
  bool _isLoading = false;
  Map<String, dynamic>? _savedAddress;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
    _loadSavedPaymentMethod();
  }

  Future<void> _loadSavedAddress() async {
    try {
      final response = await ApiService().getAddress();
      if (mounted && response.statusCode == 200) {
        final address = response.data['address'];
        if (address != null) {
          setState(() {
            _savedAddress = address;
            _fullNameController.text = address['fullName'] ?? '';
            _phoneController.text = address['phoneNumber'] ?? '';
            _streetAddressController.text = address['streetAddress'] ?? '';
            _landmarkController.text = address['landmark'] ?? '';
            _cityController.text = address['city'] ?? '';
            _stateController.text = address['state'] ?? '';
            _countryController.text = address['country'] ?? '';
          });
        }
      }
    } catch (e) {
      // Address not found or error, continue with empty form
      print('Address loading error: $e');
    }
  }

  void _loadSavedPaymentMethod() {
    final savedMethod = HiveService.getSelectedPaymentMethod();
    if (savedMethod != null) {
      // Map the saved method ID to display name
      final methodMap = {
        'credit_card': 'Credit Card',
        'debit_card': 'Debit Card',
        'esewa': 'eSewa',
        'cash_on_delivery': 'Cash on Delivery',
      };
      setState(() {
        _selectedPaymentMethod = methodMap[savedMethod] ?? 'Credit Card';
      });
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = HiveService.getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to place order'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Check if user has items in cart
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty. Please add items before placing an order.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Validate required fields
    if (_fullNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _streetAddressController.text.trim().isEmpty ||
        _landmarkController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty ||
        _stateController.text.trim().isEmpty ||
        _countryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required address fields'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Ensure API service is initialized
      ApiService().init();
      
      // Create order with address information only (backend fetches cart automatically)
      final orderData = {
        'userId': userId,
        'payment': _selectedPaymentMethod,
        'fullName': _fullNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'streetAddress': _streetAddressController.text.trim(),
        'landmark': _landmarkController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'country': _countryController.text.trim(),
      };
      
      print('Creating order with data: $orderData');
      print('User ID: $userId');
      print('Cart items: ${widget.cartItems}');
      
      final orderResponse = await ApiService().createOrder(orderData);
      print('Order response status: ${orderResponse.statusCode}');
      print('Order response data: ${orderResponse.data}');
      
      if (orderResponse.statusCode != 201) {
        print('Order creation failed with status: ${orderResponse.statusCode}');
        print('Error response: ${orderResponse.data}');
        
        // Show specific error message based on backend response
        String errorMessage = 'Failed to place order';
        if (orderResponse.data != null && orderResponse.data['message'] != null) {
          errorMessage = orderResponse.data['message'];
        } else if (orderResponse.statusCode == 401) {
          errorMessage = 'Please login again to place your order';
        } else if (orderResponse.statusCode == 400) {
          errorMessage = 'Please check your order details and try again';
        } else if (orderResponse.statusCode == 500) {
          errorMessage = 'Server error. Please try again later';
        }
        
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
        return;
      }

      if (mounted && orderResponse.statusCode == 201) {
        // Clear cart after successful order
        await ApiService().clearCart({'userId': userId});
        
        // Navigate to success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessScreen(
              orderId: orderResponse.data['order']['_id'],
              totalAmount: widget.totalAmount,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        String errorMessage = 'Failed to place order';
        if (e.toString().contains('SocketException') || e.toString().contains('Connection refused')) {
          errorMessage = 'Network error. Please check your internet connection';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Request timeout. Please try again';
        } else {
          errorMessage = 'Failed to place order: ${e.toString()}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _streetAddressController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    OrderSummary(
                      cartItems: widget.cartItems,
                      totalAmount: widget.totalAmount,
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Address Form
                    AddressForm(
                      fullNameController: _fullNameController,
                      phoneController: _phoneController,
                      streetAddressController: _streetAddressController,
                      landmarkController: _landmarkController,
                      cityController: _cityController,
                      stateController: _stateController,
                      countryController: _countryController,
                      savedAddress: _savedAddress,
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Payment Method
                    PaymentMethodSelector(
                      selectedMethod: _selectedPaymentMethod,
                      onMethodChanged: (method) {
                        setState(() {
                          _selectedPaymentMethod = method;
                        });
                      },
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Place Order Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 