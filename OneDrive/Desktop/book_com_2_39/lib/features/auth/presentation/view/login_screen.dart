import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';
import '../../../../core/models/user_model.dart';
import 'register_screen.dart';
import '../../../home/presentation/view/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService().login({
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      });

      if (mounted) {
        if (response.statusCode == 200) {
          // Store token and user data
          final data = response.data;
          
          // Create user model and save to Hive
          final user = UserModel.fromJson(data);
          await HiveService.saveUser(user);
          
          print('Login: Saved user data - Name: ${user.name}, Email: ${user.email}');
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Login successful'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
          
          // Navigate to home screen
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const HomeScreen())
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Login failed';
        if (e.toString().contains('401')) {
          errorMessage = 'Email or password is incorrect';
        } else if (e.toString().contains('404')) {
          errorMessage = 'Server not found. Please check your connection';
        } else if (e.toString().contains('500')) {
          errorMessage = 'Server error. Please try again later';
        } else if (e.toString().contains('timeout')) {
          errorMessage = 'Connection timeout. Please try again';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea), // Cool blue
              Color(0xFF764ba2), // Purple
              Color(0xFFf093fb), // Soft pink
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo
                        Center(
                          child: Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.book,
                                    size: 40,
                                    color: AppTheme.primaryColor,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Welcome Text
                        Text(
                          'Welcome Back!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        SizedBox(height: 8.h),
                        
                        Text(
                          'Sign in to your account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: AppTheme.textPrimaryColor),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.primaryColor),
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
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: AppTheme.textPrimaryColor),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outlined, color: AppTheme.primaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: AppTheme.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
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
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // Login Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                                  ),
                                )
                              : Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 