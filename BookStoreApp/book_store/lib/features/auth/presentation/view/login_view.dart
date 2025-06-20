import 'dart:ui';
import 'package:book_store/app/service_locator/service_locator.dart';
import 'package:book_store/features/auth/presentation/view/register_view.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:book_store/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.white70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginViewModel, LoginState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Image.asset(
                'assets/images/landing.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Container(color: Colors.black.withOpacity(0.4)),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration(
                                  'Email Address',
                                  Icons.email,
                                ),
                                validator: (value) => value!.isEmpty
                                    ? 'Enter your email address'
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              ValueListenableBuilder(
                                valueListenable: _obscurePassword,
                                builder: (context, obscure, _) {
                                  return TextFormField(
                                    controller: _passwordController,
                                    obscureText: obscure,
                                    style: const TextStyle(color: Colors.white),
                                    decoration:
                                        _inputDecoration(
                                          'Password',
                                          Icons.lock,
                                        ).copyWith(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              obscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.white70,
                                            ),
                                            onPressed: () {
                                              _obscurePassword.value = !obscure;
                                            },
                                          ),
                                        ),
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter your password'
                                        : null,
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginViewModel>().add(
                                        LoginWithEmailAndPasswordEvent(
                                          context: context,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: state is LoginLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider<RegisterViewModel>(
                                                create: (_) =>
                                                    serviceLocator<
                                                      RegisterViewModel
                                                    >(),
                                                child: SignUpView(),
                                              ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.lightBlueAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'or continue with',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/facebook.png",
                                    width: 32,
                                  ),
                                  const SizedBox(width: 16),
                                  Image.asset(
                                    "assets/images/google.png",
                                    width: 32,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
