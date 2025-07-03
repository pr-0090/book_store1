import 'package:book_store/app/use_case/use_case.dart';
import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/auth/domain/entity/user_entity.dart';
import 'package:book_store/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RegisterUserParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const RegisterUserParams({
    required this.name,
    required this.email,
    required this.password,
  });
  const RegisterUserParams.initial() : name = '', email = '', password = '';

  @override
  List<Object?> get props => [name, email, password];
}

class RegisterUserUseCase
    implements UseCaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  RegisterUserUseCase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) async {
    final user = UserEntity(
      username: params.name,
      email: params.email,
      password: params.password,
    );
    debugPrint("RegisterUserUseCase called with: $user");

    try {
      await _userRepository.registerUser(user);
      return Right(null);
    } catch (e) {
      final cleanedMessage = e.toString().replaceAll('Exception: ', '');
      return Left(
        ApiFailure(message: 'Failed to register user: $cleanedMessage'),
      );
    }
  }
}
