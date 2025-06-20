import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginWithEmailAndPasswordEvent extends LoginEvent {
  final BuildContext context;
  final String email;
  final String password;

  const LoginWithEmailAndPasswordEvent({
    required this.context,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [context, email, password];
}

class NavigateToRegisterViewEvent extends LoginEvent {
  final BuildContext context;

  const NavigateToRegisterViewEvent({required this.context});

  @override
  List<Object?> get props => [context];
}
