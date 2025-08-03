import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';
import '../widgets/profile_menu_item.dart';
import '../../../settings/presentation/view/settings_screen.dart';
import '../../../order_history/presentation/view/order_history_screen.dart';
import '../../../auth/presentation/view/login_screen.dart';
import '../../../wishlist/presentation/view/wishlist_screen.dart';
import '../../../addresses/presentation/view/addresses_screen.dart';
import '../../../payment_methods/presentation/view/payment_methods_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // First try to get from Hive
      final user = HiveService.getCurrentUser();
      if (user != null && user.email != null && user.email!.isNotEmpty) {
        setState(() {
          _userData = {
            'email': user.email,
            'role': user.role ?? 'Customer',
          };
          _isLoading = false;
        });
        print('Profile: Loaded user data from Hive: ${user.email}');
        return;
      }
      
      // Fallback to API
      final response = await ApiService().getCurrentUser();
      if (mounted && response.statusCode == 200) {
        setState(() {
          _userData = response.data['user'];
          _isLoading = false;
        });
        print('Profile: Loaded user data from API: ${_userData?['email']}');
      }
    } catch (e) {
      print('Profile: Error loading user data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      // Clear stored user data from Hive
      await HiveService.clearUser();
      
      // Clear stored token
      ApiService().removeAuthToken();
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
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
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF667eea),
                          Color(0xFF764ba2),
                          Color(0xFFf093fb),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 40.r,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            size: 40.sp,
                            color: Colors.white,
                          ),
                        ),
                        
                        SizedBox(width: 16.w),
                        
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userData?['email'] ?? 'user@example.com',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _userData?['role'] ?? 'Customer',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Menu Items
                  ProfileMenuItem(
                    icon: Icons.shopping_bag,
                    title: 'Order History',
                    subtitle: 'View your past orders',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                      );
                    },
                  ),
                  
                  ProfileMenuItem(
                    icon: Icons.favorite,
                    title: 'Wishlist',
                    subtitle: 'Your saved books',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WishlistScreen()),
                      );
                    },
                  ),
                  

                  
                  ProfileMenuItem(
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    subtitle: 'Manage your payment options',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                      );
                    },
                  ),
                  

                  
                  SizedBox(height: 24.h),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout),
                          SizedBox(width: 8.w),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 