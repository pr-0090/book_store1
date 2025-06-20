import 'package:book_store/core/network/hive_service.dart';
import 'package:book_store/features/auth/data/data_source/user_datasource.dart';
import 'package:book_store/features/auth/data/model/user_hive_model.dart';
import 'package:book_store/features/auth/domain/entity/user_entity.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveservice})
    : _hiveService = hiveservice;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      if (user == null) {
        throw Exception("Invalid email or password");
      }
      return user.userId ?? '';
    } catch (e) {
      throw Exception("Login Failed:$e");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userModel = UserHiveModel.fromEntity(user);
      await _hiveService.registerUser(userModel);
    } catch (e) {
      throw Exception("Register failed: $e");
    }
  }
}
