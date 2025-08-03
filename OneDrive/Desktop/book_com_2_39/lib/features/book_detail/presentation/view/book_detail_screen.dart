import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';
import '../../../../app/shared_prefs/analytics_service.dart';
import 'dart:async';
import 'dart:math';
import '../../../checkout/presentation/view/checkout_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int _quantity = 1;
  bool _isInWishlist = false;
  bool _isLoading = false;
  
  // 3D View variables
  StreamSubscription? _gyroscopeSubscription;
  StreamSubscription? _accelerometerSubscription;
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _rotationZ = 0.0;
  bool _is3DModeEnabled = false;
  double _tiltSensitivity = 0.5;

  @override
  void initState() {
    super.initState();
    _checkWishlistStatus();
    _initialize3DSensors();
    _trackBookView();
  }

  void _trackBookView() async {
    // Handle different possible field names from API
    final bookId = widget.book['id'] ?? 
                   widget.book['_id'] ?? 
                   'unknown';
    final bookTitle = widget.book['title'] ?? 
                      widget.book['productName'] ?? 
                      widget.book['name'] ?? 
                      'Unknown Book';
    await AnalyticsService.trackBookViewed(bookId.toString(), bookTitle.toString());
  }

  void _initialize3DSensors() {
    // Gyroscope for smooth 3D rotation
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (_is3DModeEnabled && mounted) {
        setState(() {
          // Apply gyroscope data to rotation with sensitivity
          _rotationX += event.x * _tiltSensitivity * 0.1;
          _rotationY += event.y * _tiltSensitivity * 0.1;
          _rotationZ += event.z * _tiltSensitivity * 0.05;
          
          // Clamp rotations to reasonable limits
          _rotationX = _rotationX.clamp(-0.5, 0.5);
          _rotationY = _rotationY.clamp(-0.5, 0.5);
          _rotationZ = _rotationZ.clamp(-0.3, 0.3);
        });
      }
    });

    // Accelerometer for additional tilt detection
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      if (_is3DModeEnabled && mounted) {
        // Use accelerometer for more responsive tilt
        final tiltX = event.x * _tiltSensitivity * 0.2;
        final tiltY = event.y * _tiltSensitivity * 0.2;
        
        setState(() {
          _rotationX = (_rotationX + tiltX).clamp(-0.5, 0.5);
          _rotationY = (_rotationY + tiltY).clamp(-0.5, 0.5);
        });
      }
    });
  }

  void _toggle3DMode() {
    setState(() {
      _is3DModeEnabled = !_is3DModeEnabled;
      if (!_is3DModeEnabled) {
        // Reset rotations when disabling 3D mode
        _rotationX = 0.0;
        _rotationY = 0.0;
        _rotationZ = 0.0;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_is3DModeEnabled 
          ? '🎯 3D Mode Enabled - Tilt your phone to see different angles!' 
          : '📱 3D Mode Disabled'),
        backgroundColor: _is3DModeEnabled ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkWishlistStatus() async {
    try {
      final userId = HiveService.getUserId();
      if (userId != null) {
        final response = await ApiService().getWishlist(userId);
        if (mounted && response.statusCode == 200) {
          final wishlistItems = response.data['wishlistItems'] as List<dynamic>;
          // Handle different possible field names from API
          final bookId = widget.book['_id'] ?? 
                         widget.book['id'] ?? 
                         '';
          final isInWishlist = wishlistItems.any((item) => 
            item['productId'] == bookId);
          
          setState(() {
            _isInWishlist = isInWishlist;
          });
        }
      }
    } catch (e) {
      print('Error checking wishlist status: $e');
    }
  }

  Future<void> _toggleWishlist() async {
    try {
      final userId = HiveService.getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to use wishlist'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Handle different possible field names from API
      final bookId = widget.book['_id'] ?? 
                     widget.book['id'] ?? 
                     '';

      if (_isInWishlist) {
        await ApiService().removeFromWishlist({
          'userId': userId,
          'productId': bookId,
        });
      } else {
        await ApiService().addToWishlist({
          'userId': userId,
          'productId': bookId,
        });
      }

      setState(() {
        _isInWishlist = !_isInWishlist;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isInWishlist 
            ? 'Added to wishlist!' 
            : 'Removed from wishlist'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _addToCart() async {
    try {
      final userId = HiveService.getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to add to cart'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Handle different possible field names from API
      final bookId = widget.book['_id'] ?? 
                     widget.book['id'] ?? 
                     '';

      await ApiService().addToCart({
        'userId': userId,
        'productId': bookId,
        'quantity': _quantity,
      });

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _buyNow() async {
    try {
      final userId = HiveService.getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to buy'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // First add to cart
      // Handle different possible field names from API
      final bookId = widget.book['_id'] ?? 
                     widget.book['id'] ?? 
                     '';
      final bookTitle = widget.book['title'] ?? 
                        widget.book['productName'] ?? 
                        widget.book['name'] ?? 
                        'Unknown Book';
      final bookPrice = widget.book['price'] ?? 0.0;

      await ApiService().addToCart({
        'userId': userId,
        'productId': bookId,
        'quantity': _quantity,
      });

      setState(() {
        _isLoading = false;
      });

      // Navigate to checkout
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            totalAmount: bookPrice * _quantity,
            cartItems: [
              {
                'productId': bookId,
                'productName': bookTitle,
                'quantity': _quantity,
                'price': bookPrice,
              }
            ],
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Details',
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
        actions: [
          // 3D Mode Toggle
          IconButton(
            icon: Icon(
              _is3DModeEnabled ? Icons.view_in_ar : Icons.view_in_ar_outlined,
              color: Colors.white,
            ),
            onPressed: _toggle3DMode,
            tooltip: 'Toggle 3D View',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3D Book Image
                  Container(
                    width: double.infinity,
                    height: 400.h,
                    margin: EdgeInsets.all(20.w),
                    child: _build3DBookImage(),
                  ),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Book Title
                        Text(
                          // Handle different possible field names from API
                          widget.book['title'] ?? 
                          widget.book['productName'] ?? 
                          widget.book['name'] ?? 
                          'Unknown Title',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        
                        SizedBox(height: 8.h),
                        
                        // Author
                        Text(
                          'by ${widget.book['author'] ?? 
                               widget.book['authorName'] ?? 
                               widget.book['author_name'] ?? 
                               'Unknown Author'}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        
                        SizedBox(height: 16.h),
                        
                        // Price
                        Text(
                          'NPR ${(widget.book['price'] ?? 0.0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // Quantity Selector
                        Row(
                          children: [
                            Text(
                              'Quantity:',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            IconButton(
                              onPressed: _quantity > 1 ? () {
                                setState(() {
                                  _quantity--;
                                });
                              } : null,
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: _quantity > 1 ? AppTheme.primaryColor : Colors.grey,
                              ),
                            ),
                            Text(
                              '$_quantity',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.book['description'] ?? 'No description available.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppTheme.textSecondaryColor,
                            height: 1.5,
                          ),
                        ),
                        
                        SizedBox(height: 32.h),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _toggleWishlist,
                                icon: Icon(
                                  _isInWishlist ? Icons.favorite : Icons.favorite_border,
                                  color: _isInWishlist ? Colors.white : AppTheme.primaryColor,
                                ),
                                label: Text(
                                  _isInWishlist ? 'Remove from Wishlist' : 'Add to Wishlist',
                                  style: TextStyle(
                                    color: _isInWishlist ? Colors.white : AppTheme.primaryColor,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isInWishlist 
                                    ? AppTheme.errorColor 
                                    : Colors.transparent,
                                  side: BorderSide(
                                    color: AppTheme.primaryColor,
                                    width: 1,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _addToCart,
                                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                                label: const Text(
                                  'Add to Cart',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 16.h),
                        
                        // Buy Now Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _buyNow,
                            icon: const Icon(Icons.flash_on, color: Colors.white),
                            label: const Text(
                              'Buy Now',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.successColor,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _build3DBookImage() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // Perspective
        ..rotateX(_rotationX)
        ..rotateY(_rotationY)
        ..rotateZ(_rotationZ),
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        height: 400.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Book cover image
              CachedNetworkImage(
                // Handle different possible image field names from API
                // Primary: images array (like in book_card.dart)
                imageUrl: widget.book['images'] != null && (widget.book['images'] as List).isNotEmpty
                    ? widget.book['images'][0]
                    : widget.book['image'] ?? 
                      widget.book['imageUrl'] ?? 
                      widget.book['image_url'] ?? 
                      widget.book['productImage'] ?? 
                      '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, size: 50),
                ),
              ),
              
              // 3D Mode indicator overlay
              if (_is3DModeEnabled)
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.view_in_ar,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '3D',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Tilt instructions overlay
              if (_is3DModeEnabled)
                Positioned(
                  bottom: 16.h,
                  left: 16.w,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '📱 Tilt your phone to see different angles',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
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