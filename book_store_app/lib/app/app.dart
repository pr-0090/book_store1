import 'package:book_store/app/theme/app_theme.dart';
import 'package:book_store/features/auth/presentation/view/login_view.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getApplicationTheme(isDarkMode: false),
      home: LoginView(),
    );
  }
}
