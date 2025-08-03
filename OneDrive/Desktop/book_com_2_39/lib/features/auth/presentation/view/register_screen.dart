import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../core/network/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService().register({
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'role': 'customer',
      });

      if (mounted) {
        if (response.statusCode == 201) {
          final data = response.data;
          // TODO: Store token and user data
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Registration successful'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
          
          // TODO: Navigate to home screen or onboarding
          Navigator.pop(context); // Go back to login screen
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
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
              // Back Button
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              
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
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        SizedBox(height: 8.h),
                        
                        Text(
                          'Join our digital bookstore',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(color: AppTheme.textPrimaryColor),
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            prefixIcon: const Icon(Icons.person_outlined, color: AppTheme.primaryColor),
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
                              return 'Please enter your name';
                            }
                            if (value.length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 20.h),
                        
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
                        
                        SizedBox(height: 20.h),
                        
                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: const TextStyle(color: AppTheme.textPrimaryColor),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            hintText: 'Confirm your password',
                            prefixIcon: const Icon(Icons.lock_outlined, color: AppTheme.primaryColor),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                color: AppTheme.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
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
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Terms and Conditions
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              activeColor: AppTheme.primaryColor,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms & Conditions',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // Register Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _register,
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
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // Sign In Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Sign In',
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