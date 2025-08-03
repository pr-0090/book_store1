import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../view_model/home_view_model.dart';
import '../widgets/book_card.dart';
import '../widgets/category_chip.dart';
import '../../../search/presentation/view/search_screen.dart';
import '../../../cart/presentation/view/cart_screen.dart';
import '../../../profile/presentation/view/profile_screen.dart';
import '../../../settings/presentation/view/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
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
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  // Header
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
                    child: Column(
                      children: [
                        // App Bar
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    viewModel.userEmail ?? 'user@example.com',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                );
                              },
                              icon: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                                );
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: viewModel.refreshBooks,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Recommended Books
                                  if (viewModel.recommendedBooks.isNotEmpty) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Recommended Books',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.textPrimaryColor,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: viewModel.refreshRecommendations,
                                     child: Container(
                                       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                       decoration: BoxDecoration(
                                         color: AppTheme.primaryColor.withOpacity(0.1),
                                         borderRadius: BorderRadius.circular(12),
                                         border: Border.all(
                                           color: AppTheme.primaryColor.withOpacity(0.3),
                                           width: 1,
                                         ),
                                       ),
                                       child: Row(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           Icon(
                                             Icons.refresh,
                                             size: 12.sp,
                                             color: AppTheme.primaryColor,
                                           ),
                                           SizedBox(width: 4.w),
                                           Text(
                                             'Shake for new',
                                             style: TextStyle(
                                               fontSize: 10.sp,
                                               color: AppTheme.primaryColor,
                                               fontWeight: FontWeight.w500,
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                height: 160.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: viewModel.recommendedBooks.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 12.w),
                                      child: SizedBox(
                                        width: 100.w,
                                        child: BookCard(
                                          book: viewModel.recommendedBooks[index],
                                          isFeatured: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 24.h),
                            ],
                            // Categories
                            Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            SizedBox(
                              height: 40.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: viewModel.categories.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 8.w),
                                    child: CategoryChip(
                                      label: viewModel.categories[index],
                                      isSelected: viewModel.selectedCategory == viewModel.categories[index],
                                      onTap: () {
                                        viewModel.setSelectedCategory(viewModel.categories[index]);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // New Arrivals / All Books
                            Text(
                              viewModel.selectedCategory == 'All' ? 'New Arrivals' : viewModel.selectedCategory,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            // Books Grid
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                              ),
                              itemCount: viewModel.filteredBooks.length,
                              itemBuilder: (context, index) {
                                return BookCard(
                                  book: viewModel.filteredBooks[index],
                                  isFeatured: false,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home screen
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
        },
      ),
    );
  }
}
