import 'package:flutter/material.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';

class OrderHistoryViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasOrders => _orders.isNotEmpty;

  Future<void> loadOrders() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userId = HiveService.getUserId();
      if (userId == null) {
        _errorMessage = 'Please login to view your orders';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await ApiService().getUserOrders(userId);
      print('Order History Response: ${response.statusCode}');
      print('Order History Data: ${response.data}');
      
      if (response.statusCode == 200) {
        _orders = List<Map<String, dynamic>>.from(response.data['orders'] ?? []);
        _isLoading = false;
        notifyListeners();
      } else if (response.statusCode == 500) {
        // Backend error - show user-friendly message
        _errorMessage = 'Order history temporarily unavailable. Please try again later.';
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to load orders: Status ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load orders: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  String getStatusColor(String status) {
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

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  List<Map<String, dynamic>> getOrdersByStatus(String status) {
    return _orders.where((order) => 
      order['status']?.toString().toLowerCase() == status.toLowerCase()
    ).toList();
  }

  List<Map<String, dynamic>> getRecentOrders(int count) {
    final sortedOrders = List<Map<String, dynamic>>.from(_orders);
    sortedOrders.sort((a, b) {
      final dateA = DateTime.tryParse(a['createdAt'] ?? '');
      final dateB = DateTime.tryParse(b['createdAt'] ?? '');
      if (dateA == null || dateB == null) return 0;
      return dateB.compareTo(dateA);
    });
    return sortedOrders.take(count).toList();
  }

  double getTotalOrderValue() {
    return _orders.fold(0.0, (sum, order) {
      final total = order['total']?.toDouble() ?? 0.0;
      return sum + total;
    });
  }

  int getOrderCount() {
    return _orders.length;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }
} 