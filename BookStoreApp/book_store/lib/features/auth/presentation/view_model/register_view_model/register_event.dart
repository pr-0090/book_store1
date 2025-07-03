import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  final BuildContext context;

  RegisterUserEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.context,
  });
}
