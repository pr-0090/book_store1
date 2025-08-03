import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';

class OrderSummary extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const OrderSummary({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) {
      final price = (item['price'] ?? 0.0).toDouble();
      final quantity = (item['quantity'] ?? 1).toInt();
      return sum + (price * quantity);
    });
  }

  double get tax => subtotal * 0.1; // 10% tax
  double get shipping => subtotal > 50 ? 0 : 5.99; // Free shipping over $50

  @override
  Widget build(BuildContext context) {
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
                Icons.shopping_cart,
                color: AppTheme.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Cart Items
          ...cartItems.map((item) => _buildCartItem(item)),
          
          SizedBox(height: 16.h),
          
          Divider(),
          
          SizedBox(height: 16.h),
          
          // Price Breakdown
          _buildPriceRow('Subtotal', subtotal),
          SizedBox(height: 8.h),
          _buildPriceRow('Tax (10%)', tax),
          SizedBox(height: 8.h),
          _buildPriceRow('Shipping', shipping, isShipping: true),
          
          SizedBox(height: 16.h),
          
          Divider(),
          
          SizedBox(height: 16.h),
          
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              Text(
                'NPR ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    // Handle different possible field names from API
    final String productName = item['productName'] ?? 
                              item['title'] ?? 
                              item['name'] ?? 
                              'Unknown Book';
    
    final String author = item['author'] ?? 
                         item['authorName'] ?? 
                         item['author_name'] ?? 
                         'Unknown Author';
    
    final double price = (item['price'] ?? 0.0).toDouble();
    final int quantity = (item['quantity'] ?? 1).toInt();
    
    // Handle different possible image field names
    final String productImage = item['productImage'] ?? 
                               item['image'] ?? 
                               item['imageUrl'] ?? 
                               item['image_url'] ?? 
                               'https://via.placeholder.com/60x80?text=No+Image';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          // Book Cover
          Container(
            width: 60.w,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.surfaceColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: productImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.book,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Book Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Qty: $quantity',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Price
          Text(
            'NPR ${(price * quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isShipping = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        Text(
          isShipping && amount == 0 ? 'Free' : 'NPR ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isShipping && amount == 0 ? Colors.green : AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }
} 