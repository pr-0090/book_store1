import 'package:book_store/core/error/failure.dart';
import 'package:book_store/features/auth/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);
  Future<Either<Failure, String>> loginUser(String email, String password);
}
