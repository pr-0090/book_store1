import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../../../../core/theme/app_theme.dart';
import '../../../order_history/presentation/view/order_history_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final String orderId;
  final double totalAmount;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
            ),
          ),
          
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon
                  Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 80.sp,
                      color: Colors.green,
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Success Message
                  Text(
                    'Order Placed Successfully!',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  Text(
                    'Thank you for your purchase. Your order has been confirmed and will be processed soon.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Order Details
                  Container(
                    padding: EdgeInsets.all(20.w),
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ID:',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            Text(
                              '#${widget.orderId.substring(0, 8)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount:',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            Text(
                              'NPR ${widget.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: BorderSide(color: AppTheme.primaryColor),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Continue Shopping',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 16.w),
                      
                                                 Expanded(
                             child: ElevatedButton(
                               onPressed: () {
                                 Navigator.pushReplacement(
                                   context,
                                   MaterialPageRoute(
                                     builder: (context) => const OrderHistoryScreen(),
                                   ),
                                 );
                               },
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: AppTheme.primaryColor,
                                 foregroundColor: Colors.white,
                                 padding: EdgeInsets.symmetric(vertical: 16.h),
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(12),
                                 ),
                               ),
                               child: Text(
                                 'View Orders',
                                 style: TextStyle(
                                   fontSize: 16.sp,
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                             ),
                           ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 