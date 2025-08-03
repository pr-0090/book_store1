import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/hive_service.dart';
import '../../../../app/shared_prefs/shared_prefs_service.dart';
import '../widgets/analytics_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadSettings();
  }

  void _loadUserInfo() {
    try {
      final user = HiveService.getCurrentUser();
      if (user != null) {
        setState(() {
          _userName = user.name;
          _userEmail = user.email;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _loadSettings() {
    setState(() {
      _notificationsEnabled = SharedPrefsService.getNotificationsEnabled();
      _darkModeEnabled = SharedPrefsService.getDarkMode();
      _biometricEnabled = SharedPrefsService.getBiometricEnabled();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName ?? 'User',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _userEmail ?? 'user@example.com',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Account Settings
            _buildSectionTitle('Account'),
            _buildSettingItem(
              icon: Icons.person,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {
                // TODO: Navigate to edit profile screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit Profile feature coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.lock,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () {
                // TODO: Navigate to change password screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Change Password feature coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            
            SizedBox(height: 24.h),
            
            // Preferences
            _buildSectionTitle('Preferences'),
            _buildSwitchItem(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Receive push notifications',
              value: _notificationsEnabled,
              onChanged: (value) async {
                setState(() {
                  _notificationsEnabled = value;
                });
                await SharedPrefsService.setNotificationsEnabled(value);
              },
            ),
            _buildSwitchItem(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Switch to dark theme',
              value: _darkModeEnabled,
              onChanged: (value) async {
                setState(() {
                  _darkModeEnabled = value;
                });
                await SharedPrefsService.setDarkMode(value);
              },
            ),
            _buildSwitchItem(
              icon: Icons.fingerprint,
              title: 'Biometric Login',
              subtitle: 'Use fingerprint or face ID',
              value: _biometricEnabled,
              onChanged: (value) async {
                setState(() {
                  _biometricEnabled = value;
                });
                await SharedPrefsService.setBiometricEnabled(value);
              },
            ),
            
            SizedBox(height: 24.h),
            
            // Privacy & Security
            _buildSectionTitle('Privacy & Security'),
            _buildSettingItem(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                // TODO: Show privacy policy
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy Policy feature coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.description,
              title: 'Terms of Service',
              subtitle: 'Read our terms of service',
              onTap: () {
                // TODO: Show terms of service
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terms of Service feature coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            
            SizedBox(height: 24.h),
            
            // Support
            _buildSectionTitle('Support'),
            _buildSettingItem(
              icon: Icons.help,
              title: 'Help Center',
              subtitle: 'Get help and find answers',
              onTap: () {
                // TODO: Navigate to help center
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Help Center feature coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.contact_support,
              title: 'Contact Support',
              subtitle: 'Get in touch with our team',
              onTap: () {
                // TODO: Navigate to contact support
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contact Support feature coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            
            SizedBox(height: 24.h),
            
            // About
            _buildSectionTitle('About'),
            _buildSettingItem(
              icon: Icons.analytics,
              title: 'Analytics',
              subtitle: 'View app usage statistics',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalyticsScreen(),
                  ),
                );
              },
            ),
            _buildSettingItem(
              icon: Icons.info,
              title: 'About Book.com',
              subtitle: 'Version 1.0.0',
              onTap: () {
                // TODO: Show about dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('About feature coming soon!'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
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

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
} 