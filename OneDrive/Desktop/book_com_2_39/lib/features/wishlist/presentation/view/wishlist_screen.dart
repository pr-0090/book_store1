import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';
import '../../../home/presentation/widgets/book_card.dart';
import '../../../book_detail/presentation/view/book_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> _wishlistItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final userId = HiveService.getUserId();
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _error = 'Please login to view your wishlist';
        });
        return;
      }

                    final response = await ApiService().getWishlist(userId);
       if (mounted && response.statusCode == 200) {
         final List<dynamic> wishlistData = response.data['wishlist'] ?? [];
         
         // Convert wishlist items to book format for display
         final List<Map<String, dynamic>> books = [];
         for (var item in wishlistData) {
           // Wishlist items have product data directly, not nested
           final book = {
             '_id': item['productId'],
             'title': item['productName'],
             'images': [item['productImage'] ?? item['imageUrl'] ?? ''], // BookCard expects images array
             'price': item['price'],
             'author': item['author'],
             'genre': item['genre'],
           };
           books.add(book);
         }

        setState(() {
          _wishlistItems = books;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load wishlist';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Error loading wishlist: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _removeFromWishlist(String productId) async {
    try {
      final userId = HiveService.getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to manage wishlist'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      await ApiService().removeFromWishlist({
        'userId': userId,
        'productId': productId,
      });

      // Remove from local list
      setState(() {
        _wishlistItems.removeWhere((item) => item['_id'] == productId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from wishlist'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove from wishlist: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _navigateToBookDetail(Map<String, dynamic> book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailScreen(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
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
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'My Wishlist',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: _loadWishlist,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppTheme.errorColor,
            ),
            SizedBox(height: 16.h),
            Text(
              _error!,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _loadWishlist,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_wishlistItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64.sp,
              color: AppTheme.textSecondaryColor,
            ),
            SizedBox(height: 16.h),
            Text(
              'Your wishlist is empty',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add books to your wishlist to see them here',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadWishlist,
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: _wishlistItems.length,
        itemBuilder: (context, index) {
          final book = _wishlistItems[index];
          return GestureDetector(
            onTap: () => _navigateToBookDetail(book),
            child: Stack(
              children: [
                BookCard(
                  book: book,
                  isFeatured: false,
                ),
                // Remove from wishlist button
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _removeFromWishlist(book['_id']),
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 16,
                      ),
                      padding: EdgeInsets.all(4.w),
                      constraints: BoxConstraints(
                        minWidth: 32.w,
                        minHeight: 32.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 