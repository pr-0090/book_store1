import 'dart:ui';
import 'package:book_store/app/service_locator/service_locator.dart';
import 'package:book_store/features/auth/presentation/view/login_view.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:book_store/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:book_store/features/auth/presentation/view_model/register_view_model/register_state.dart';
import 'package:book_store/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.white),
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
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/landing.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
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
                    child: BlocBuilder<RegisterViewModel, RegisterState>(
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration(
                                  'Full Name',
                                  Icons.person,
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'Enter your name' : null,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration(
                                  'Email ',
                                  Icons.email,
                                ),
                                validator: (value) => value!.isEmpty
                                    ? 'Enter your email address'
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              ValueListenableBuilder<bool>(
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
                                        ? 'Enter a password'
                                        : null,
                                  );
                                },
                              ),
                              const SizedBox(height: 14),
                              ValueListenableBuilder<bool>(
                                valueListenable: _obscurePassword,
                                builder: (context, obscure, _) {
                                  return TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: obscure,
                                    style: const TextStyle(color: Colors.white),
                                    decoration:
                                        _inputDecoration(
                                          'Confirm Password',
                                          Icons.lock_outline,
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Re-enter password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<RegisterViewModel>()
                                                .add(
                                                  RegisterUserEvent(
                                                    username: _nameController
                                                        .text
                                                        .trim(),
                                                    email: _emailController.text
                                                        .trim(),
                                                    password:
                                                        _passwordController.text
                                                            .trim(),
                                                    context: context,
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
                                  child: state.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'Sign Up',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value:
                                                serviceLocator<
                                                  LoginViewModel
                                                >(),
                                            child: LoginView(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.lightBlueAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
