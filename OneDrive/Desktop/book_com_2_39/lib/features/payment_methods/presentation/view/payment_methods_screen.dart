import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/hive_service.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String? _selectedPaymentMethod;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'credit_card',
      'name': 'Credit Card',
      'description': 'Visa, Mastercard',
      'icon': Icons.credit_card,
      'color': Colors.blue,
    },
    {
      'id': 'debit_card',
      'name': 'Debit Card',
      'description': 'Direct bank account payment',
      'icon': Icons.account_balance,
      'color': Colors.green,
    },
    {
      'id': 'esewa',
      'name': 'eSewa',
      'description': 'Pay with your eSewa account',
      'icon': Icons.payment,
      'color': Colors.indigo,
    },
    {
      'id': 'cash_on_delivery',
      'name': 'Cash on Delivery',
      'description': 'Pay when you receive your order',
      'icon': Icons.money,
      'color': Colors.orange,
    },

  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedPaymentMethod();
  }

  Future<void> _loadSelectedPaymentMethod() async {
    try {
      final savedMethod = HiveService.getSelectedPaymentMethod();
      setState(() {
        _selectedPaymentMethod = savedMethod;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectPaymentMethod(String methodId) async {
    try {
      await HiveService.saveSelectedPaymentMethod(methodId);
      setState(() {
        _selectedPaymentMethod = methodId;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment method updated successfully!'),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save payment method: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Methods',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.payment,
                          color: AppTheme.primaryColor,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Payment Method',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimaryColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Choose your preferred payment option',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Payment Methods List
                  Text(
                    'Available Payment Methods',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  ..._paymentMethods.map((method) => _buildPaymentMethodCard(method)).toList(),
                  
                  SizedBox(height: 24.h),
                  
                  // Info Section
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Your selected payment method will be used for all future orders. You can change this anytime.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];
    
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _selectPaymentMethod(method['id']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: method['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: method['id'] == 'esewa'
                    ? Image.asset(
                        'assets/images/esewa-icon-large.png',
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        method['icon'],
                        color: method['color'],
                        size: 24.sp,
                      ),
              ),
              
              SizedBox(width: 16.w),
              
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['name'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      method['description'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Selection Indicator
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppTheme.primaryColor : Colors.grey[300],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16.sp,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 