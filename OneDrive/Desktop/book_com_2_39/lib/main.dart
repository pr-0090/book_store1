import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/app.dart';
import 'core/network/hive_service.dart';
import 'core/network/api_service.dart';
import 'core/theme/app_theme.dart';
import 'app/shared_prefs/shared_prefs_service.dart';
import 'app/shared_prefs/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  await SharedPrefsService.init();
  
  // Initialize Hive
  await HiveService.init();
  
  // Initialize API Service
  ApiService().init();
  
  // Track app launch
  await SharedPrefsService.incrementAppLaunchCount();
  await SharedPrefsService.setLastActiveDate(DateTime.now().toIso8601String());
  
  // Start analytics session
  await AnalyticsService.startSession();
  
  runApp(const BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Book.com',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const SplashScreen(), // You'll create this
        );
      },
    );
  }
}
