import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:book_store/features/auth/domain/entity/user_entity.dart';
import 'package:book_store/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _userremoteDatasource;

  UserRemoteRepository({required UserRemoteDatasource userremoteDatasoource})
    : _userremoteDatasource = userremoteDatasoource;

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final result = await _userremoteDatasource.loginUser(email, password);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      final result = await _userremoteDatasource.registerUser(user);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
