import 'package:flutter/material.dart';

@immutable
sealed class RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final BuildContext context;

  RegisterUserEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.context,
  });
}
