import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';

class OrderHistoryCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final String statusColor;
  final VoidCallback onTap;

  const OrderHistoryCard({
    super.key,
    required this.order,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = order['status'] ?? 'pending';
    final orderId = order['_id'] ?? 'N/A';
    final total = order['totalPrice'] ?? 0.0;
    final date = order['createdAt'] ?? '';
    final items = order['cartItems'] as List<dynamic>? ?? [];

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #$orderId',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Color(int.parse(statusColor.replaceAll('#', '0xFF'))),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // Items Preview
            if (items.isNotEmpty) ...[
              Text(
                'Items:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              SizedBox(height: 8.h),
              ...items.take(2).map((item) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.book,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // Handle different possible field names from API
                            item['productName'] ?? 
                            item['title'] ?? 
                            item['name'] ?? 
                            'Unknown Book',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Qty: ${item['quantity'] ?? 1}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'NPR ${(item['price'] ?? 0).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              )).toList(),
              
              if (items.length > 2) ...[
                SizedBox(height: 8.h),
                Text(
                  '... and ${items.length - 2} more items',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
            
            SizedBox(height: 12.h),
            
            // Footer
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: NPR ${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 