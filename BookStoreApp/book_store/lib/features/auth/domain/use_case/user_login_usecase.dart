import 'package:book_store/app/shared_pref/token_shared_prefs.dart';
import 'package:book_store/app/use_case/use_case.dart';
import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UserLoginParams extends Equatable {
  final String email;
  final String password;

  const UserLoginParams({required this.email, required this.password});

  const UserLoginParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class UserLoginUsecase implements UseCaseWithParams<String, UserLoginParams> {
  final IUserRepository _userRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLoginUsecase({
    required IUserRepository userRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _userRepository = userRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, String>> call(UserLoginParams params) async {
    final result = await _userRepository.loginUser(
      params.email,
      params.password,
    );

    return result.fold((failure) => Left(failure), (token) async {
      await _tokenSharedPrefs.saveToken(token);
      return Right(token);
    });
  }
}
