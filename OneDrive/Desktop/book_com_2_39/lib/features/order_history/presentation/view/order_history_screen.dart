import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../view_model/order_history_view_model.dart';
import '../widgets/order_history_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late OrderHistoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = OrderHistoryViewModel();
    _viewModel.loadOrders();
  }

  String _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '#FFA500'; // Orange
      case 'processing':
        return '#2196F3'; // Blue
      case 'shipped':
        return '#4CAF50'; // Green
      case 'delivered':
        return '#4CAF50'; // Green
      case 'cancelled':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<OrderHistoryViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Order History',
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
            body: viewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  )
                : viewModel.orders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 64.sp,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No orders yet',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Start shopping to see your orders here',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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
                                SizedBox(width: 12.w),
                                ElevatedButton(
                                  onPressed: viewModel.refreshOrders,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.secondaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Retry',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: viewModel.refreshOrders,
                        child: ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: viewModel.orders.length,
                          itemBuilder: (context, index) {
                            final order = viewModel.orders[index];
                            return OrderHistoryCard(
                              order: order,
                              statusColor: viewModel.getStatusColor(order['status'] ?? 'pending'),
                              onTap: () {
                                // Disabled - no action on tap
                              },
                            );
                          },
                        ),
                      ),
          );
        },
      ),
    );
  }
} 