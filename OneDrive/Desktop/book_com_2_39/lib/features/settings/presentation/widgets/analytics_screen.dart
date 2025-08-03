import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../app/shared_prefs/analytics_service.dart';
import '../../../../app/shared_prefs/shared_prefs_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, dynamic> _analytics = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final analytics = await AnalyticsService.getAnalytics();
      final appLaunchCount = SharedPrefsService.getAppLaunchCount();
      final lastActiveDate = SharedPrefsService.getLastActiveDate();
      final lastVisitedScreen = SharedPrefsService.getLastVisitedScreen();

      setState(() {
        _analytics = {
          ...analytics,
          'appLaunchCount': appLaunchCount,
          'lastActiveDate': lastActiveDate,
          'lastVisitedScreen': lastVisitedScreen,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
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
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('App Usage'),
                  _buildAnalyticsCard([
                    _buildAnalyticsItem('App Launches', _analytics['appLaunchCount']?.toString() ?? '0'),
                    _buildAnalyticsItem('Total Session Time', '${_analytics['totalSessionTime'] ?? 0} minutes'),
                    _buildAnalyticsItem('Last Active', _formatDate(_analytics['lastActiveDate'])),
                    _buildAnalyticsItem('Last Screen', _analytics['lastVisitedScreen'] ?? 'None'),
                  ]),
                  
                  SizedBox(height: 24.h),
                  
                  _buildSectionTitle('User Activity'),
                  _buildAnalyticsCard([
                    _buildAnalyticsItem('Books Viewed', _analytics['booksViewed']?.toString() ?? '0'),
                    _buildAnalyticsItem('Searches Performed', _analytics['searchesPerformed']?.toString() ?? '0'),
                    _buildAnalyticsItem('Cart Items Added', _analytics['cartItemsAdded']?.toString() ?? '0'),
                    _buildAnalyticsItem('Orders Placed', _analytics['ordersPlaced']?.toString() ?? '0'),
                  ]),
                  
                  SizedBox(height: 24.h),
                  
                  _buildSectionTitle('Preferences'),
                  _buildAnalyticsCard([
                    _buildAnalyticsItem('Favorite Categories', _formatCategories(_analytics['favoriteCategories'] ?? [])),
                    _buildAnalyticsItem('Last Book Viewed', _formatLastBook(_analytics['lastBookViewed'])),
                  ]),
                  
                  SizedBox(height: 24.h),
                  
                  _buildSectionTitle('Actions'),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await AnalyticsService.clearAnalytics();
                            await SharedPrefsService.clearAllData();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Analytics data cleared'),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              );
                              _loadAnalytics();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.errorColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'Clear All Data',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildAnalyticsItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
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
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Never';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _formatCategories(List<String> categories) {
    if (categories.isEmpty) return 'None';
    return categories.take(3).join(', ') + (categories.length > 3 ? '...' : '');
  }

  String _formatLastBook(String? lastBook) {
    if (lastBook == null) return 'None';
    final parts = lastBook.split(':');
    return parts.length > 1 ? parts[1] : lastBook;
  }
} 