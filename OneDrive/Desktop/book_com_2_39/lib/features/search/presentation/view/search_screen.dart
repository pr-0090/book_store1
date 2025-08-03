import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../view_model/search_view_model.dart';
import '../../../book_detail/presentation/view/book_detail_screen.dart';
import '../widgets/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SearchViewModel();
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Search Books',
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
            body: Column(
              children: [
                // Search Bar
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
                  child: Form(
                    key: viewModel.formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: viewModel.searchController,
                            style: const TextStyle(color: AppTheme.textPrimaryColor),
                            decoration: InputDecoration(
                              hintText: 'Search by title, author, or genre...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a search term';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => viewModel.performSearch(),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed: viewModel.isLoading ? null : viewModel.performSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: viewModel.isLoading
                              ? SizedBox(
                                  height: 16.h,
                                  width: 16.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                                  ),
                                )
                              : Text(
                                  'Search',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Search History (when no search has been performed)
                if (!viewModel.hasSearched && viewModel.hasRecentSearches)
                  Container(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Searches',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: viewModel.clearSearchHistory,
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: viewModel.searchHistory.map((term) => GestureDetector(
                            onTap: () {
                              viewModel.selectSearchHistoryItem(term);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                term,
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                
                // Search Results
                Expanded(
                  child: viewModel.hasSearched
                      ? viewModel.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                              ),
                            )
                          : viewModel.searchResults.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64.sp,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'No books found',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'Try different keywords',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.all(16.w),
                                  itemCount: viewModel.searchResults.length,
                                  itemBuilder: (context, index) {
                                    final book = viewModel.searchResults[index];
                                    return SearchResultCard(
                                      book: book,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BookDetailScreen(book: book),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 64.sp,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Search for books',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Enter a title, author, or genre',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
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