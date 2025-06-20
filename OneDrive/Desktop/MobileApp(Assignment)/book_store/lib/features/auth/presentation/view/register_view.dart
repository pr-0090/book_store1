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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/landing.png', fit: BoxFit.cover),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/landing.png', height: 100),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: BlocBuilder<RegisterViewModel, RegisterState>(
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _nameController,
                                decoration: _inputDecoration(
                                  'Name',
                                  Icons.person,
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Enter your name'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _emailController,
                                decoration: _inputDecoration(
                                  'Email',
                                  Icons.email,
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Enter your email'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              ValueListenableBuilder<bool>(
                                valueListenable: _obscurePassword,
                                builder: (context, obscure, _) {
                                  return TextFormField(
                                    controller: _passwordController,
                                    obscureText: obscure,
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
                                            ),
                                            onPressed: () {
                                              _obscurePassword.value = !obscure;
                                            },
                                          ),
                                        ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                        ? 'Enter password'
                                        : null,
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              ValueListenableBuilder<bool>(
                                valueListenable: _obscurePassword,
                                builder: (context, obscure, _) {
                                  return TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: obscure,
                                    decoration:
                                        _inputDecoration(
                                          'Confirm Password',
                                          Icons.lock,
                                        ).copyWith(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              obscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
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
                              const SizedBox(height: 20),
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
                                                    name: _nameController.text
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
                                    backgroundColor: const Color(0xFF9ECEFE),
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
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Already have an account?',
                                    style: TextStyle(fontSize: 13),
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
                                    child: const Text('Login'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
