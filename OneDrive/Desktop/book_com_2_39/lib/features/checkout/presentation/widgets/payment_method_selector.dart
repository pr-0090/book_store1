import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final paymentMethods = [
      {
        'id': 'Credit Card',
        'name': 'Credit Card',
        'icon': Icons.credit_card,
        'description': 'Visa, Mastercard',
      },
      {
        'id': 'Debit Card',
        'name': 'Debit Card',
        'icon': Icons.account_balance,
        'description': 'Direct bank transfer',
      },
      {
        'id': 'eSewa',
        'name': 'eSewa',
        'icon': Icons.payment,
        'description': 'eSewa account',
      },
      {
        'id': 'Cash on Delivery',
        'name': 'Cash on Delivery',
        'icon': Icons.money,
        'description': 'Pay when you receive',
      },
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment,
                color: AppTheme.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          ...paymentMethods.map((method) => _buildPaymentOption(method)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(Map<String, dynamic> method) {
    final isSelected = selectedMethod == method['id'];
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile<String>(
        value: method['id'],
        groupValue: selectedMethod,
        onChanged: (value) => onMethodChanged(value!),
        title: Row(
          children: [
            // Show eSewa image icon if it's eSewa, otherwise show regular icon
            if (method['id'] == 'eSewa')
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.asset(
                  'assets/images/esewa-icon-large.png',
                  fit: BoxFit.contain,
                ),
              )
            else
              Icon(
                method['icon'],
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                size: 20.sp,
              ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    method['description'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        activeColor: AppTheme.primaryColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
    );
  }
} 