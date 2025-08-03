import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/api_service.dart';
import '../../../book_detail/presentation/view/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final bool isFeatured;

  const BookCard({
    super.key,
    required this.book,
    this.isFeatured = false,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = book['images'] != null && (book['images'] as List).isNotEmpty
        ? book['images'][0]
        : 'https://via.placeholder.com/150x200?text=No+Image';
    
    final String title = book['title'] ?? 'Unknown Title';
    final String author = book['author'] ?? 'Unknown Author';
    final double price = (book['price'] ?? 0.0).toDouble();
    final String genre = book['genre'] ?? 'Unknown Genre';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(book: book),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Cover
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.book, size: 50),
                  ),
                ),
              ),
            ),
          ),
          // Book Info - Title and Author Only
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 