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
  final _gap = const SizedBox(height: 12);

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
    return BlocBuilder<LoginViewModel, LoginState>(
      builder: (context, state) {
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
                      Image.asset('assets/images/landing.png', height: 120),
                      const SizedBox(height: 30),
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                decoration: _inputDecoration(
                                  'Email',
                                  Icons.email,
                                ),
                                validator: (value) => value!.isEmpty
                                    ? 'Enter your email Address'
                                    : null,
                              ),
                              _gap,
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
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter your password'
                                        : null,
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle forgot password
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFB24747),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final email = _emailController.text.trim();
                                    final password = _passwordController.text;

                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginViewModel>().add(
                                        LoginWithEmailAndPasswordEvent(
                                          context: context,
                                          email: email,
                                          password: password,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB24747),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: state is LoginLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text('Login'),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(fontSize: 13),
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
                                      'Sign up',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color.fromARGB(255, 36, 43, 255),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/facebook.png", width: 32),
                          const SizedBox(width: 16),
                          Image.asset("assets/images/google.png", width: 32),
                        ],
                      ),
                    ],
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
