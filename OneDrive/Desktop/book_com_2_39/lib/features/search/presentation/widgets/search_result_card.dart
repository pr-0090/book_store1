import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';

class SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              // Book Cover
              Container(
                width: 60.w,
                height: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    // Handle different possible image field names from API
                    // Primary: images array (like in book_card.dart)
                    book['images'] != null && (book['images'] as List).isNotEmpty
                        ? book['images'][0]
                        : book['imageUrl'] ?? 
                          book['image'] ?? 
                          book['image_url'] ?? 
                          book['productImage'] ?? 
                          'https://placecats.com/200/300',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.book,
                          color: AppTheme.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              SizedBox(width: 12.w),
              
              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Handle different possible field names from API
                      book['title'] ?? 
                      book['productName'] ?? 
                      book['name'] ?? 
                      'Unknown Title',
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
                      'by ${book['author'] ?? 
                           book['authorName'] ?? 
                           book['author_name'] ?? 
                           'Unknown Author'}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            book['genre'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        Text(
                          'NPR ${(book['price'] ?? 0).toStringAsFixed(2)}',
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
              
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 