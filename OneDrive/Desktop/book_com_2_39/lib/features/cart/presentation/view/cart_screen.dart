import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';
import '../../../checkout/presentation/view/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final userId = HiveService.getUserId();
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to view your cart'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      _userId = userId;
      final response = await ApiService().getCart(userId);
      if (mounted && response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _cartItems = List<Map<String, dynamic>>.from(data['cart'] ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cart: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _updateQuantity(String productId, int quantity) async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to manage cart'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    try {
      await ApiService().updateCartItem({
        'userId': _userId!,
        'productId': productId,
        'quantity': quantity,
      });
      _loadCart(); // Reload cart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update quantity: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _removeItem(String productId) async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to manage cart'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    try {
      await ApiService().removeFromCart({
        'userId': _userId!,
        'productId': productId,
      });
      _loadCart(); // Reload cart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove item: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  double get _subtotal {
    return _cartItems.fold(0.0, (sum, item) {
      final price = (item['price'] ?? 0.0).toDouble();
      final quantity = (item['quantity'] ?? 1).toInt();
      return sum + (price * quantity);
    });
  }

  double get _tax => _subtotal * 0.1; // 10% tax
  double get _shipping => _subtotal > 50 ? 0 : 5.99; // Free shipping over $50
  double get _total => _subtotal + _tax + _shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          if (_cartItems.isNotEmpty)
            TextButton(
              onPressed: () async {
                if (_userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please login to manage cart'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                  return;
                }
                try {
                  await ApiService().clearCart({'userId': _userId!});
                  _loadCart();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to clear cart: ${e.toString()}'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                }
              },
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? _buildEmptyCart()
              : _buildCartContent(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.sp,
            color: AppTheme.textSecondaryColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add some books to get started!',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Go back to home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Start Shopping',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        // Cart Items
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadCart,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return _buildCartItem(item);
              },
            ),
          ),
        ),
        
        // Order Summary
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Summary Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  Text(
                    'NPR ${_subtotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
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
                    'Tax',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  Text(
                    'NPR ${_tax.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
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
                    'Shipping',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  Text(
                    _shipping == 0 ? 'Free' : 'NPR ${_shipping.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: _shipping == 0 ? Colors.green : AppTheme.textPrimaryColor,
                    ),
                  ),
                ],
              ),
              Divider(height: 24.h),
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
                    'NPR ${_total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              
              // Checkout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          totalAmount: _total,
                          cartItems: _cartItems,
                        ),
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
                    'Proceed to Checkout',
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
      ],
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final String productId = item['productId'] ?? '';
    
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
                               'https://via.placeholder.com/80x120?text=No+Image';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Book Cover
          Container(
            width: 80.w,
            height: 120.h,
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
                    size: 30,
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'NPR ${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          Column(
            children: [
              // Remove Button
              IconButton(
                onPressed: () => _removeItem(productId),
                icon: Icon(
                  Icons.delete_outline,
                  color: AppTheme.errorColor,
                  size: 20.sp,
                ),
              ),
              
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: quantity > 1 ? () {
                        _updateQuantity(productId, quantity - 1);
                      } : null,
                      icon: Icon(
                        Icons.remove,
                        size: 16.sp,
                        color: quantity > 1 ? AppTheme.primaryColor : Colors.grey,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _updateQuantity(productId, quantity + 1);
                      },
                      icon: Icon(
                        Icons.add,
                        size: 16.sp,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 